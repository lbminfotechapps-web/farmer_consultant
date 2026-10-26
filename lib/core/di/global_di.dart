import 'package:farmer_consultant/core/di/crop_di.dart';
import 'package:farmer_consultant/core/di/login_di.dart';
import 'package:farmer_consultant/core/di/notification_di.dart';
import 'package:farmer_consultant/core/di/organization_di.dart';
import 'package:farmer_consultant/core/di/product_di.dart';
import 'package:farmer_consultant/core/di/social_media_di.dart';
import 'package:farmer_consultant/core/di/theme_di.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initGlobalDi() async {
  await initLoginDi();
  await ThemeDI.register(sl);
  await initCropDi();
  await initProductDi();
  await initNotificationDi();
  await initSocialMediaDi();
   OrganizationDI();
}
