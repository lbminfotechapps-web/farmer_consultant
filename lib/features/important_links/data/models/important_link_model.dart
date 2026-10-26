import '../../domain/entities/important_link_entity.dart';

class ImportantLinkModel extends ImportantLinkEntity {
  const ImportantLinkModel({
    required super.linkId,
    required super.description,
    required super.link,
  });

  factory ImportantLinkModel.fromJson(Map<String, dynamic> json) {
    return ImportantLinkModel(
      linkId: json['fld_link_id']?.toString() ?? '',
      description: json['fld_description']?.toString() ?? '',
      link: json['fld_link']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fld_link_id': linkId,
      'fld_description': description,
      'fld_link': link,
    };
  }
}
