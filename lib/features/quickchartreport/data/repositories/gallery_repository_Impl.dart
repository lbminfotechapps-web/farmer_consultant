import 'package:farmer_consultant/features/quickchartreport/data/datasource/galleryremotedatasource.dart';
import 'package:farmer_consultant/features/quickchartreport/domain/enitities/galleryfileentity.dart';
import 'package:farmer_consultant/features/quickchartreport/domain/repositries/galleryrepository.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  final GalleryRemoteDataSource remoteDataSource;

  GalleryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<GalleryEntity>> getGallery() async {
    final response = await remoteDataSource.getGallery();

    if (response.status) {
      return response.result;
    }

    throw Exception(response.message);
  }
}
