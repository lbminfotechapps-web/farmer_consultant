import 'package:farmer_consultant/features/gallery/domain/entities/gallery_entity.dart';
import 'package:farmer_consultant/features/gallery/domain/repository/gallery_repository.dart';

class GetGalleryDetails {
  final GalleryRepository repository;

  GetGalleryDetails({required this.repository});

  Future<List<GalleryEntity>> call({required String type}) async {
    return await repository.getGalleryDetails(type: type);
  }
}
