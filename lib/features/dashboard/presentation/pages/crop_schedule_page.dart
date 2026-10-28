import 'package:farmer_consultant/l10n/app_localizations.dart';
import 'package:farmer_consultant/core/di/global_di.dart';
import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/theme/typography/app_typography_extension.dart';
import 'package:farmer_consultant/core/utility/custom_loader.dart';
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:farmer_consultant/features/dashboard/presentation/home_bloc/crop_schedule_bloc.dart';
import 'package:farmer_consultant/features/dashboard/presentation/home_bloc/crop_schedule_event.dart';
import 'package:farmer_consultant/features/dashboard/presentation/home_bloc/crop_schedule_state.dart';
import 'package:farmer_consultant/features/dashboard/presentation/widgets/crop_schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CropScheduleAdvicePage extends StatelessWidget {
  const CropScheduleAdvicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CropScheduleBloc>(
      create: (_) {
        final bloc = sl<CropScheduleBloc>();

        bloc.add(const GetCropSchedulesEvent());

        return bloc;
      },
      child: const CropScheduleView(),
    );
  }
}

class CropScheduleView extends StatelessWidget {
  const CropScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: CommonDashboardAppBar(
        title: AppLocalizations.of(context)!.cropAdvice,
        showProfile: false,
        showNotification: false,
        showThemeButton: true,
        showFilterButton: true,

        onBackTap: () => Navigator.of(context).pop(),
      ),

      body: BlocBuilder<CropScheduleBloc, CropScheduleState>(
        builder: (context, state) {
          // =====================================================
          // LOADING
          // =====================================================

          if (state.status == CropScheduleStatus.loading &&
              state.schedules.isEmpty) {
            return const _LoadingView();
          }

          // =====================================================
          // ERROR
          // =====================================================

          if (state.status == CropScheduleStatus.failure &&
              state.schedules.isEmpty) {
            return _ErrorView(
              message: AppLocalizations.of(context)!.cropScheduleLoadError,
            );
          }

          // =====================================================
          // EMPTY
          // =====================================================

          if (state.status == CropScheduleStatus.success &&
              state.schedules.isEmpty) {
            return const _EmptyView();
          }

          // =====================================================
          // DATA
          // =====================================================

          return RefreshIndicator(
            color: context.primaryColor,
            onRefresh: () async {
              context.read<CropScheduleBloc>().add(
                const RefreshCropSchedulesEvent(),
              );
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
              children: [
                _SummaryHeader(count: state.schedules.length),

                const SizedBox(height: 20),

                ...state.schedules.map((schedule) {
                  return CropScheduleCard(schedule: schedule);
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

// =============================================================
// SUMMARY HEADER
// =============================================================

class _SummaryHeader extends StatelessWidget {
  final int count;

  const _SummaryHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: context.onPrimaryColor.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              Icons.agriculture_rounded,
              color: context.onPrimaryColor,
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.cropPlanning,
                  style: context.appTextStyles.sectionTitle.copyWith(
                    color: context.onPrimaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.availableCropScheduleCount(count),
                  style: context.appTextStyles.cardSubtitle.copyWith(
                    color: context.onPrimaryColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // Count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: context.cardBackgroundColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '$count',
              style: context.appTextStyles.cardValue.copyWith(
                color: context.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// LOADING VIEW
// =============================================================

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: context.cardBackgroundColor,
            borderRadius: BorderRadius.circular(22),
          ),
        ),

        const SizedBox(height: 20),

        ...List.generate(
          3,
          (index) => Container(
            height: 230,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: context.cardBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        const SizedBox(height: 20),

        Center(child: CustomLoader(color: context.primaryColor)),
      ],
    );
  }
}

// =============================================================
// ERROR VIEW
// =============================================================

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: context.appColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 40,
                color: context.appColors.error,
              ),
            ),

            const SizedBox(height: 22),

            Text(
              AppLocalizations.of(context)!.unableToLoadSchedules,
              textAlign: TextAlign.center,
              style: context.appTextStyles.headingLarge.copyWith(
                color: context.primaryTextColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: context.appTextStyles.body.copyWith(
                color: context.secondaryTextColor,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {
                context.read<CropScheduleBloc>().add(
                  const GetCropSchedulesEvent(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: context.onPrimaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                AppLocalizations.of(context)!.retry,
                style: context.appTextStyles.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// EMPTY VIEW
// =============================================================

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: context.primaryColor,
      onRefresh: () async {
        context.read<CropScheduleBloc>().add(const RefreshCropSchedulesEvent());
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.27),

          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.agriculture_outlined,
                size: 48,
                color: context.primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              AppLocalizations.of(context)!.noCropSchedule,
              style: context.appTextStyles.headingLarge.copyWith(
                color: context.primaryTextColor,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                AppLocalizations.of(context)!.noCropSchedulesAvailable,
                textAlign: TextAlign.center,
                style: context.appTextStyles.body.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
