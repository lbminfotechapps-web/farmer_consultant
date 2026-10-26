import 'package:equatable/equatable.dart';
import 'package:farmer_consultant/features/social/domain/entity/social_media.dart';


enum SocialMediaStatus {
  initial,
  loading,
  success,
  failure,
}

class SocialMediaState extends Equatable {
  final SocialMediaStatus status;
  final List<SocialMedia> socialMedia;
  final String? errorMessage;

  const SocialMediaState({
    this.status = SocialMediaStatus.initial,
    this.socialMedia = const [],
    this.errorMessage,
  });

  SocialMediaState copyWith({
    SocialMediaStatus? status,
    List<SocialMedia>? socialMedia,
    String? errorMessage,
  }) {
    return SocialMediaState(
      status: status ?? this.status,
      socialMedia: socialMedia ?? this.socialMedia,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        socialMedia,
        errorMessage,
      ];
}