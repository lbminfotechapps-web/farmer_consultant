import 'package:farmer_consultant/core/notification/fcm_token_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('token service is safe before Firebase initialization', () async {
    final service = FcmTokenService.instance;
    expect(await service.getFcmToken(), isNull);
    expect(
      () => service.listenTokenRefresh(onTokenChanged: (_) async {}),
      returnsNormally,
    );
  });
}
