import 'package:farmer_consultant/features/crop_schedule/domain/entity/plot_response_entity.dart';

class PlotResponseModel extends PlotResponseEntity {
  const PlotResponseModel({
    required super.status,
    required super.message,
    required List<PlotModel> result,
  }) : super(result: result);

  factory PlotResponseModel.fromJson(Map<String, dynamic> json) {
    final resultData = json['result'];

    return PlotResponseModel(
      status:
          json['status'] == true ||
          json['status']?.toString().toLowerCase() == 'true',
      message: json['message']?.toString() ?? '',
      result: resultData is List
          ? resultData
                .whereType<Map>()
                .map(
                  (item) => PlotModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': result.map((plot) {
        return PlotModel(
          plotRegistrationId: plot.plotRegistrationId,
          plotName: plot.plotName,
          sowingDate: plot.sowingDate,
          cropId: plot.cropId,
          cropName: plot.cropName,
          farmerId: plot.farmerId,
          farmerName: plot.farmerName,
          createdDate: plot.createdDate,
          acres: plot.acres,
        ).toJson();
      }).toList(),
    };
  }
}

class PlotModel extends PlotEntity {
  const PlotModel({
    required super.plotRegistrationId,
    required super.plotName,
    required super.sowingDate,
    required super.cropId,
    required super.cropName,
    required super.farmerId,
    required super.farmerName,
    required super.createdDate,
    required super.acres,
  });

  factory PlotModel.fromJson(Map<String, dynamic> json) {
    return PlotModel(
      plotRegistrationId: json['fld_plot_registration_id']?.toString() ?? '',
      plotName: json['fld_plot_name']?.toString() ?? '',
      sowingDate: json['fld_sowing_date']?.toString() ?? '',
      cropId: json['fld_crop_id']?.toString() ?? '',
      cropName: json['fld_crop_name']?.toString() ?? '',
      farmerId: json['fld_farmer_id']?.toString() ?? '',
      farmerName: json['fld_farmer_name']?.toString() ?? '',
      createdDate: json['fld_created_date']?.toString() ?? '',
      acres: json['fld_acre']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fld_plot_registration_id': plotRegistrationId,
      'fld_plot_name': plotName,
      'fld_sowing_date': sowingDate,
      'fld_crop_id': cropId,
      'fld_crop_name': cropName,
      'fld_farmer_id': farmerId,
      'fld_farmer_name': farmerName,
      'fld_created_date': createdDate,
      'fld_acre': acres,
    };
  }
}
