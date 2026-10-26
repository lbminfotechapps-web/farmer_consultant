import 'package:farmer_consultant/core/api_constant/dio_client.dart';
import 'package:farmer_consultant/features/gallery/data/repoimp/gallerydatasourceImp.dart';
import 'package:farmer_consultant/features/gallery/domain/usecases/GetGalleryDetails.dart';
import 'package:farmer_consultant/features/gallery/presentation/boc/gallery_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../features/gallery/data/datasource/gallery_datasource.dart';
import '../../features/gallery/domain/repository/gallery_repository.dart';

final sl = GetIt.instance;

Future<void> initGalleryDi() async {
  // =========================
  // DATA SOURCE
  // =========================
  sl.registerLazySingleton<GalleryDatasource>(
    () => GalleryDatasource(dioClient: sl<DioClient>()),
  );

  // =========================
  // REPOSITORY
  // =========================
  sl.registerLazySingleton<GalleryRepository>(
    () => GalleryDatasourceImpl(sl<GalleryDatasource>()),
  );

  // =========================
  // USE CASE
  // =========================
  sl.registerLazySingleton<GetGalleryDetails>(
    () => GetGalleryDetails(repository: sl<GalleryRepository>()),
  );

  // =========================
  // BLOC
  // =========================
  sl.registerFactory<GalleryBloc>(
    () => GalleryBloc(getGalleryDetails: sl<GetGalleryDetails>()),
  );
}
