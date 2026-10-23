
import 'package:equatable/equatable.dart';



class PlotResponseEntity extends Equatable {
  final bool status;
  final String message;
  final List<PlotEntity> result;

  const PlotResponseEntity({
    required this.status,
    required this.message,
    required this.result,
  });

  @override
  List<Object?> get props => [
        status,
        message,
        result,
      ];
}

class PlotEntity extends Equatable {
  final String plotRegistrationId;
  final String plotName;
  final String sowingDate;
  final String cropId;
  final String cropName;
  final String farmerId;
  final String farmerName;
  final String createdDate;

  const PlotEntity({
    required this.plotRegistrationId,
    required this.plotName,
    required this.sowingDate,
    required this.cropId,
    required this.cropName,
    required this.farmerId,
    required this.farmerName,
    required this.createdDate,
  });

  @override
  List<Object?> get props => [
        plotRegistrationId,
        plotName,
        sowingDate,
        cropId,
        cropName,
        farmerId,
        farmerName,
        createdDate,
      ];
}



