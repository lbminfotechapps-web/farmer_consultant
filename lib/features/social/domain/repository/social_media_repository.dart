

import 'package:farmer_consultant/features/social/domain/entity/social_media.dart';

abstract class SocialMediaRepository {
  Future<List<SocialMedia>> getSocialMedia({
    required String userId,
  });
}