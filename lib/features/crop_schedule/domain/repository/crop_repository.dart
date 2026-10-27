import 'package:dio/dio.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/available_dates_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/plot_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_detail_respo_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_response_entity.dart';

abstract class CropRepository {
  Future<ScheduleResponseEntity> getFarmerScheduleList(
    String farmerId,

    String fromDate,
    String toDate,
  );

    Future<AvailableDatesEntity> getAvailableDates(
    String farmerId,
  );


  Future<PlotResponseEntity> getPlotList(
    String farmerId,
    String plotName,
    String cropId,
    String startLimit,
  );

  Future<ScheduleByPlotResponseEntity> getScheduleListByPlot(
    String farmerId,
    String plotId,
    String cropId,
    String fromDate,
    String toDate,
    String startLimit,
  );

  Future<Response> updateScheduleStatus(String scheduleId, String farmerId);
}
