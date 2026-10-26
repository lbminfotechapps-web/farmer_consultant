

import 'package:farmer_consultant/features/social/domain/entity/social_media.dart';
import 'package:farmer_consultant/features/social/domain/repository/social_media_repository.dart';

class GetSocialMedia {
  final SocialMediaRepository repository;

  GetSocialMedia({
    required this.repository,
  });

  Future<List<SocialMedia>> call({
    required String userId,
  }) async {
    return await repository.getSocialMedia(
      userId: userId,
    );
  }
}