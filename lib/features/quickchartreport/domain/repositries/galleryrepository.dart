import 'package:farmer_consultant/features/quickchartreport/domain/enitities/galleryfileentity.dart';

abstract class GalleryRepository {
  Future<List<GalleryEntity>> getGallery();
}
