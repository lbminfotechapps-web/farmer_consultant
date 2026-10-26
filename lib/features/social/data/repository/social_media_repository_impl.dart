

import 'package:farmer_consultant/features/social/data/datasource/social_media_remote_datasource.dart';
import 'package:farmer_consultant/features/social/domain/entity/social_media.dart';
import 'package:farmer_consultant/features/social/domain/repository/social_media_repository.dart';

class SocialMediaRepositoryImpl
    implements SocialMediaRepository {
  final SocialMediaRemoteDataSource remoteDataSource;

  SocialMediaRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<SocialMedia>> getSocialMedia({
    required String userId,
  }) async {
    return await remoteDataSource.getSocialMedia(
      userId: userId,
    );
  }
}