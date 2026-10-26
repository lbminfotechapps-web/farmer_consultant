import 'package:equatable/equatable.dart';

class ImportantLinkEntity extends Equatable {
  final String linkId;
  final String description;
  final String link;

  const ImportantLinkEntity({
    required this.linkId,
    required this.description,
    required this.link,
  });

  @override
  List<Object?> get props => [linkId, description, link];
}
