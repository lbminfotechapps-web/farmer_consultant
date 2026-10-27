import 'package:farmer_consultant/core/router/app_router.dart';
import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/plot_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_event.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// Replace these with your actual project import paths.
// import '.../crop_bloc.dart';
// import '.../crop_event.dart';
// import '.../crop_state.dart';
// import '.../plot_entity.dart';
// import '.../secure_storage.dart';
// import '.../common_dashboard_app_bar.dart';

class PlotList extends StatefulWidget {
  const PlotList({super.key});

  @override
  State<PlotList> createState() => _PlotListState();
}

class _PlotListState extends State<PlotList> {
  String _farmerId = '';
  late final CropBloc _plotBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _plotBloc = CropBloc(
      cropScheduleUsecases: context.read<CropBloc>().cropScheduleUsecases,
    );
    _scrollController.addListener(_onScroll);
    _loadPlots();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _plotBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.userScrollDirection == ScrollDirection.reverse &&
        _scrollController.position.extentAfter < 200 &&
        _plotBloc.state.plotPaginationError == null) {
      _loadMorePlots();
    }
  }

  void _loadMorePlots() {
    final state = _plotBloc.state;
    if (_farmerId.isEmpty ||
        state.loadingMorePlots ||
        state.cropStatus != CropStatus.success ||
        !state.hasMorePlots) {
      return;
    }
    _plotBloc.add(
      GetPlotListEvent(
        farmerId: _farmerId,
        startLimit: state.nextPlotOffset.toString(),
      ),
    );
  }

  Future<void> _loadPlots() async {
    try {
      final farmerId = await SecureStorage.instance.getFarmerId();

      if (!mounted) return;

      if (farmerId.isEmpty || farmerId == '0') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Farmer login information not found')),
        );
        return;
      }

      _farmerId = farmerId;

      _plotBloc.add(GetPlotListEvent(farmerId: farmerId, startLimit: '0'));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to load plots: $e')));
    }
  }

  Future<void> _refreshPlots() async {
    if (_plotBloc.state.loadingMorePlots ||
        _plotBloc.state.cropStatus == CropStatus.loading) {
      return;
    }
    if (_farmerId.isEmpty) {
      await _loadPlots();
      return;
    }

    final bloc = _plotBloc;

    final resultFuture = bloc.stream.firstWhere(
      (state) =>
          state.cropStatus == CropStatus.success ||
          state.cropStatus == CropStatus.failure,
    );

    bloc.add(GetPlotListEvent(farmerId: _farmerId, startLimit: '0'));

    await resultFuture;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: CommonDashboardAppBar(
        title: 'My Plots',
        showProfile: false,
        showNotification: false,
        showThemeButton: true,
        onBackTap: () =>   context.go(AppRouter.dashboard),
        
      ),

      body: BlocBuilder<CropBloc, CropState>(
        bloc: _plotBloc,
        buildWhen: (previous, current) =>
            previous.cropStatus != current.cropStatus ||
            previous.plotLits != current.plotLits ||
            previous.loadingMorePlots != current.loadingMorePlots ||
            previous.plotPaginationError != current.plotPaginationError,
        builder: (context, state) {
          if (state.cropStatus == CropStatus.initial ||
              state.cropStatus == CropStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
          }

          if (state.cropStatus == CropStatus.failure) {
            return _buildEmptyState(
              context,
              Icons.error_outline_rounded,
              'Unable to load plots',
              state.errorMessage ?? 'Something went wrong',
              'Try Again',
              _loadPlots,
            );
          }

          final plots = state.plotLits;

          if (plots.isEmpty) {
            return _buildEmptyState(
              context,
              Icons.landscape_outlined,
              'No plots available',
              'Your registered farmland will appear here.',
              'Refresh',
              _loadPlots,
            );
          }


          return RefreshIndicator(
            onRefresh: _refreshPlots,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(13, 13, 13, 24),
              itemCount: plots.length + 2,
              itemBuilder: (context, index) {
                if (index == plots.length + 1) {
                  if (state.loadingMorePlots) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state.plotPaginationError != null) {
                    return Center(
                      child: TextButton(
                        onPressed: _loadMorePlots,
                        child: const Text(
                          'Unable to load more plots. Tap to retry',
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }
                if (index == 0) {
                  return _buildHeader(context, plots.length);
                }

                final plot = plots[index - 1];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      context.push(
                        'cropScheduleByPlot',
                        extra: plot.plotRegistrationId,
                      );
                    },
                    child: _PlotCard(plot: plot),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.agriculture_rounded,
              color: colors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Registered Plots',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Your fields and crop details',
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count Plots',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String buttonText,
    VoidCallback onRetry,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 38, color: colors.primary),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// COMPACT PLOT CARD
// ====================================================

class _PlotCard extends StatelessWidget {
  final PlotEntity plot;

  const _PlotCard({required this.plot});

  String _formatDate(String date, String pattern) {
    if (date.trim().isEmpty) return '-';

    try {
      return DateFormat(
        'dd MMM yyyy',
      ).format(DateFormat(pattern).parseStrict(date));
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.035),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plot heading
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.grass_rounded,
                    color: colors.primary,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plot.plotName.isNotEmpty
                            ? plot.plotName
                            : 'Unnamed Plot',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: colors.onSurface,
                        ),
                      ),
                      // const SizedBox(height: 3),
                      // Text(
                      //   'Plot ID: #${plot.plotRegistrationId}',
                      //   style: TextStyle(
                      //     fontSize: 11,
                      //     color: colors.onSurfaceVariant,
                      //   ),
                      // ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Schedule',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 11),

            Divider(height: 1, color: colors.outlineVariant),

            const SizedBox(height: 11),

            // Crop and sowing date
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _PlotInfo(
                    icon: Icons.spa_outlined,
                    label: 'CROP NAME',
                    value: plot.cropName,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PlotInfo(
                    icon: Icons.calendar_today_outlined,
                    label: 'SOWING DATE',
                    value: _formatDate(plot.sowingDate, 'dd-MM-yyyy'),
                  ),
                ),
              ],
            ),

            // if (plot.farmerName.isNotEmpty || plot.createdDate.isNotEmpty) ...[
            //   const SizedBox(height: 12),

            //   Divider(height: 1, color: colors.outlineVariant),

            //   const SizedBox(height: 9),

            //   Row(
            //     children: [
            //       if (plot.farmerName.isNotEmpty) ...[
            //         Icon(
            //           Icons.person_outline_rounded,
            //           color: colors.onSurfaceVariant,
            //           size: 14,
            //         ),
            //         // const SizedBox(width: 4),
            //         // Expanded(
            //         //   child: Text(
            //         //     plot.farmerName,
            //         //     maxLines: 1,
            //         //     overflow: TextOverflow.ellipsis,
            //         //     style: TextStyle(
            //         //       fontSize: 11,
            //         //       color: colors.onSurfaceVariant,
            //         //     ),
            //         //   ),
            //         // ),
            //       ] else
            //         const Spacer(),

            //       // if (plot.createdDate.isNotEmpty)
            //       //   Text(
            //       //     'Created ${_formatDate(plot.createdDate, 'yyyy-MM-dd')}',
            //       //     style: TextStyle(
            //       //       fontSize: 10,
            //       //       color: colors.onSurfaceVariant,
            //       //     ),
            //       //   ),
            //     ],
            //   ),
            // ],
          ],
        ),
      ),
    );
  }
}

// ====================================================
// REUSABLE INFORMATION ROW
// ====================================================

class _PlotInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _PlotInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: colors.primary),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        Text(
          value.isNotEmpty ? value : '-',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}
