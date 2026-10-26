import 'package:farmer_consultant/core/api_constant/dio_client.dart';
import 'package:farmer_consultant/features/important_links/data/datasources/important_links_remote_data_source.dart';
import 'package:farmer_consultant/features/important_links/data/repositories/important_links_repository_impl.dart';
import 'package:farmer_consultant/features/important_links/domain/repositories/important_links_repository.dart';
import 'package:farmer_consultant/features/important_links/domain/usecases/%20get_important_links.dart';
import 'package:farmer_consultant/features/important_links/presentation/bloc/important_links_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initImportantLinksDi() async {
  sl.registerLazySingleton<ImportantLinksRemoteDataSource>(
    () => ImportantLinksRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  sl.registerLazySingleton<ImportantLinksRepository>(
    () => ImportantLinksRepositoryImpl(
      remoteDataSource: sl<ImportantLinksRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetImportantLinks>(
    () => GetImportantLinks(sl<ImportantLinksRepository>()),
  );

  sl.registerFactory<ImportantLinksBloc>(
    () => ImportantLinksBloc(getImportantLinks: sl<GetImportantLinks>()),
  );
}
