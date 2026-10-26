import 'package:farmer_consultant/core/api_constant/dio_client.dart';
import 'package:farmer_consultant/core/notification/fcm_token_service.dart';
import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/core/utility/device_info_util.dart';
import 'package:farmer_consultant/features/login/data/datasource/auth_datasource.dart';
import 'package:farmer_consultant/features/login/data/repository/login_repo_imp.dart';
import 'package:farmer_consultant/features/login/domain/repository/login_repository.dart';
import 'package:farmer_consultant/features/login/domain/usecase/login_usecase.dart';
import 'package:farmer_consultant/features/login/presentation/bloc/login_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initLoginDi() async {
  sl.registerLazySingleton<DioClient>(() => DioClient());

  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSource(sl<DioClient>()),
  );
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage.instance);
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepoImp(sl<LoginRemoteDataSource>(), sl<SecureStorage>()),
  );

  sl.registerLazySingleton<FcmTokenService>(() => FcmTokenService.instance);

  // Device Info
  sl.registerLazySingleton<DeviceInfoUtil>(() => DeviceInfoUtil.instance);

  sl.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(
      sl<LoginRepository>(),
      sl<FcmTokenService>(),
      sl<DeviceInfoUtil>(),
    ),
  );

  // Auth Bloc
  sl.registerFactory<LoginBloc>(() => LoginBloc(sl<LoginUsecase>()));
}
