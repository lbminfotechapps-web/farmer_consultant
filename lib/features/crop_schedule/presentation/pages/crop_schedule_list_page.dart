import 'package:farmer_consultant/core/theme/app_dynamic_colors.dart';
import 'package:farmer_consultant/l10n/app_localizations.dart';
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

// Keep your project-specific imports:
// CropBloc, CropState, CropStatus, Crop events
// ScheduleEntity, ScheduleDetailEntity
// CommonDashboardAppBar

class CropSchedulePage extends StatefulWidget {
  final String farmerId;

  const CropSchedulePage({super.key, required this.farmerId});

  @override
  State<CropSchedulePage> createState() => _CropSchedulePageState();
}

class _CropSchedulePageState extends State<CropSchedulePage> {
  final DateFormat _apiDateFormat = DateFormat('dd-MM-yyyy');
  DateFormat get _dayFormat =>
      DateFormat('EEE', Localizations.localeOf(context).languageCode);
  DateFormat get _monthFormat =>
      DateFormat('MMMM yyyy', Localizations.localeOf(context).languageCode);
  DateFormat get _headingFormat =>
      DateFormat('dd MMMM yyyy', Localizations.localeOf(context).languageCode);

  static const int _previousDays = 30;
  static const int _nextDays = 30;
  static const double _dateItemExtent = 65;

  late final DateTime _today;
  late DateTime _selectedDate;
  late final List<DateTime> _calendarDates;

  final ScrollController _dateScrollController = ScrollController();

  // Separate BLoC for available dates.
  late final CropBloc _datesBloc;

  Set<String> _availableDates = {};
  bool _datesLoading = true;
  String? _datesError;

  final Map<String, bool> _scheduleAnswers = {};

  bool _answerBusy = false;
  String? _updatingScheduleId;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _today = DateTime(now.year, now.month, now.day);
    _selectedDate = _today;

    _calendarDates = List.generate(
      _previousDays + _nextDays + 1,
      (index) => _today.add(Duration(days: index - _previousDays)),
    );

    final parentBloc = context.read<CropBloc>();

    _datesBloc = CropBloc(
      cropScheduleUsecases: parentBloc.cropScheduleUsecases,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _scrollToDate(_previousDays, animate: false);

      _loadAvailableDates();
      _loadSchedules();
    });
  }

  @override
  void dispose() {
    _dateScrollController.dispose();
    _datesBloc.close();
    super.dispose();
  }

  // ===================================================
  // DATE HELPERS
  // ===================================================

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String _formatApiDate(DateTime date) {
    return _apiDateFormat.format(date);
  }

  bool _hasSchedule(DateTime date) {
    return _availableDates.contains(_formatApiDate(date));
  }

  bool _isToday(DateTime date) {
    return _isSameDay(date, _today);
  }

  // ===================================================
  // SCROLL CALENDAR
  // ===================================================

  void _scrollToDate(int index, {bool animate = true}) {
    if (!_dateScrollController.hasClients) return;

    final screenWidth = MediaQuery.sizeOf(context).width;

    final availableWidth = screenWidth - 24;

    final offset =
        (index * _dateItemExtent) +
        (_dateItemExtent / 2) -
        (availableWidth / 2);

    final maxScroll = _dateScrollController.position.maxScrollExtent;

    final targetOffset = offset.clamp(0.0, maxScroll);

    if (animate) {
      _dateScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _dateScrollController.jumpTo(targetOffset);
    }
  }

  // ===================================================
  // AVAILABLE DATES API
  // ===================================================

  void _loadAvailableDates() {
    if (!mounted) return;

    setState(() {
      _datesLoading = true;
      _datesError = null;
    });

    _datesBloc.add(GetAvailableDatesEvent(widget.farmerId));
  }

  void _onAvailableDatesState(CropState state) {
    if (!mounted) return;

    if (state.cropStatus == CropStatus.success) {
      setState(() {
        _availableDates = state.availableDateList.toSet();

        _datesLoading = false;
        _datesError = null;
      });

      debugPrint('AVAILABLE DATES: $_availableDates');
    } else if (state.cropStatus == CropStatus.failure) {
      setState(() {
        _datesLoading = false;
        _datesError = state.errorMessage ?? 'Unable to load available dates';
      });

      debugPrint('AVAILABLE DATES ERROR: $_datesError');
    }
  }

  void _loadSchedules() {
    final selectedDate = _formatApiDate(_selectedDate);

    debugPrint('===================================');
    debugPrint('SELECTED DATE: $selectedDate');
    debugPrint('FARMER ID: ${widget.farmerId}');
    debugPrint('FROM DATE: $selectedDate');
    debugPrint('TO DATE: $selectedDate');
    debugPrint('===================================');

    context.read<CropBloc>().add(
      GetCropScheduleEvent(
        widget.farmerId,
        fromDate: selectedDate,
        toDate: selectedDate,
      ),
    );
  }

  // ===================================================
  // SELECT DATE
  // ===================================================

  void _onDateSelected(DateTime date, int index) {
    if (_isSameDay(_selectedDate, date)) {
      _scrollToDate(index);
      return;
    }

    setState(() {
      _selectedDate = date;
    });

    _scrollToDate(index);

    // Request schedules for selected date only.
    _loadSchedules();
  }

  // ===================================================
  // GO TO TODAY
  // ===================================================

  void _goToToday() {
    final alreadyToday = _isSameDay(_selectedDate, _today);

    setState(() {
      _selectedDate = _today;
    });

    _scrollToDate(_previousDays);

    if (!alreadyToday) {
      _loadSchedules();
    }
  }

  // ===================================================
  // REFRESH
  // ===================================================

  Future<void> _refreshSchedules() async {
    final bloc = context.read<CropBloc>();

    final completion = bloc.stream.firstWhere(
      (state) =>
          state.cropStatus == CropStatus.success ||
          state.cropStatus == CropStatus.failure,
    );

    _loadAvailableDates();
    _loadSchedules();

    await completion;
  }

  // ===================================================
  // CONFIRM PRODUCTS APPLIED
  // ===================================================

  Future<void> _confirmApplied(String scheduleId) async {
    if (_answerBusy) return;

    setState(() {
      _answerBusy = true;
    });

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmProductsApplied),
        content: Text(
          AppLocalizations.of(context)!.productsAppliedConfirmation,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(AppLocalizations.of(context)!.yes),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirmed != true) {
      setState(() {
        _answerBusy = false;
      });
      return;
    }

    setState(() {
      _updatingScheduleId = scheduleId;
    });

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
        setState(() {
          _scheduleAnswers[scheduleId] = true;
        });

        _loadSchedules();
        _loadAvailableDates();
      }

      _showMessage(
        (result.cropStatus == CropStatus.success
            ? AppLocalizations.of(context)!.scheduleUpdatedSuccessfully
            : AppLocalizations.of(context)!.unableToUpdateSchedule),
      );
    } catch (e) {
      if (mounted) {
        _showMessage(AppLocalizations.of(context)!.unableToUpdateSchedule);
      }
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

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  // ===================================================
  // MAIN SCREEN
  // ===================================================

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
   backgroundColor: context.appBackground,

      appBar: CommonDashboardAppBar(
        title: AppLocalizations.of(context)!.cropSchedule,
        showProfile: false,
        showNotification: false,
        showThemeButton: true,
        onBackTap: () => Navigator.pop(context),
      ),

      body: BlocListener<CropBloc, CropState>(
        bloc: _datesBloc,
        listener: (context, state) {
          _onAvailableDatesState(state);
        },
        child: Column(
          children: [
            // Fixed horizontal calendar header.
            _buildCalendarSection(),

            Divider(height: 1, color: colors.outlineVariant),

            // Only schedule list scrolls vertically.
            Expanded(child: _buildScheduleBody()),
          ],
        ),
      ),
    );
  }

  // ===================================================
  // CALENDAR SECTION
  // ===================================================

  Widget _buildCalendarSection() {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(color: colors.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month and Today button
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: 20,
                  color: colors.primary,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _monthFormat.format(_selectedDate),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context)!.selectScheduleDateHint,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              OutlinedButton.icon(
                onPressed: _goToToday,
                icon: const Icon(Icons.today_rounded, size: 15),
                label: Text(AppLocalizations.of(context)!.today),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Horizontal date strip
          SizedBox(
            height: 88,
            child: ListView.builder(
              controller: _dateScrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _calendarDates.length,
              itemExtent: _dateItemExtent,
              itemBuilder: (context, index) {
                final date = _calendarDates[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: _buildDateItem(date, index),
                );
              },
            ),
          ),

          const SizedBox(height: 11),

          // Calendar legend
          Row(
            children: [
              if (_datesLoading) ...[
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  AppLocalizations.of(context)!.checkingAvailableSchedules,
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ] else if (_datesError != null) ...[
                Icon(
                  Icons.error_outline_rounded,
                  size: 14,
                  color: colors.error,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.scheduleDatesUnavailable,
                    style: TextStyle(fontSize: 10, color: colors.error),
                  ),
                ),
                InkWell(
                  onTap: _loadAvailableDates,
                  child: Text(
                    AppLocalizations.of(context)!.retry,
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF22C55E),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context)!.scheduleAvailableLegend,
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],

              const Spacer(),

              if (_datesError == null && !_datesLoading)
                Text(
                  AppLocalizations.of(
                    context,
                  )!.scheduleDateCount(_availableDates.length),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================================================
  // SINGLE DATE ITEM
  // ===================================================

  Widget _buildDateItem(DateTime date, int index) {
    final colors = Theme.of(context).colorScheme;

    final selected = _isSameDay(date, _selectedDate);

    final today = _isToday(date);
    final hasSchedule = _hasSchedule(date);

    return InkWell(
      onTap: () => _onDateSelected(date, index),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surfaceContainerLow,

          borderRadius: BorderRadius.circular(14),

          border: Border.all(
            color: selected
                ? colors.primary
                : today
                ? colors.primary.withValues(alpha: 0.6)
                : colors.outlineVariant,
            width: today ? 1.3 : 0.8,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _dayFormat.format(date),
              style: TextStyle(
                fontSize: 10,
                color: selected ? colors.onPrimary : colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: selected ? colors.onPrimary : colors.onSurface,
              ),
            ),

            const SizedBox(height: 7),

            // Green dot only for API dates.
            SizedBox(
              width: 8,
              height: 8,
              child: hasSchedule
                  ? Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ===================================================
  // SCHEDULE BODY
  // ===================================================

  Widget _buildScheduleBody() {
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<CropBloc, CropState>(
      buildWhen: (previous, current) =>
          previous.cropStatus != current.cropStatus ||
          previous.errorMessage != current.errorMessage ||
          previous.sceduleentityList != current.sceduleentityList,

      builder: (context, state) {
        final schedules = state.cropStatus == CropStatus.success
            ? state.sceduleentityList.where((schedule) {
                try {
                  final date = _apiDateFormat.parseStrict(
                    schedule.scheduleDate.trim(),
                  );

                  return _isSameDay(date, _selectedDate);
                } catch (_) {
                  return false;
                }
              }).toList()
            : <ScheduleEntity>[];

        return RefreshIndicator(
          color: colors.primary,
          onRefresh: _refreshSchedules,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 24),
            children: [
              _buildSelectedDateHeader(),

              const SizedBox(height: 14),

              if (state.cropStatus == CropStatus.initial ||
                  state.cropStatus == CropStatus.loading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  ),
                ),

              if (state.cropStatus == CropStatus.failure)
                _buildStatusWidget(
                  icon: Icons.error_outline_rounded,
                  title: AppLocalizations.of(context)!.unableToLoadSchedules,
                  subtitle: AppLocalizations.of(context)!.cropScheduleLoadError,
                  buttonText: AppLocalizations.of(context)!.retry,
                  onPressed: _loadSchedules,
                ),

              if (state.cropStatus == CropStatus.success && schedules.isEmpty)
                _buildStatusWidget(
                  icon: Icons.event_busy_outlined,
                  title: AppLocalizations.of(context)!.noSchedulesFound,
                  subtitle: AppLocalizations.of(
                    context,
                  )!.noSchedulesForDate(_headingFormat.format(_selectedDate)),
                  buttonText: AppLocalizations.of(context)!.refresh,
                  onPressed: _loadSchedules,
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
    );
  }

  // ===================================================
  // SELECTED DATE HEADER
  // ===================================================

  Widget _buildSelectedDateHeader() {
    final colors = Theme.of(context).colorScheme;
    final today = _isToday(_selectedDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          Icon(Icons.event_note_rounded, size: 22, color: colors.primary),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  today
                      ? AppLocalizations.of(context)!.todaysSchedule
                      : AppLocalizations.of(context)!.selectedDateSchedule,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _headingFormat.format(_selectedDate),
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          if (_hasSchedule(_selectedDate))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                AppLocalizations.of(context)!.available,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF166534),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ===================================================
  // LIST HEADER
  // ===================================================

  Widget _buildListHeader(List<ScheduleEntity> schedules) {
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
                AppLocalizations.of(context)!.schedules,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.totalProductCount(totalProducts),
                style: TextStyle(fontSize: 10, color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            AppLocalizations.of(context)!.scheduleFoundCount(schedules.length),
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

  // ===================================================
  // SCHEDULE CARD
  // ===================================================

  Widget _buildScheduleCard(ScheduleEntity schedule) {
    final colors = Theme.of(context).colorScheme;

    final applied =
        _scheduleAnswers[schedule.scheduleId] ??
        (schedule.status.trim() == '1');

    return Container(
      decoration: BoxDecoration(
        color: applied
            ? Color.alphaBlend(
                colors.primary.withValues(alpha: 0.08),
                colors.surface,
              )
            : colors.surface,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: applied ? colors.primary : colors.outlineVariant,
        ),

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

          tilePadding: const EdgeInsets.symmetric(horizontal: 12),

          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),

          shape: const Border(),
          collapsedShape: const Border(),
          iconColor: colors.primary,
          collapsedIconColor: colors.onSurfaceVariant,

          title: Text(
            AppLocalizations.of(context)!.plotNameValue(
              schedule.plotName.trim().isEmpty ? '-' : schedule.plotName,
            ),
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
            child: Wrap(
              spacing: 6,
              runSpacing: 5,
              children: [
                _miniChip(Icons.calendar_today_outlined, schedule.scheduleDate),
                _miniChip(
                  Icons.inventory_2_outlined,
                  AppLocalizations.of(
                    context,
                  )!.productCount(schedule.details.length),
                ),
              ],
            ),
          ),

          children: [
            const Divider(height: 16),

            _detailRow(
              AppLocalizations.of(context)!.consultant,
              schedule.adminName,
            ),

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
                  AppLocalizations.of(context)!.productDetails,
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(AppLocalizations.of(context)!.noProductDetails),
              )
            else
              _buildProductGroup(schedule),
          ],
        ),
      ),
    );
  }

  // ===================================================
  // MINI CHIP
  // ===================================================

  Widget _miniChip(IconData icon, String text) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: colors.primaryContainer),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: colors.onPrimaryContainer),
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

  // ===================================================
  // PRODUCT GROUP
  // ===================================================

  Widget _buildProductGroup(ScheduleEntity schedule) {
    final colors = Theme.of(context).colorScheme;
    final products = schedule.details;

    final selected =
        _scheduleAnswers[schedule.scheduleId] ??
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
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 3),
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
                              TextSpan(
                                text: AppLocalizations.of(context)!.remarkLabel,
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

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
                    AppLocalizations.of(context)!.productsApplied,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                ),

                _answerOption(
                  text: AppLocalizations.of(context)!.yes,
                  value: true,
                  selected: selected,
                  scheduleId: schedule.scheduleId,
                ),

                const SizedBox(width: 8),

                _answerOption(
                  text: AppLocalizations.of(context)!.no,
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

  // ===================================================
  // ANSWER OPTION
  // ===================================================

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
              if (value) {
                _confirmApplied(scheduleId);
              }
            },

      borderRadius: BorderRadius.circular(18),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),

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
              color: isSelected ? colors.primary : colors.onSurfaceVariant,
              size: 19,
            ),

            const SizedBox(width: 4),

            Text(
              text,
              style: TextStyle(
                color: isSelected ? colors.primary : colors.onSurface,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================================================
  // PRODUCT ROW
  // ===================================================

  Widget _buildProductRow(int index, ScheduleDetailEntity product) {
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
                      ? AppLocalizations.of(context)!.unnamedProduct
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
                    AppLocalizations.of(context)!.quantity,
                    _quantityText(product.productQty, product.unit),
                    Icons.scale_outlined,
                    const Color(0xFFB7791F),
                  ),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: _inlineValue(
                    AppLocalizations.of(context)!.water,
                    _quantityText(product.waterQty, product.waterUnit),
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

  // ===================================================
  // INLINE VALUE
  // ===================================================

  Widget _inlineValue(String label, String value, IconData icon, Color color) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 13, color: color),

        const SizedBox(width: 3),

        Text(
          '$label: ',
          style: TextStyle(fontSize: 9, color: colors.onSurfaceVariant),
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

  // ===================================================
  // DETAIL ROW
  // ===================================================

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
              style: TextStyle(fontSize: 10, color: colors.onSurfaceVariant),
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

  // ===================================================
  // EMPTY / ERROR WIDGET
  // ===================================================

  Widget _buildStatusWidget({
    required IconData icon,
    required String title,
    required String subtitle,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),

      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 35, color: colors.primary),
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
            style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
          ),

          if (buttonText != null && onPressed != null) ...[
            const SizedBox(height: 15),

            FilledButton(onPressed: onPressed, child: Text(buttonText)),
          ],
        ],
      ),
    );
  }
}
