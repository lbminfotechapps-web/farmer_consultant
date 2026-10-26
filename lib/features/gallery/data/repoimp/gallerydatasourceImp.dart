import 'package:dio/dio.dart';
import 'package:farmer_consultant/features/gallery/data/datasource/gallery_datasource.dart';
import 'package:farmer_consultant/features/gallery/domain/entities/gallery_entity.dart';
import 'package:farmer_consultant/features/gallery/domain/repository/gallery_repository.dart';

class GalleryDatasourceImpl implements GalleryRepository {
  final GalleryDatasource galleryDatasource;

  GalleryDatasourceImpl(this.galleryDatasource);
  @override
  Future<List<GalleryEntity>> getGalleryDetails({required String type}) {
    return galleryDatasource.getGalleryData(type: type);
  }
}
