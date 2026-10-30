import 'dart:async';

import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/core/theme/typography/app_typography_extension.dart';
import 'package:farmer_consultant/core/theme/app_dynamic_colors.dart';
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/plot_finance_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_event.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_state.dart';
import 'package:farmer_consultant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlotFinanceScreen extends StatefulWidget {
  final String plotId;
  final String acres;
  final String cropName;
  final String plotName;

  const PlotFinanceScreen({
    super.key,
    required this.plotId,
    required this.acres,
    required this.cropName,
    required this.plotName,
  });

  @override
  State<PlotFinanceScreen> createState() => _PlotFinanceScreenState();
}

class _PlotFinanceScreenState extends State<PlotFinanceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _historyTabController;

  @override
  void initState() {
    super.initState();
    _historyTabController = TabController(length: 2, vsync: this);
  }

  // Keep shared responsive typography with a slightly denser screen layout.
  TextStyle _compactStyle(TextStyle style) => style.copyWith(
    fontSize: style.fontSize == null ? null : style.fontSize! * 0.9,
  );

  Color get green => context.appSuccess;
  Color get red => context.appError;
  Color get blue => context.appPrimary;
  Color get ink => context.appText;
  Color get muted => context.appSubText;
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  NumberFormat get currencyFormat =>
      NumberFormat.decimalPattern(l10n.localeName);
  DateFormat get dateFormat => DateFormat.yMd(l10n.localeName);

  // Live transaction lists loaded from GetPlotFinanceEvent.
  final List<PlotTransaction> expenses = [];
  final List<PlotTransaction> revenues = [];

  CropBloc? _expenseListBloc;
  CropBloc? _incomeListBloc;
  StreamSubscription<CropState>? _expenseSubscription;
  StreamSubscription<CropState>? _incomeSubscription;
  bool _initialized = false;
  bool _loadingExpense = true;
  bool _loadingIncome = true;
  String? _expenseError;
  String? _incomeError;
  String _farmerId = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final usecases = context.read<CropBloc>().cropScheduleUsecases;
    // Separate BLoCs prevent Expense/Income responses and cropStatus from
    // overwriting or blocking one another.
    _expenseListBloc = CropBloc(cropScheduleUsecases: usecases);
    _incomeListBloc = CropBloc(cropScheduleUsecases: usecases);

    _expenseSubscription = _expenseListBloc!.stream.listen((financeState) {
      if (!mounted) return;
      if (financeState.cropStatus == CropStatus.loading) {
        setState(() {
          _loadingExpense = true;
          _expenseError = null;
        });
      } else if (financeState.cropStatus == CropStatus.success) {
        final finance = financeState.plotFinanceEntity;
        setState(() {
          _loadingExpense = false;
          _expenseError = null;
          expenses
            ..clear()
            ..addAll(_mapTransactions(finance?.result ?? []));
        });
      } else if (financeState.cropStatus == CropStatus.failure) {
        setState(() {
          _loadingExpense = false;
          _expenseError = financeState.errorMessage;
        });
      }
    });

    _incomeSubscription = _incomeListBloc!.stream.listen((financeState) {
      if (!mounted) return;
      if (financeState.cropStatus == CropStatus.loading) {
        setState(() {
          _loadingIncome = true;
          _incomeError = null;
        });
      } else if (financeState.cropStatus == CropStatus.success) {
        final finance = financeState.plotFinanceEntity;
        setState(() {
          _loadingIncome = false;
          _incomeError = null;
          revenues
            ..clear()
            ..addAll(_mapTransactions(finance?.result ?? []));
        });
      } else if (financeState.cropStatus == CropStatus.failure) {
        setState(() {
          _loadingIncome = false;
          _incomeError = financeState.errorMessage;
        });
      }
    });

    _loadFinanceLists();
  }

  List<PlotTransaction> _mapTransactions(List<PlotFinanceItemEntity> records) {
    return records.map((item) {
      DateTime parsedDate;
      try {
        parsedDate = DateFormat('dd-MM-yyyy').parseStrict(item.date);
      } catch (_) {
        parsedDate = DateTime.tryParse(item.date) ?? DateTime(2000);
      }
      return PlotTransaction(
        id: item.plotFinanceId,
        date: parsedDate,
        amount: item.amount,
        remark: item.remark,
      );
    }).toList();
  }

  Future<void> _loadFinanceLists() async {
    try {
      final farmerId = (await SecureStorage.instance.getFarmerId()).trim();
      if (!mounted) return;
      _farmerId = farmerId;
      if (farmerId.isEmpty || widget.plotId.trim().isEmpty) {
        setState(() {
          _loadingExpense = false;
          _loadingIncome = false;
          _expenseError = _incomeError = farmerId.isEmpty
              ? l10n.pleaseLoginAgain
              : l10n.plotIdMissing;
        });
        return;
      }
      _refreshFinanceLists();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingExpense = false;
        _loadingIncome = false;
        _expenseError = _incomeError = e.toString();
      });
    }
  }

  void _refreshFinanceLists() {
    if (!mounted || _farmerId.isEmpty) return;
    _expenseListBloc?.add(
      GetPlotFinanceEvent(
        farmerId: _farmerId,
        plotId: widget.plotId,
        type: 'Expense',
      ),
    );
    _incomeListBloc?.add(
      GetPlotFinanceEvent(
        farmerId: _farmerId,
        plotId: widget.plotId,
        type: 'Income',
      ),
    );
  }

  @override
  void dispose() {
    _historyTabController.dispose();
    _expenseSubscription?.cancel();
    _incomeSubscription?.cancel();
    _expenseListBloc?.close();
    _incomeListBloc?.close();
    super.dispose();
  }

  double get totalExpense => expenses.fold(0, (sum, item) => sum + item.amount);

  double get totalRevenue => revenues.fold(0, (sum, item) => sum + item.amount);

  double get netProfit => totalRevenue - totalExpense;

  String money(num amount) {
    return '₹ ${currencyFormat.format(amount)}';
  }

  Future<void> _showDeleteDialog(PlotTransaction item) async {
    final cropBloc = CropBloc(
      cropScheduleUsecases: context.read<CropBloc>().cropScheduleUsecases,
    );
    bool submitting = false;
    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => StatefulBuilder(
          builder: (dialogContext, setDialogState) =>
              BlocListener<CropBloc, CropState>(
                bloc: cropBloc,
                listener: (_, state) {
                  if (!mounted || !dialogContext.mounted) return;
                  if (state.cropStatus == CropStatus.success) {
                    Navigator.of(dialogContext).pop();
                    setState(() {
                      expenses.removeWhere((entry) => entry.id == item.id);
                      revenues.removeWhere((entry) => entry.id == item.id);
                    });
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(content: Text(l10n.financeEntryDeleted)),
                      );
                    _refreshFinanceLists();
                  } else if (state.cropStatus == CropStatus.failure) {
                    setDialogState(() => submitting = false);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage ??
                                'Unable to delete plot finance',
                          ),
                          backgroundColor: red,
                        ),
                      );
                  }
                },
                child: PopScope(
                  canPop: !submitting,
                  child: AlertDialog(
                    backgroundColor: context.appSurface,
                    title: Text(l10n.financeDeleteTitle),
                    content: Text(
                      l10n.financeDeleteMessage(money(item.amount)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: submitting
                            ? null
                            : () => Navigator.of(dialogContext).pop(),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: submitting
                            ? null
                            : () {
                                setDialogState(() => submitting = true);
                                cropBloc.add(
                                  DeletePlotFinanceEvent(
                                    farmerId: _farmerId,
                                    financeId: item.id,
                                  ),
                                );
                              },
                        child: submitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.delete, style: TextStyle(color: red)),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      );
    } finally {
      await cropBloc.close();
    }
  }

  Future<void> _showAddDialog({required bool isRevenue}) async {
    final usecases = context.read<CropBloc>().cropScheduleUsecases;
    final farmerId = (await SecureStorage.instance.getFarmerId()).trim();
    if (!mounted) return;
    if (farmerId.isEmpty || widget.plotId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            farmerId.isEmpty ? l10n.pleaseLoginAgain : l10n.plotIdMissing,
          ),
        ),
      );
      return;
    }
    // Isolate saving from schedule and plot requests on the shared CropBloc.
    final cropBloc = CropBloc(cropScheduleUsecases: usecases);
    final formKey = GlobalKey<FormState>();
    // Let TextFormField own its controllers through the route's exit animation.
    String amountInput = '';
    String remarkInput = '';

    DateTime selectedDate = DateTime.now();
    bool submitting = false;

    final Color primary = isRevenue ? green : red;
    final String title = isRevenue
        ? l10n.financeAddPlotRevenue
        : l10n.financeAddPlotExpense;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            Future<void> pickDate() async {
              final picked = await showDatePicker(
                context: dialogContext,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: primary,
                        onPrimary: context.appOnPrimary,
                        onSurface: ink,
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (picked != null && dialogContext.mounted) {
                setDialogState(() {
                  selectedDate = picked;
                });
              }
            }

            return BlocListener<CropBloc, CropState>(
              bloc: cropBloc,
              listenWhen: (previous, current) =>
                  submitting &&
                  (current.cropStatus == CropStatus.success ||
                      current.cropStatus == CropStatus.failure),
              listener: (listenerContext, state) {
                if (!mounted || !dialogContext.mounted) return;
                final errorMessage = state.errorMessage?.trim() ?? '';
                if (state.cropStatus == CropStatus.success) {
                  final message = isRevenue
                      ? l10n.financeRevenueAdded
                      : l10n.financeExpenseAdded;
                  Navigator.of(dialogContext).pop();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: primary,
                      ),
                    );
                  // Fetch the saved entry from the server for both tabs.
                  _historyTabController.animateTo(isRevenue ? 1 : 0);
                  _refreshFinanceLists();
                } else if (state.cropStatus == CropStatus.failure) {
                  if (dialogContext.mounted) {
                    setDialogState(() => submitting = false);
                  }
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          errorMessage.isNotEmpty
                              ? errorMessage
                              : 'Unable to save plot finance',
                        ),
                        backgroundColor: red,
                      ),
                    );
                }
              },
              child: AlertDialog(
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                backgroundColor: context.appSurface,
                surfaceTintColor: context.appSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                contentPadding: const EdgeInsets.all(20),
                content: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: primary.withValues(alpha: 0.09),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  isRevenue
                                      ? Icons.trending_up_rounded
                                      : Icons.trending_down_rounded,
                                  color: primary,
                                  size: 25,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  title,
                                  style:
                                      _compactStyle(
                                        context.appTextStyles.headingMedium,
                                      ).copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: ink,
                                      ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                icon: Icon(Icons.close_rounded),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),

                          _fieldLabel(l10n.financeTransactionDate),
                          const SizedBox(height: 7),

                          InkWell(
                            onTap: pickDate,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: _inputDecoration(),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    color: primary,
                                    size: 21,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      dateFormat.format(selectedDate),
                                      style:
                                          _compactStyle(
                                            context.appTextStyles.body,
                                          ).copyWith(
                                            color: ink,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: muted,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          _fieldLabel(l10n.financeAmount),
                          const SizedBox(height: 7),

                          TextFormField(
                            onChanged: (value) => amountInput = value,
                            textInputAction: TextInputAction.next,
                            style: _compactStyle(context.appTextStyles.input),
                            autofocus: false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            decoration: InputDecoration(
                              hintText: l10n.financeEnterAmount,
                              hintStyle: _compactStyle(
                                context.appTextStyles.inputHint,
                              ),
                              prefixIcon: Icon(
                                Icons.currency_rupee_rounded,
                                color: primary,
                                size: 21,
                              ),
                              filled: true,
                              fillColor: context.appInputBackground,
                              border: _fieldBorder(),
                              enabledBorder: _fieldBorder(),
                              focusedBorder: _fieldBorder(color: primary),
                            ),
                            validator: (value) {
                              final amount = double.tryParse(
                                value?.trim() ?? '',
                              );

                              if (amount == null || amount <= 0) {
                                return l10n.financeInvalidAmount;
                              }
                              if (!amount.isFinite) {
                                return l10n.financeInvalidAmount;
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          _fieldLabel(l10n.financeRemark),
                          const SizedBox(height: 7),

                          TextFormField(
                            onChanged: (value) => remarkInput = value,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(dialogContext).unfocus(),
                            style: _compactStyle(context.appTextStyles.input),
                            maxLines: 3,
                            maxLength: 200,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: isRevenue
                                  ? l10n.financeRevenueHint
                                  : l10n.financeExpenseHint,
                              filled: true,
                              fillColor: context.appInputBackground,
                              border: _fieldBorder(),
                              enabledBorder: _fieldBorder(),
                              focusedBorder: _fieldBorder(color: primary),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.financeEnterRemark;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: submitting
                              ? null
                              : () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: muted,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(l10n.cancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: submitting
                              ? null
                              : () {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }

                                  if (cropBloc.state.cropStatus ==
                                      CropStatus.loading) {
                                    return;
                                  }

                                  setDialogState(() {
                                    submitting = true;
                                  });

                                  cropBloc.add(
                                    AddPlotFinanceEvent(
                                      date: DateFormat(
                                        'dd-MM-yyyy',
                                      ).format(selectedDate),
                                      amount: amountInput.trim(),
                                      remark: remarkInput.trim(),
                                      farmerId: farmerId,
                                      plotId: widget.plotId,
                                      type: isRevenue ? 'Income' : 'Expense',
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: context.appOnPrimary,
                            elevation: 0,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: submitting
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      context.appOnPrimary,
                                    ),
                                  ),
                                )
                              : Text(
                                  l10n.save,
                                  style: _compactStyle(
                                    context.appTextStyles.body,
                                  ).copyWith(fontWeight: FontWeight.w700),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    await cropBloc.close();
  }

  OutlineInputBorder _fieldBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color ?? context.appBorder),
    );
  }

  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      color: context.appCard,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: context.appBorder),
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: _compactStyle(
        context.appTextStyles.body,
      ).copyWith(fontWeight: FontWeight.w700, color: ink),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appBackground,

      appBar: CommonDashboardAppBar(
        title: l10n.financeTitle,
        greeting: l10n.financeSubtitle,

        showProfile: false,
        showNotification: false,
        showThemeButton: true,
        onBackTap: () => Navigator.pop(context),
      ),

      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                child: Column(
                  children: [
                    _buildPlotHeader(),
                    const SizedBox(height: 12),
                    _buildProfitSummary(),
                    const SizedBox(height: 12),
                    _buildActionButtons(),
                    const SizedBox(height: 16),
                    TabBar(
                      controller: _historyTabController,
                      labelColor: context.appPrimary,
                      unselectedLabelColor: muted,
                      indicatorColor: context.appPrimary,
                      dividerColor: context.appBorder,
                      labelStyle: _compactStyle(context.appTextStyles.label),
                      unselectedLabelStyle: _compactStyle(
                        context.appTextStyles.label,
                      ),
                      tabs: [
                        Tab(text: l10n.financeExpenseHistory),
                        Tab(text: l10n.financeRevenueHistory),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _historyTabController,
            children: [
              _buildHistoryTab(isRevenue: false),
              _buildHistoryTab(isRevenue: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTab({required bool isRevenue}) {
    final items = isRevenue ? revenues : expenses;
    final loading = isRevenue ? _loadingIncome : _loadingExpense;
    final error = isRevenue ? _incomeError : _expenseError;
    return ListView(
      key: PageStorageKey<String>(
        isRevenue ? 'revenueHistory' : 'expenseHistory',
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      children: [
        _buildSectionHeader(
          title: isRevenue
              ? l10n.financeRevenueHistory
              : l10n.financeExpenseHistory,
          icon: isRevenue
              ? Icons.trending_up_rounded
              : Icons.trending_down_rounded,
          color: isRevenue ? green : red,
          count: items.length,
          total: isRevenue ? totalRevenue : totalExpense,
        ),
        const SizedBox(height: 10),
        if (loading)
          const Padding(
            padding: EdgeInsets.all(28),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (error != null && error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: red),
                ),
                TextButton(
                  onPressed: _loadFinanceLists,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        if (!loading && (error == null || items.isNotEmpty))
          _buildTransactionList(items: items, isRevenue: isRevenue),
      ],
    );
  }

  Widget _buildPlotHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: context.appBorder),
      ),
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: context.appCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.grass_rounded, color: green, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.plotName,
                  style: _compactStyle(
                    context.appTextStyles.headingMedium,
                  ).copyWith(color: ink, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 3),
                Text(
                  '${widget.cropName} ${widget.acres} acres',
                  style: _compactStyle(
                    context.appTextStyles.body,
                  ).copyWith(color: muted, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            title: l10n.financeAddExpense,
            subtitle: l10n.financeRecordSpending,
            color: red,
            onTap: () => _showAddDialog(isRevenue: false),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _actionButton(
            title: l10n.financeAddRevenue,
            subtitle: l10n.financeRecordIncome,
            color: green,
            onTap: () => _showAddDialog(isRevenue: true),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.add_circle, color: context.appOnPrimary, size: 25),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      style: _compactStyle(context.appTextStyles.body).copyWith(
                        color: context.appOnPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      style: _compactStyle(
                        context.appTextStyles.caption,
                      ).copyWith(color: context.appOnPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
    required int count,
    required double total,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                title,
                style: _compactStyle(
                  context.appTextStyles.sectionTitle,
                ).copyWith(color: ink, fontWeight: FontWeight.w800),
              ),
            ),
            Text(
              money(total),
              style: _compactStyle(
                context.appTextStyles.sectionTitle,
              ).copyWith(color: color, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.financeEntryCount(count),
            style: _compactStyle(
              context.appTextStyles.caption,
            ).copyWith(color: muted),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList({
    required List<PlotTransaction> items,
    required bool isRevenue,
  }) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 15),
        decoration: BoxDecoration(
          color: context.appCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.appBorder),
        ),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              color: muted.withValues(alpha: 0.7),
              size: 34,
            ),
            const SizedBox(height: 9),
            Text(
              isRevenue ? l10n.financeNoRevenue : l10n.financeNoExpenses,
              style: _compactStyle(
                context.appTextStyles.body,
              ).copyWith(color: muted),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: context.appOnPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: context.appCard,
              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    l10n.date,
                    style: _compactStyle(
                      context.appTextStyles.caption,
                    ).copyWith(fontWeight: FontWeight.w700, color: ink),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    l10n.financeAmount,
                    style: _compactStyle(
                      context.appTextStyles.caption,
                    ).copyWith(fontWeight: FontWeight.w700, color: ink),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    l10n.financeRemark,
                    style: _compactStyle(
                      context.appTextStyles.caption,
                    ).copyWith(fontWeight: FontWeight.w700, color: ink),
                  ),
                ),
                SizedBox(width: 28),
              ],
            ),
          ),
          ...items.map((item) {
            return Column(
              key: ValueKey(item.id),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          dateFormat.format(item.date),
                          style: _compactStyle(
                            context.appTextStyles.caption,
                          ).copyWith(color: ink, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          currencyFormat.format(item.amount),
                          style: _compactStyle(context.appTextStyles.caption)
                              .copyWith(
                                color: isRevenue ? green : red,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          item.remark,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: _compactStyle(
                            context.appTextStyles.caption,
                          ).copyWith(color: ink),
                        ),
                      ),
                      SizedBox(
                        width: 28,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          tooltip: l10n.financeDeleteEntry,
                          onPressed: () => _showDeleteDialog(item),
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            size: 20,
                            color: red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (item != items.last)
                  Divider(height: 1, color: context.appBorder),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProfitSummary() {
    final isProfit = netProfit >= 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.appBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assessment_rounded, color: green, size: 22),
              SizedBox(width: 8),
              Text(
                l10n.financeProfitSummary,
                style: _compactStyle(
                  context.appTextStyles.sectionTitle,
                ).copyWith(color: green, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _bottomSummaryItem(
                  label: l10n.financeRevenue,
                  value: totalRevenue,
                  color: green,
                ),
              ),
              Container(height: 36, width: 1, color: context.appBorder),
              Expanded(
                child: _bottomSummaryItem(
                  label: l10n.financeExpenses,
                  value: totalExpense,
                  color: red,
                ),
              ),
              Container(height: 36, width: 1, color: context.appBorder),
              Expanded(
                child: _bottomSummaryItem(
                  label: isProfit ? l10n.financeNetProfit : l10n.financeNetLoss,
                  value: netProfit.abs(),
                  color: isProfit ? blue : red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomSummaryItem({
    required String label,
    required double value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: _compactStyle(
            context.appTextStyles.caption,
          ).copyWith(color: ink, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            money(value),
            style: _compactStyle(
              context.appTextStyles.headingMedium,
            ).copyWith(fontWeight: FontWeight.w900, color: color),
          ),
        ),
      ],
    );
  }
}

class PlotTransaction {
  final String id;
  final DateTime date;
  final double amount;
  final String remark;

  const PlotTransaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.remark,
  });
}
