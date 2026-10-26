import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:farmer_consultant/core/api_constant/api_client.dart';
import 'package:farmer_consultant/core/api_constant/dio_client.dart';
import 'package:farmer_consultant/features/login/data/model/login_model.dart';
import 'package:flutter/foundation.dart';

class LoginRemoteDataSource {
  final DioClient dioClient;

  LoginRemoteDataSource(this.dioClient);

  Future<String> getOtp(String mobileNo) async {
    try {
      final response = await dioClient.client.post(
        ApiClient.getOtp,
        data: FormData.fromMap({'mobileNo': mobileNo}),
      );
      final dynamic rawData = response.data;

      final dynamic decodedData = rawData is String
          ? jsonDecode(rawData)
          : rawData;

      if (decodedData is! Map) {
        throw Exception('Invalid API response format');
      }

      final data = Map<String, dynamic>.from(decodedData);

      final bool isSuccess =
          data['status'] == true ||
          data['status']?.toString().toLowerCase() == 'true';

      if (isSuccess) {
        final String otp = data['otp']?.toString().trim() ?? '';

        if (otp.isEmpty) {
          throw Exception('OTP not found in API response');
        }

        // Don't log OTP in production.
        debugPrint('Get OTP success');

        return otp;
      }

      throw Exception(data['message']?.toString() ?? 'Failed to get OTP');
    } on DioException catch (e) {
      debugPrint('Dio Error: ${e.message}');

      throw Exception('Failed to get OTP: ${e.message}');
    } on FormatException {
      throw Exception('Invalid JSON received from server');
    }
  }

  Future<LoginModel> login({
    required String mobileNo,
    required String otp,
    required String fcmId,
    required String macAddress,
  }) async {
    try {
      final response = await dioClient.client.post(
        ApiClient.farmerLogin,
        data: FormData.fromMap({
          'mobileNo': mobileNo.trim(),
          'otp': otp.trim(),
          'fcmId': fcmId,
          'macAddress': macAddress,
        }),
      );

      print('mobile no $mobileNo');
      print('otp $otp');
      print('fcmId $fcmId');
      print('macAddress $macAddress');

      if (kDebugMode) {
        debugPrint('LOGIN STATUS CODE: ${response.statusCode}');
      }

      print('login response $response');

      if (response.data == null ||
          (response.data is String &&
              (response.data as String).trim().isEmpty)) {
        throw Exception(
          'Server returned an empty login response. Please try again.',
        );
      }

      final dynamic data = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;
      if (data is! Map) {
        throw Exception('Invalid server response');
      }

      final model = LoginModel.fromJson(Map<String, dynamic>.from(data));

      if (!model.status) {
        throw Exception(
          model.message.isNotEmpty
              ? model.message
              : 'Login failed. Please try again.',
        );
      }

      if (model.farmerId.isEmpty) {
        throw Exception('Farmer details not found');
      }

      return model;
    } on FormatException {
      throw Exception('Server returned invalid login JSON. Please try again.');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timed out. Please try again.');
      }

      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Cannot connect to server.');
      }

      throw Exception(
        'Login request failed: ${e.response?.statusCode ?? e.message}',
      );
    }
  }
}
