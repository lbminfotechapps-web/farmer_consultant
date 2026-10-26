import '../entities/important_link_entity.dart';

abstract class ImportantLinksRepository {
  Future<List<ImportantLinkEntity>> getImportantLinks();
}
