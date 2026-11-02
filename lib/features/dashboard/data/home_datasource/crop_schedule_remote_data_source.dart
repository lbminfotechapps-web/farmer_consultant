import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:farmer_consultant/core/api_constant/api_client.dart';
import 'package:farmer_consultant/core/api_constant/dio_client.dart';
import 'package:farmer_consultant/features/dashboard/data/home_model/crop_schedule_model.dart';
import 'package:farmer_consultant/features/dashboard/data/home_model/success_story_model.dart';
import 'package:flutter/material.dart';

class CropScheduleRemoteDataSource {
  final DioClient dioClient;

  CropScheduleRemoteDataSource({required this.dioClient});

  Future<List<CropScheduleModel>> getCropSchedules() async {
    try {
      print('================================');
      print('GET CROP SCHEDULE');
      print('URL: ${ApiClient.getCropsSchedule}');
      print('================================');

      final response = await dioClient.client.get(
        ApiClient.getCropsSchedule,
        options: Options(responseType: ResponseType.plain),
      );

      dynamic responseData = response.data;

      print('Response type: ${responseData.runtimeType}');
      print('Response: $responseData');

      // -----------------------------------------
      // Convert String JSON -> Map
      // -----------------------------------------

      if (responseData is String) {
        String responseString = responseData.trim();

        // In case PHP warning/output comes before JSON
        final jsonStart = responseString.indexOf('{');

        if (jsonStart >= 0) {
          responseString = responseString.substring(jsonStart);
        }

        responseData = jsonDecode(responseString);
      }

      // -----------------------------------------
      // Validate response
      // -----------------------------------------

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Invalid response format from server.');
      }

      // -----------------------------------------
      // Status
      // -----------------------------------------

      final bool status =
          responseData['status'] == true ||
          responseData['status']?.toString().toLowerCase() == 'true';

      if (!status) {
        throw Exception(
          responseData['message']?.toString() ??
              'Unable to fetch crop schedule.',
        );
      }

      // -----------------------------------------
      // Result
      // -----------------------------------------

      final dynamic result = responseData['result'];

      if (result == null) {
        return [];
      }

      if (result is! List) {
        throw Exception('Invalid crop schedule result format.');
      }

      // -----------------------------------------
      // Convert JSON -> Model
      // -----------------------------------------

      final List<CropScheduleModel> schedules = result
          .whereType<Map>()
          .map(
            (json) =>
                CropScheduleModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();

      print('Crop schedules received: ${schedules.length}');

      return schedules;
    } on DioException catch (e) {
      print('Dio error: ${e.message}');

      throw Exception(
        e.response?.data?.toString() ??
            e.message ??
            'Network error while fetching crop schedule.',
      );
    } catch (e) {
      print('Crop schedule error: $e');

      rethrow;
    }
  }

  Future<SuccessStoryModel> getSuccessStoryList(
    String farmerId,
    String fromDate,
    String toDate,
    String startLimit,
  ) async {
    try {
      final response = await dioClient.client.post(
        ApiClient.getSuccessStoriesList,
        data: FormData.fromMap({
          'farmerId': farmerId,
          'fromDate': fromDate,
          'toDate': toDate,
          'startLimit': startLimit,
        }),
      );
print('========== SUCCESS STORY RESPONSE ==========');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');
      final dynamic decodedData = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;

      if (decodedData is! Map) {
        throw const FormatException('Invalid success story list response');
      }

      return SuccessStoryModel.fromJson(Map<String, dynamic>.from(decodedData));
    } catch (e) {
      debugPrint('Get Success Story List Error: $e');
      rethrow;
    }
  }

  Future<Response<dynamic>> updateNotificationStatus(String farmerId) async {
    try {
      final params = <String, dynamic>{'farmerId': farmerId.trim()};

      debugPrint('========== UPDATE NOTIFICATION STATUS ==========');
      debugPrint('Request Params: $params');

      final response = await dioClient.client.post(
        ApiClient.updateNotificationStatus,
        data: FormData.fromMap(params),
      );

      debugPrint('Update Notification Status Response: ${response.data}');
      debugPrint('Status Code: ${response.statusCode}');

      return response;
    } on DioException catch (e) {
      debugPrint('Update Notification Status Dio Error: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Status Code: ${e.response?.statusCode}');

      rethrow;
    } catch (e, stackTrace) {
      debugPrint('Update Notification Status Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      rethrow;
    }
  }
}
