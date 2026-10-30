import 'package:dio/dio.dart';
import 'package:farmer_consultant/features/crop_schedule/data/model/plot_finance_model.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/available_dates_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/plot_finance_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/plot_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_detail_respo_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/repository/crop_repository.dart';

class CropScheduleUsecases {
  final CropRepository cropRepository;

  CropScheduleUsecases(this.cropRepository);

  Future<ScheduleResponseEntity> getFarmerScheduleList(
    String farmerId,

    String fromDate,
    String toDate,
  ) {
    return cropRepository.getFarmerScheduleList(farmerId, fromDate, toDate);
  }

  Future<AvailableDatesEntity> getAvailableDates(String farmerId) {
    return cropRepository.getAvailableDates(farmerId);
  }

  Future<PlotResponseEntity> getPlotList(
    String farmerId,

    String plotName,
    String cropId,
    String startLimit,
  ) {
    return cropRepository.getPlotList(farmerId, plotName, cropId, startLimit);
  }

  Future<ScheduleByPlotResponseEntity> getScheduleListByPlot(
    String farmerId,

    String plotId,
    String cropId,

    String fromDate,
    String toDate,
    String startLimit,
  ) {
    return cropRepository.getScheduleListByPlot(
      farmerId,
      plotId,
      cropId,
      fromDate,
      toDate,
      startLimit,
    );
  }

  Future<Response> updateScheduleStatus(String scheduleId, String farmerId) {
    return cropRepository.updateScheduleStatus(scheduleId, farmerId);
  }

  Future<Response> addPlotFinance(
    String date,

    String amount,
    String remark,

    String farmerId,
    String plotId,
    String type,
  ) {
    return cropRepository.addPlotFinance(
      date,
      amount,
      remark,
      farmerId,
      plotId,
      type,
    );
  }

  Future<PlotFinanceEntity> getPlotFinance(
    String farmerId,
    String plotId,
    String type,
  ) {
    return cropRepository.getPlotFinance(farmerId, plotId, type);
  }

  Future<Response> deletePlotFinance(String financeId, String farmerId) {
    return cropRepository.deletePlotFinance(financeId, farmerId);
  }
}
