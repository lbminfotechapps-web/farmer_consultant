import 'package:farmer_consultant/l10n/app_localizations.dart';
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_entity/success_story_entity.dart';
import 'package:farmer_consultant/features/dashboard/presentation/home_bloc/crop_schedule_bloc.dart';
import 'package:farmer_consultant/features/dashboard/presentation/home_bloc/crop_schedule_event.dart';
import 'package:farmer_consultant/features/dashboard/presentation/home_bloc/crop_schedule_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class FarmerSuccessStories extends StatefulWidget {
  final String farmerId;

  const FarmerSuccessStories({super.key, required this.farmerId});

  @override
  State<FarmerSuccessStories> createState() => _FarmerSuccessStoriesState();
}

class _FarmerSuccessStoriesState extends State<FarmerSuccessStories> {
  final ScrollController _scrollController = ScrollController();
  final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  DateFormat get _displayDateFormat =>
      DateFormat('dd MMM yyyy', AppLocalizations.of(context)!.localeName);

  final List<SuccessStoryItemEntity> _stories = [];
  DateTime? _fromDate;
  DateTime? _toDate;
  String _appliedFromDate = '';
  String _appliedToDate = '';
  bool _showFilters = false;
  bool _requestPending = false;
  bool _loadingFirstPage = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _error;
  int _nextStartLimit = 0;

  ColorScheme get _colors => Theme.of(context).colorScheme;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadFirstPage();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients ||
        !_hasMore ||
        _requestPending ||
        _error != null) {
      return;
    }
    if (_scrollController.position.extentAfter < 240) {
      _loadMore();
    }
  }

  void _loadFirstPage() {
    if (_requestPending) return;
    setState(() {
      _stories.clear();
      _nextStartLimit = 0;
      _hasMore = true;
      _error = null;
      _loadingFirstPage = true;
      _loadingMore = false;
    });
    _requestPage(0);
  }

  void _loadMore() {
    if (_requestPending || !_hasMore || _loadingFirstPage) return;
    setState(() {
      _loadingMore = true;
      _error = null;
    });
    _requestPage(_nextStartLimit);
  }

  void _requestPage(int startLimit) {
    if (_requestPending) return;
    _requestPending = true;
    context.read<CropScheduleBloc>().add(
      FarmerSuccessStoryEvent(
        farmerId: widget.farmerId,
        fromDate: _appliedFromDate,
        toDate: _appliedToDate,
        startLimit: startLimit.toString(),
      ),
    );
  }

  Future<void> _refresh() async {
    // Avoid issuing a second request while the shared BLoC is loading.
    if (_requestPending) return;
    _loadFirstPage();
    // RefreshIndicator can complete when the server result is received.
    while (mounted && _requestPending) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  void _handleState(CropScheduleState state) {
    if (!_requestPending) return;
    if (state.status == CropScheduleStatus.success) {
      final page =
          state.successStoryEntity?.result ?? <SuccessStoryItemEntity>[];
      setState(() {
        if (_loadingFirstPage) _stories.clear();
        _stories.addAll(page);
        _nextStartLimit += page.length;
        _hasMore = page.isNotEmpty;
        _loadingFirstPage = false;
        _loadingMore = false;
        _requestPending = false;
        _error = null;
      });
    } else if (state.status == CropScheduleStatus.failure) {
      setState(() {
        _error = state.errorMessage?.trim().isNotEmpty == true
            ? state.errorMessage!.trim()
            : AppLocalizations.of(context)!.storiesLoadError;
        _requestPending = false;
        _loadingFirstPage = false;
        _loadingMore = false;
      });
    }
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? (_fromDate ?? now) : (_toDate ?? _fromDate ?? now),
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1),
    );
    if (!mounted || picked == null) return;
    setState(() {
      if (isFrom) {
        _fromDate = picked;
        if (_toDate != null && _toDate!.isBefore(picked)) _toDate = null;
      } else {
        _toDate = picked;
      }
    });
  }

  void _applyFilters() {
    if (_fromDate != null && _toDate != null && _fromDate!.isAfter(_toDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.storiesDateOrderError),
        ),
      );
      return;
    }
    _appliedFromDate = _fromDate == null
        ? ''
        : _apiDateFormat.format(_fromDate!);
    _appliedToDate = _toDate == null ? '' : _apiDateFormat.format(_toDate!);
    setState(() => _showFilters = false);
    _loadFirstPage();
  }

  void _clearFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _appliedFromDate = '';
      _appliedToDate = '';
      _showFilters = false;
    });
    _loadFirstPage();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _colors;
    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      appBar: CommonDashboardAppBar(
        title: AppLocalizations.of(context)!.successStories,
        showProfile: false,
        showThemeButton: true,
        showFilterButton: true,
        onBackTap: () => Navigator.of(context).pop(),
        onFilterTap: () => setState(() => _showFilters = !_showFilters),
      ),
      body: BlocListener<CropScheduleBloc, CropScheduleState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.successStoryEntity != curr.successStoryEntity,
        listener: (context, state) => _handleState(state),
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(18, 4, 10, 4),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Text(
            //           _appliedFromDate.isEmpty && _appliedToDate.isEmpty
            //               ? 'Farmer experiences'
            //               : '${_appliedFromDate.isEmpty ? 'Any date' : _appliedFromDate} – ${_appliedToDate.isEmpty ? 'Today' : _appliedToDate}',
            //           style: Theme.of(context).textTheme.bodySmall?.copyWith(
            //             color: colors.onSurfaceVariant,
            //           ),
            //         ),
            //       ),
            //       TextButton.icon(
            //         onPressed: () =>
            //             setState(() => _showFilters = !_showFilters),
            //         icon: const Icon(Icons.tune_rounded, size: 18),
            //         label: Text(_showFilters ? 'Hide filters' : 'Filter dates'),
            //       ),
            //     ],
            //   ),
            // ),
            if (_showFilters) _buildFilterPanel(),
            Expanded(
              child: RefreshIndicator(onRefresh: _refresh, child: _buildList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    final colors = _colors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.storiesFilterByDate,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _dateField(
                  AppLocalizations.of(context)!.fromDate,
                  _fromDate,
                  () => _pickDate(isFrom: true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _dateField(
                  AppLocalizations.of(context)!.toDate,
                  _toDate,
                  () => _pickDate(isFrom: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _requestPending ? null : _clearFilters,
                  child: Text(AppLocalizations.of(context)!.clear),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: _requestPending ? null : _applyFilters,
                  child: Text(AppLocalizations.of(context)!.storiesShow),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateField(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: _colors.surface,
          border: Border.all(color: _colors.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: _colors.primary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.labelSmall),
                  Text(
                    date == null
                        ? AppLocalizations.of(context)!.selectDate
                        : _displayDateFormat.format(date),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
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

  Widget _buildList() {
    if (_loadingFirstPage && _stories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_stories.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.18),
          Icon(
            _error == null
                ? Icons.auto_stories_outlined
                : Icons.wifi_off_rounded,
            size: 46,
            color: _colors.outline,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _error ?? AppLocalizations.of(context)!.storiesNoResults,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton.icon(
              onPressed: _loadFirstPage,
              icon: const Icon(Icons.refresh),
              label: Text(
                _error == null
                    ? AppLocalizations.of(context)!.storiesRefresh
                    : AppLocalizations.of(context)!.retry,
              ),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
      itemCount: _stories.length + (_loadingMore || _error != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _stories.length) {
          if (_loadingMore) {
            return const Padding(
              padding: EdgeInsets.all(18),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: TextButton.icon(
                onPressed: _loadMore,
                icon: const Icon(Icons.refresh),
                label: Text(_error ?? AppLocalizations.of(context)!.retry),
              ),
            ),
          );
        }
        return _storyCard(_stories[index]);
      },
    );
  }

  Widget _storyCard(SuccessStoryItemEntity story) {
    final colors = _colors;
    final theme = Theme.of(context);
    final url = story.videoUrl.trim();
    final uri = Uri.tryParse(url);
    final canPlay =
        uri != null &&
        uri.host.isNotEmpty &&
        (uri.scheme == 'http' || uri.scheme == 'https');
    final crops = story.cropNames
        .split(',')
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    void openVideo() => Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => SuccessStoryVideoPage(url: url)));

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: colors.surfaceContainerLowest,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: canPlay ? openVideo : null,
            child: Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 260;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: narrow ? 84 : 108,
                        height: narrow ? 76 : 86,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _StoryVideoPreview(
                            key: ValueKey(url),
                            url: canPlay ? url : '',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.farmerName.trim().isEmpty
                                  ? AppLocalizations.of(context)!.storiesFarmer
                                  : story.farmerName.trim(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                            if (story.createdDate.trim().isNotEmpty) ...[
                              const SizedBox(height: 5),
                              Text(
                                story.createdDate.trim(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            // Row(
                            //   children: [
                            //     // Flexible(
                            //     //   child: Text(
                            //     //     canPlay
                            //     //         ? 'Watch story'
                            //     //         : 'Video unavailable',
                            //     //     style: theme.textTheme.labelMedium
                            //     //         ?.copyWith(
                            //     //           color: canPlay
                            //     //               ? colors.primary
                            //     //               : colors.onSurfaceVariant,
                            //     //           fontWeight: FontWeight.w700,
                            //     //         ),
                            //     //   ),
                            //     // ),
                            //     if (canPlay) ...[
                            //       const SizedBox(width: 4),
                            //       Icon(
                            //         Icons.arrow_forward_rounded,
                            //         size: 14,
                            //         color: colors.primary,
                            //       ),
                            //     ],
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (crops.isNotEmpty || story.usedProduct.trim().isNotEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (crops.isNotEmpty) ...[
                    _fieldLabel(
                      Icons.eco_outlined,
                      AppLocalizations.of(context)!.storiesCropName,
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final crop in crops)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: colors.outlineVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            child: Text(
                              crop,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                  if (story.usedProduct.trim().isNotEmpty) ...[
                    if (crops.isNotEmpty) const SizedBox(height: 12),
                    _fieldLabel(
                      Icons.inventory_2_outlined,
                      AppLocalizations.of(context)!.storiesProductName,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      story.usedProduct.trim(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _fieldLabel(IconData icon, String label) => Row(
    children: [
      Icon(icon, size: 15, color: _colors.primary),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: _colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

class _StoryVideoPreview extends StatefulWidget {
  final String url;
  const _StoryVideoPreview({super.key, required this.url});

  @override
  State<_StoryVideoPreview> createState() => _StoryVideoPreviewState();
}

class _StoryVideoPreviewState extends State<_StoryVideoPreview> {
  VideoPlayerController? _controller;
  bool _ready = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    if (widget.url.isNotEmpty) _loadPreview();
  }

  Future<void> _loadPreview() async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller = controller;
    try {
      await controller.initialize();
      if (!mounted) return;
      // Decode a frame without starting playback or audio.
      await controller.seekTo(Duration.zero);
      if (mounted) setState(() => _ready = true);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: colors.surfaceContainerHigh),
        if (_ready)
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.size.width,
              height: _controller!.value.size.height,
              child: VideoPlayer(_controller!),
            ),
          )
        else
          Center(
            child: widget.url.isNotEmpty && !_failed
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.primary,
                    ),
                  )
                : Icon(
                    Icons.videocam_off_outlined,
                    color: colors.onSurfaceVariant,
                  ),
          ),
        if (widget.url.isNotEmpty && (_ready || _failed))
          Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }
}

class SuccessStoryVideoPage extends StatefulWidget {
  final String url;
  const SuccessStoryVideoPage({super.key, required this.url});

  @override
  State<SuccessStoryVideoPage> createState() => _SuccessStoryVideoPageState();
}

class _SuccessStoryVideoPageState extends State<SuccessStoryVideoPage> {
  late final VideoPlayerController _controller;
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _initialization = _controller.initialize().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.storiesVideoTitle),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  AppLocalizations.of(context)!.storiesVideoError,
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio > 0
                      ? _controller.value.aspectRatio
                      : 16 / 9,
                  child: VideoPlayer(_controller),
                ),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  }),
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
