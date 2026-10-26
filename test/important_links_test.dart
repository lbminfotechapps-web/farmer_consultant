import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:farmer_consultant/core/api_constant/dio_client.dart';
import 'package:farmer_consultant/features/important_links/data/datasources/important_links_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

class _LinksAdapter implements HttpClientAdapter {
  final String contentType;

  _LinksAdapter(this.contentType);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    expect(options.method, 'POST');
    expect(options.uri.path, endsWith('/get_important_link'));
    return ResponseBody.fromString(
      jsonEncode({
        'status': true,
        'result': [
          {
            'fld_link_id': '1',
            'fld_description': 'This is CRM Project Link',
            'fld_link': 'https://agroaicrm.com/solufine_agritech',
          },
          {
            'fld_link_id': '2',
            'fld_description': 'Its IT Based Company Located in Nashik',
            'fld_link': 'https://lbmsoft.in',
          },
        ],
        'message': 'RECORD FOUND.',
      }),
      200,
      headers: {Headers.contentTypeHeader: [contentType]},
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  for (final contentType in ['text/html; charset=UTF-8', 'application/json']) {
    test('loads important links served as $contentType', () async {
      final client = DioClient();
      final originalAdapter = client.client.httpClientAdapter;
      addTearDown(() => client.client.httpClientAdapter = originalAdapter);
      client.client.httpClientAdapter = _LinksAdapter(contentType);

      final links = await ImportantLinksRemoteDataSourceImpl(
        dioClient: client,
      ).getImportantLinks();

      expect(links, hasLength(2));
      expect(links.first.linkId, '1');
      expect(links.first.description, 'This is CRM Project Link');
      expect(links.first.link, 'https://agroaicrm.com/solufine_agritech');
      expect(links.last.link, 'https://lbmsoft.in');
    });
  }
}
