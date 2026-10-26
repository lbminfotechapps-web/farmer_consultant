import '../entities/important_link_entity.dart';
import '../repositories/important_links_repository.dart';

class GetImportantLinks {
  final ImportantLinksRepository repository;

  GetImportantLinks(this.repository);

  Future<List<ImportantLinkEntity>> call() {
    return repository.getImportantLinks();
  }
}
