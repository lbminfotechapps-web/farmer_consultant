import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:farmer_consultant/core/api_constant/api_client.dart';
import 'package:farmer_consultant/core/api_constant/dio_client.dart';

import '../models/important_link_model.dart';

abstract class ImportantLinksRemoteDataSource {
  Future<List<ImportantLinkModel>> getImportantLinks();
}

class ImportantLinksRemoteDataSourceImpl
    implements ImportantLinksRemoteDataSource {
  final DioClient dioClient;

  ImportantLinksRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ImportantLinkModel>> getImportantLinks() async {
    try {
      final response = await dioClient.client.post(ApiClient.getImportantLinks);

      // This endpoint sends JSON with a text/html content type, so Dio may
      // return the body as a String instead of decoding it automatically.
      final body = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;
      if (body is! Map) {
        throw const FormatException('Invalid important links response');
      }
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        body,
      );

      if (data['status'] == true) {
        final List<dynamic> result = data['result'] as List<dynamic>? ?? [];

        return result.map((item) {
          return ImportantLinkModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          );
        }).toList();
      }

      throw Exception(
        data['message']?.toString() ?? 'Failed to load important links',
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?.toString() ?? e.message ?? 'Network error',
      );
    }
  }
}

