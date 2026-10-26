import '../../domain/entities/important_link_entity.dart';
import '../../domain/repositories/important_links_repository.dart';

import '../datasources/important_links_remote_data_source.dart';

class ImportantLinksRepositoryImpl implements ImportantLinksRepository {
  final ImportantLinksRemoteDataSource remoteDataSource;

  ImportantLinksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ImportantLinkEntity>> getImportantLinks() {
    return remoteDataSource.getImportantLinks();
  }
}
