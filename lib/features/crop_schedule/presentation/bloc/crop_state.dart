import 'package:farmer_consultant/features/crop_schedule/domain/entity/available_dates_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/plot_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_detail_respo_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_response_entity.dart';

enum CropStatus { initial, loading, success, failure }

class CropState {
   
  final bool loadingMorePlots;
  final bool hasMorePlots;
  final int nextPlotOffset;
  final String? plotPaginationError;
  final bool loadingMore;
  final bool hasMoreSchedules;
  final int nextScheduleOffset;
  final String? paginationError;
  final CropStatus cropStatus;
  final String? errorMessage;
  final List<ScheduleEntity> sceduleentityList;
  final List<PlotEntity> plotLits;
  final List<ScheduleByPlotEntity> scheduleByPlotList;
  final List<String> availableDateList;


  const CropState({
    this.loadingMorePlots = false,
    this.hasMorePlots = true,
    this.nextPlotOffset = 0,
    this.plotPaginationError,
    this.loadingMore = false,
    this.hasMoreSchedules = true,
    this.nextScheduleOffset = 0,
    this.paginationError,
    this.cropStatus = CropStatus.initial,
    this.errorMessage,
    this.sceduleentityList = const [],
    this.plotLits = const [],
    this.scheduleByPlotList = const [],
    this.availableDateList = const [],
  });

  CropState copyWith({
    bool? loadingMorePlots,
    bool? hasMorePlots,
    int? nextPlotOffset,
    String? plotPaginationError,
    bool clearPlotPaginationError = false,
    bool? loadingMore,
    bool? hasMoreSchedules,
    int? nextScheduleOffset,
    String? paginationError,
    CropStatus? cropStatus,
    String? errorMessage,
    List<ScheduleEntity>? sceduleentityList,
    List<PlotEntity>? plotLits,
    bool clearError = false,
    List<ScheduleByPlotEntity>? scheduleByPlotList,
 List<String>? availableDateList,
  }) {
    return CropState(
      loadingMorePlots: loadingMorePlots ?? this.loadingMorePlots,
      hasMorePlots: hasMorePlots ?? this.hasMorePlots,
      nextPlotOffset: nextPlotOffset ?? this.nextPlotOffset,
      plotPaginationError: clearPlotPaginationError
          ? null
          : (plotPaginationError ?? this.plotPaginationError),
      loadingMore: loadingMore ?? this.loadingMore,
      hasMoreSchedules: hasMoreSchedules ?? this.hasMoreSchedules,
      nextScheduleOffset: nextScheduleOffset ?? this.nextScheduleOffset,
      paginationError: paginationError,
      cropStatus: cropStatus ?? this.cropStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      sceduleentityList: sceduleentityList ?? this.sceduleentityList,
      plotLits: plotLits ?? this.plotLits,
      scheduleByPlotList: scheduleByPlotList ?? this.scheduleByPlotList,
      availableDateList: availableDateList ?? this.availableDateList,
    );
  }
}
