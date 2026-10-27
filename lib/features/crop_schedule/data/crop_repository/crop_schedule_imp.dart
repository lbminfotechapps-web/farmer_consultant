import 'package:dio/src/response.dart';
import 'package:farmer_consultant/features/crop_schedule/data/crop_datasource/crop_datasource.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/available_dates_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/plot_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_detail_respo_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/repository/crop_repository.dart';

class CropScheduleImp extends CropRepository {
  final CropDatasource cropDatasource;

  CropScheduleImp(this.cropDatasource);

  @override
  Future<ScheduleResponseEntity> getFarmerScheduleList(
    String farmerId,
    String fromDate,
    String toDate,
  ) {
    return cropDatasource.getScheduleList(farmerId, fromDate, toDate);
  }

  @override
  Future<PlotResponseEntity> getPlotList(
    String farmerId,
    String plotName,
    String cropId,
    String startLimit,
  ) {
    return cropDatasource.getPlotList(farmerId, plotName, cropId, startLimit);
  }

  @override
  Future<ScheduleByPlotResponseEntity> getScheduleListByPlot(
    String farmerId,
    String plotId,
    String cropId,
    String fromDate,
    String toDate,
    String startLimit,
  ) {
    return cropDatasource.getScheduleListByPlot(
      farmerId,
      plotId: plotId,
      cropId: cropId,
      fromDate: fromDate,
      toDate: toDate,
      startLimit: startLimit,
    );
  }

  @override
  Future<Response<dynamic>> updateScheduleStatus(
    String scheduleId,
    String farmerId,
  ) {
    return cropDatasource.updateScheduleStatus(scheduleId, farmerId);
  }

  @override
  Future<AvailableDatesEntity> getAvailableDates(String farmerId) {
    return cropDatasource.getAvailableDates(farmerId);
  }
}
