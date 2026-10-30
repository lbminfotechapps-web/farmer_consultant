import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:farmer_consultant/core/api_constant/api_client.dart';
import 'package:farmer_consultant/core/api_constant/dio_client.dart';
import 'package:farmer_consultant/features/crop_schedule/data/model/available_dates_model.dart';
import 'package:farmer_consultant/features/crop_schedule/data/model/plot_finance_model.dart';
import 'package:farmer_consultant/features/crop_schedule/data/model/plot_response_model.dart';
import 'package:farmer_consultant/features/crop_schedule/data/model/schedule_detail_respo_model.dart';
import 'package:farmer_consultant/features/crop_schedule/data/model/schedule_response_model.dart';
import 'package:flutter/foundation.dart';

class CropDatasource {
  final DioClient dioClient;

  CropDatasource(this.dioClient);

  Future<ScheduleResponseModel> getScheduleList(
    String farmerId,
    String fromDate,
    String toDate,
  ) async {
    debugPrint('farmerId datasource: $farmerId');
    debugPrint('fromDate: $fromDate');
    debugPrint('toDate: $toDate');

    final response = await dioClient.client.post(
      ApiClient.getFarmerScheduleList,
      data: FormData.fromMap({
        'farmerId': farmerId,
        if (fromDate.trim().isNotEmpty) 'fromDate': fromDate.trim(),
        if (toDate.trim().isNotEmpty) 'toDate': toDate.trim(),
      }),
    );

    debugPrint('Schedule API response: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception('Failed to load schedules (${response.statusCode})');
    }

    final dynamic rawData = response.data;

    final dynamic decodedData = rawData is String
        ? jsonDecode(rawData)
        : rawData;

    if (decodedData is! Map) {
      throw const FormatException('Invalid schedule API response');
    }

    return ScheduleResponseModel.fromJson(
      Map<String, dynamic>.from(decodedData),
    );
  }

  Future<AvailableDatesModel> getAvailableDates(String farmerId) async {
    debugPrint('farmerId datasource: $farmerId');

    final response = await dioClient.client.post(
      ApiClient.getFarmerScheduleDateList,
      data: FormData.fromMap({'farmerId': farmerId}),
    );

    debugPrint('Schedule API response: ${response.data}');

    if (response.statusCode != 200) {
      throw Exception('Failed to load schedules (${response.statusCode})');
    }

    final dynamic rawData = response.data;

    final dynamic decodedData = rawData is String
        ? jsonDecode(rawData)
        : rawData;

    if (decodedData is! Map) {
      throw const FormatException('Invalid schedule API response');
    }

    return AvailableDatesModel.fromJson(Map<String, dynamic>.from(decodedData));
  }

  Future<PlotResponseModel> getPlotList(
    String farmerId,
    String plotName,
    String cropId,
    String startLimit,
  ) async {
    debugPrint('Plot list request: startLimit=$startLimit');
    final response = await dioClient.client.post(
      ApiClient.getFarmerWisePlots,
      data: FormData.fromMap({
        'farmerId': farmerId,
        'plotName': plotName,
        'cropId': cropId,
        'startLimit': startLimit,
      }),
    );
    debugPrint('farmerId datasource: $farmerId');
    debugPrint('plotName: $plotName');
    debugPrint('cropId: $cropId');
    debugPrint('startLimit: $startLimit');

    final dynamic rawData = response.data;
    debugPrint('Plot API response: ${rawData}');
    final dynamic decodedData = rawData is String
        ? jsonDecode(rawData)
        : rawData;

    if (decodedData is! Map) {
      throw const FormatException('Invalid plot list response');
    }

    final result = PlotResponseModel.fromJson(
      Map<String, dynamic>.from(decodedData),
    );
    debugPrint(
      'Plot list response: startLimit=$startLimit, '
      'count=${result.result.length}, '
      'ids=${result.result.map((plot) => plot.plotRegistrationId).join(',')}',
    );
    return result;
  }

  Future<ScheduleByPlotResponseModel> getScheduleListByPlot(
    String farmerId, {
    String? fromDate,
    String? toDate,
    String? plotId,
    String? cropId,
    String? startLimit,
  }) async {
    final response = await dioClient.client.post(
      ApiClient.getPlotwiseScheduleList,
      data: FormData.fromMap({
        'farmerId': farmerId,
        'plotId': plotId,
        'cropId': cropId,
        'fromDate': fromDate,
        'toDate': toDate,
        'startLimit': startLimit,
      }),
    );
    debugPrint('farmerId datasource: $farmerId');
    debugPrint('plotId: $plotId');
    debugPrint('cropId: $cropId');

    debugPrint('fromDate: $fromDate');
    debugPrint('toDate: $toDate');
    debugPrint('startLimit: $startLimit');

    final dynamic decodedData = response.data is String
        ? jsonDecode(response.data as String)
        : response.data;
    debugPrint('Plot Crop Schedule API response: ${decodedData}');
    if (decodedData is! Map) {
      throw const FormatException('Invalid schedule response');
    }

    return ScheduleByPlotResponseModel.fromJson(
      Map<String, dynamic>.from(decodedData),
    );
  }

  Future<Response<dynamic>> updateScheduleStatus(
    String scheduleId,

    String farmerId,
  ) async {
    try {
      final params = <String, dynamic>{
        'scheduleId': scheduleId.trim(),

        'farmerId': farmerId.trim(),
      };

      debugPrint('========== UPDATE SCHEDULE STATUS ==========');
      debugPrint('Request Params: $params');

      final response = await dioClient.client.post(
        ApiClient.updateSchedule,
        data: FormData.fromMap(params),
      );

      debugPrint('Update Schedule Status Response: ${response.data}');
      debugPrint('Status Code: ${response.statusCode}');

      // Return the API response
      return response;
    } on DioException catch (e) {
      debugPrint('Update Schedule Dio Error: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Status Code: ${e.response?.statusCode}');

      // Preserve DioException for handling in BLoC.
      rethrow;
    } catch (e) {
      debugPrint('Update Schedule Status Error: $e');

      throw Exception('Failed to update schedule status: $e');
    }
  }

  Future<Response<dynamic>> addPlotFinance(
    String date,

    String amount,
    String remark,

    String farmerId,
    String plotId,
    String type,
  ) async {
    try {
      final params = <String, dynamic>{
        'date': date.trim(),

        'amount': amount.trim(),

        'remark': remark.trim(),

        'farmerId': farmerId.trim(),
        'plotId': plotId.trim(),
        'type': type.trim(),
      };

      debugPrint('========== ADD PLOT FINACE STATUS ==========');
      debugPrint('Request Params: $params');

      final response = await dioClient.client.post(
        ApiClient.addPlotFinance,
        data: FormData.fromMap(params),
      );

      debugPrint('Add Plot Finance Status Response: ${response.data}');
      debugPrint('Status Code: ${response.statusCode}');

      // Return the API response
      return response;
    } on DioException catch (e) {
      debugPrint('Update Plot Finance Dio Error: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Status Code: ${e.response?.statusCode}');

      // Preserve DioException for handling in BLoC.
      rethrow;
    } catch (e) {
      debugPrint('Update  Plot Finance Status Error: $e');

      throw Exception('Failed to  Plot Finance status: $e');
    }
  }

  Future<PlotFinanceModel> getPlotFinance(
    String farmerId,
    String plotId,
    String type,
  ) async {
    final response = await dioClient.client.post(
      ApiClient.getPlotFinanceList,
      data: FormData.fromMap({
        'farmerId': farmerId,
        'plotId': plotId,
        'type': type,
      }),
    );
    debugPrint('farmerId datasource: $farmerId');
    debugPrint('plotId: $plotId');
    debugPrint('type: $type');

    final dynamic rawData = response.data;
    debugPrint('Plot Finance API response: $rawData');
    final dynamic decodedData = rawData is String
        ? jsonDecode(rawData)
        : rawData;

    if (decodedData is! Map) {
      throw const FormatException('Invalid plot list response');
    }

    final result = PlotFinanceModel.fromJson(
      Map<String, dynamic>.from(decodedData),
    );

    return result;
  }

  Future<Response<dynamic>> deletePlotFinance(
    String financeId,

    String farmerId,
  ) async {
    try {
      final params = <String, dynamic>{
        'financeId': financeId.trim(),

        'farmerId': farmerId.trim(),
      };

      debugPrint('========== Delete Plot Finance STATUS ==========');
      debugPrint('Request Params: $params');
      debugPrint('farmerId datasource: $farmerId');
      debugPrint('financeId: $financeId');
      debugPrint('farmerId: $farmerId');

      final response = await dioClient.client.post(
        ApiClient.deleteplotfinance,
        data: FormData.fromMap(params),
      );

      debugPrint(' Delete Plot Finance Status Response: ${response.data}');
      debugPrint(' Delete Plot Finance Status Code: ${response.statusCode}');

      // Return the API response
      return response;
    } on DioException catch (e) {
      debugPrint(' Delete Plot Finance Dio Error: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Status Code: ${e.response?.statusCode}');

      // Preserve DioException for handling in BLoC.
      rethrow;
    } catch (e) {
      debugPrint(' Delete Plot Finance Status Error: $e');

      throw Exception('Failed to  Delete Plot Finance status: $e');
    }
  }
}
