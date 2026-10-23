
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_event.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Add your existing project imports:
// import '.../crop_bloc.dart';
// import '.../crop_event.dart';
// import '.../crop_state.dart';
// import '.../schedule_entity.dart';
// import '.../schedule_detail_entity.dart';
// import '.../common_dashboard_app_bar.dart';

class CropSchedulePage extends StatefulWidget {
  final String farmerId;

  const CropSchedulePage({
    super.key,
    required this.farmerId,
  });

  @override
  State<CropSchedulePage> createState() =>
      _CropSchedulePageState();
}

class _CropSchedulePageState extends State<CropSchedulePage> {
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  late DateTime _fromDate;
  late DateTime _toDate;
  late DateTime _activeFromDate;
  late DateTime _activeToDate;

  bool _showFilters = false;
  bool _filterApplied = false;

  // Keep confirmed updates selected until the refreshed list arrives.
  final Map<String, bool> _scheduleAnswers = {};
  bool _answerBusy = false;
  String? _updatingScheduleId;

  Future<void> _confirmApplied(String scheduleId) async {
    if (_answerBusy) return;
    setState(() => _answerBusy = true);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm products applied'),
        content: const Text('Have you applied all products in this schedule?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed != true) {
      setState(() => _answerBusy = false);
      return;
    }

    setState(() => _updatingScheduleId = scheduleId);
    final updateBloc = CropBloc(
      cropScheduleUsecases: context.read<CropBloc>().cropScheduleUsecases,
    );
    try {
      final completion = updateBloc.stream.firstWhere(
        (state) =>
            state.cropStatus == CropStatus.success ||
            state.cropStatus == CropStatus.failure,
      );
      updateBloc.add(
        UpdateScheduleStatus(farmerId: widget.farmerId, scheduleId: scheduleId),
      );
      final result = await completion;
      if (!mounted) return;
      if (result.cropStatus == CropStatus.success) {
        setState(() => _scheduleAnswers[scheduleId] = true);
        _loadSchedules();
      }
      _showMessage(
        result.errorMessage ??
            (result.cropStatus == CropStatus.success
                ? 'Schedule updated successfully'
                : 'Unable to update schedule'),
      );
    } finally {
      await updateBloc.close();
      if (mounted) {
        setState(() {
          _answerBusy = false;
          _updatingScheduleId = null;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _fromDate = today;
    _toDate = today;
    _activeFromDate = today;
    _activeToDate = today;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadSchedules();
    });
  }

  void _loadSchedules() {
    context.read<CropBloc>().add(
      GetCropScheduleEvent(
        widget.farmerId,
        fromDate: _dateFormat.format(_activeFromDate),
        toDate: _dateFormat.format(_activeToDate),
      ),
    );
  }

  Future<void> _refreshSchedules() async {
    final bloc = context.read<CropBloc>();

    final completion = bloc.stream.firstWhere(
      (state) =>
          state.cropStatus == CropStatus.success ||
          state.cropStatus == CropStatus.failure,
    );

    _loadSchedules();
    await completion;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _toggleFilters() {
    setState(() {
      if (!_showFilters) {
        _fromDate = _activeFromDate;
        _toDate = _activeToDate;
      }
      _showFilters = !_showFilters;
    });
  }

  Future<void> _pickDate(bool isFromDate) async {
    final current = isFromDate ? _fromDate : _toDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 5),
      helpText: isFromDate
          ? 'SELECT FROM DATE'
          : 'SELECT TO DATE',
    );

    if (picked == null || !mounted) return;

    setState(() {
      if (isFromDate) {
        _fromDate = picked;

        if (_toDate.isBefore(_fromDate)) {
          _toDate = picked;
        }
      } else {
        _toDate = picked;
      }
    });
  }

  void _applyFilters() {
    if (_fromDate.isAfter(_toDate)) {
      _showMessage('From Date cannot be after To Date');
      return;
    }

    setState(() {
      _activeFromDate = _fromDate;
      _activeToDate = _toDate;
      _filterApplied = true;
      _showFilters = false;
    });

    _loadSchedules();
  }

  void _clearFilters() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    setState(() {
      _fromDate = today;
      _toDate = today;
      _activeFromDate = today;
      _activeToDate = today;
      _filterApplied = false;
      _showFilters = false;
    });

    _loadSchedules();
  }

  List<ScheduleEntity> _filterByDate(
    List<ScheduleEntity> schedules,
  ) {
    return schedules.where((schedule) {
      try {
        final date = _dateFormat.parseStrict(
          schedule.scheduleDate.trim(),
        );

        final day = DateTime(date.year, date.month, date.day);

        return !day.isBefore(_activeFromDate) &&
            !day.isAfter(_activeToDate);
      } catch (_) {
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CommonDashboardAppBar(
        title: 'Crop Schedule',
        showProfile: false,
        showNotification: false,
     //   showFilterButton: true,
      //  isFilterActive: _filterApplied,
        showThemeButton: true,
        onBackTap: () => Navigator.pop(context),
      //  onFilterTap: _toggleFilters,
      ),
      body: BlocBuilder<CropBloc, CropState>(
        buildWhen: (previous, current) =>
            previous.cropStatus != current.cropStatus ||
            previous.errorMessage != current.errorMessage ||
            previous.sceduleentityList !=
                current.sceduleentityList,
        builder: (context, state) {
          final schedules = state.cropStatus == CropStatus.success
              ? _filterByDate(state.sceduleentityList)
              : <ScheduleEntity>[];

          return RefreshIndicator(
            onRefresh: _refreshSchedules,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
              children: [
                // Always visible filter summary.
                // _buildFilterSummary(),

                // if (_showFilters) ...[
                //   const SizedBox(height: 10),
                //   _buildFilterCard(),
                // ],

                const SizedBox(height: 14),

                if (state.cropStatus == CropStatus.initial ||
                    state.cropStatus == CropStatus.loading)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colors.primary,
                      ),
                    ),
                  ),

                if (state.cropStatus == CropStatus.failure)
                  _buildStatusWidget(
                    icon: Icons.error_outline_rounded,
                    title: 'Unable to load schedules',
                    subtitle:
                        state.errorMessage ?? 'Something went wrong',
                    buttonText: 'Retry',
                    onPressed: _loadSchedules,
                  ),

                if (state.cropStatus == CropStatus.success &&
                    schedules.isEmpty)
                  _buildStatusWidget(
                    icon: Icons.event_busy_outlined,
                    title: 'No schedules found',
                    subtitle: _filterApplied
                        ? 'No schedules found for the selected date range.'
                        : 'No crop schedules available for today.',
                    buttonText: _filterApplied
                        ? 'Show Today'
                        : 'Refresh',
                    onPressed:
                        _filterApplied ? _clearFilters : _loadSchedules,
                  ),

                if (state.cropStatus == CropStatus.success &&
                    schedules.isNotEmpty) ...[
                  _buildListHeader(schedules),
                  const SizedBox(height: 10),

                  ...schedules.map(
                    (schedule) => Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: _buildScheduleCard(schedule),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // =====================================================
  // COMPACT FILTER SUMMARY
  // =====================================================

  Widget _buildFilterSummary() {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: _toggleFilters,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: colors.primary,
                size: 18,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _filterApplied
                        ? 'Filtered Crop Schedules'
                        : "Today's Crop Schedules",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_dateFormat.format(_activeFromDate)}'
                    '  →  '
                    '${_dateFormat.format(_activeToDate)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              _showFilters
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: colors.primary,
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // FILTER CARD
  // =====================================================

  Widget _buildFilterCard() {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _dateField(
                  'From Date',
                  _fromDate,
                  () => _pickDate(true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _dateField(
                  'To Date',
                  _toDate,
                  () => _pickDate(false),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 43),
                  ),
                  child: const Text('Clear'),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                flex: 5,
                child: FilledButton.icon(
                  onPressed: _applyFilters,
                  icon: const Icon(
                    Icons.search_rounded,
                    size: 18,
                  ),
                  label: const Text('Search'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 43),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateField(
    String label,
    DateTime date,
    VoidCallback onTap,
  ) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 15,
              color: colors.primary,
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _dateFormat.format(date),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // LIST HEADER
  // =====================================================

  Widget _buildListHeader(
    List<ScheduleEntity> schedules,
  ) {
    final colors = Theme.of(context).colorScheme;

    final totalProducts = schedules.fold<int>(
      0,
      (total, schedule) => total + schedule.details.length,
    );

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            Icons.event_note_outlined,
            size: 19,
            color: colors.primary,
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedules',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
              Text(
                '$totalProducts total products',
                style: TextStyle(
                  fontSize: 10,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${schedules.length} Found',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: colors.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // SCHEDULE CARD - SAME STRUCTURE AS REFERENCE
  // =====================================================

  Widget _buildScheduleCard(ScheduleEntity schedule) {
    final colors = Theme.of(context).colorScheme;
    final applied = _scheduleAnswers[schedule.scheduleId] ??
        (schedule.status.trim() == '1');

    return Container(
      decoration: BoxDecoration(
        color: applied
            ? Color.alphaBlend(colors.primary.withValues(alpha: 0.08), colors.surface)
            : colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: applied ? colors.primary : colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ExpansionTile(
          key: ValueKey(schedule.scheduleId),
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 12,
            // vertical: 2,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            12, 0, 12, 12,
          ),
          shape: const Border(),
          collapsedShape: const Border(),
          iconColor: colors.primary,
          collapsedIconColor: colors.onSurfaceVariant,

          // Farmer name like reference page.
          title: Text(
            'Plot Name: '
            '${schedule.plotName.trim().isEmpty ? '-' : schedule.plotName}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     Icon(
                //       Icons.landscape_outlined,
                //       size: 14,
                //       color: colors.onSurfaceVariant,
                //     ),
                //     const SizedBox(width: 4),
                //     Expanded(
                //       child: Text(
                //         'Plot Name: '
                //         '${schedule.plotName.trim().isEmpty ? '#${schedule.plotRegistrationId}' : schedule.plotName}',
                //         maxLines: 2,
                //         overflow: TextOverflow.ellipsis,
                //         style: TextStyle(
                //           fontSize: 11,
                //           color: colors.onSurfaceVariant,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                // const SizedBox(height: 7),

                Wrap(
                  spacing: 6,
                  runSpacing: 5,
                  children: [
                    _miniChip(
                      Icons.calendar_today_outlined,
                      schedule.scheduleDate,
                    ),
                    _miniChip(
                      Icons.inventory_2_outlined,
                      '${schedule.details.length} Products',
                    ),
                  ],
                ),
              ],
            ),
          ),

          children: [
            const Divider(height: 16),

            // Consultant / doctor name.
            _detailRow('Consultant', schedule.adminName),

            // Crop Name deliberately not displayed here.

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  color: colors.primary,
                  size: 17,
                ),
                const SizedBox(width: 6),
                Text(
                  'PRODUCT DETAILS',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            if (schedule.details.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('No product details.'),
              )
            else
              _buildProductGroup(schedule),
          ],
        ),
      ),
    );
  }

  Widget _miniChip(IconData icon, String text) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        // color: colors.primaryContainer,
        border: Border.all(color: colors.primaryContainer,),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: colors.onPrimaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 9.5,
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ONE GROUP FOR ALL PRODUCTS
  // =====================================================

  Widget _buildProductGroup(ScheduleEntity schedule) {
    final colors = Theme.of(context).colorScheme;

    final products = schedule.details;

    final selected = _scheduleAnswers[schedule.scheduleId] ??
        (schedule.status.trim() == '1');

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 3,
            ),
            child: Column(
              children: [
                for (int i = 0; i < products.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colors.outlineVariant,
                    ),
                  _buildProductRow(i + 1, products[i]),
                  if (products[i].remark.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: colors.onSurface,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Remark: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: products[i].remark.trim()),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),

          // One common Yes / No for whole schedule.
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: colors.primaryContainer.withValues(alpha: 0.6),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Products applied?',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                ),

                _answerOption(
                  text: 'Yes',
                  value: true,
                  selected: selected,
                  scheduleId: schedule.scheduleId,
                ),

                const SizedBox(width: 8),

                _answerOption(
                  text: 'No',
                  value: false,
                  selected: selected,
                  scheduleId: schedule.scheduleId,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerOption({
    required String text,
    required bool value,
    required bool selected,
    required String scheduleId,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = selected == value;

    return InkWell(
      onTap: _answerBusy || isSelected
          ? null
          : () {
              if (value) _confirmApplied(scheduleId);
            },
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 3,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value && _updatingScheduleId == scheduleId) ...[
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected
                  ? colors.primary
                  : colors.onSurfaceVariant,
              size: 19,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? colors.primary
                    : colors.onSurface,
                fontSize: 11,
                fontWeight: isSelected
                    ? FontWeight.w800
                    : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // PRODUCT ROW
  // No crop name displayed inside product details.
  // =====================================================

  Widget _buildProductRow(
    int index,
    ScheduleDetailEntity product,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Text(
                  product.productName.isEmpty
                      ? 'Unnamed Product'
                      : product.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
              ),

              if (product.productType.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    product.productType,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 6),

          Padding(
            padding: const EdgeInsets.only(left: 29),
            child: Row(
              children: [
                Expanded(
                  child: _inlineValue(
                    'Qty',
                    _quantityText(
                      product.productQty,
                      product.unit,
                    ),
                    Icons.scale_outlined,
                    const Color(0xFFB7791F),
                  ),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: _inlineValue(
                    'Water',
                    _quantityText(
                      product.waterQty,
                      product.waterUnit,
                    ),
                    Icons.water_drop_outlined,
                    const Color(0xFF0284C7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inlineValue(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 9,
            color: colors.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  String _quantityText(String amount, String unit) {
    if (amount.trim().isEmpty) return '-';

    return unit.trim().isEmpty
        ? amount.trim()
        : '${amount.trim()} ${unit.trim()}';
  }

  Widget _detailRow(String label, String value) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 85,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ERROR / EMPTY STATE
  // =====================================================

  Widget _buildStatusWidget({
    required IconData icon,
    required String title,
    required String subtitle,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 55,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 35,
              color: colors.primary,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: colors.onSurfaceVariant,
            ),
          ),

          if (buttonText != null && onPressed != null) ...[
            const SizedBox(height: 15),
            FilledButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ],
        ],
      ),
    );
  }
}
