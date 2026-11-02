import 'package:equatable/equatable.dart';

class SuccessStoryEntity extends Equatable {
  final bool status;
  final List<SuccessStoryItemEntity> result;
  final String message;

  const SuccessStoryEntity({
    required this.status,
    required this.result,
    required this.message,
  });

  @override
  List<Object?> get props => [status, result, message];
}

class SuccessStoryItemEntity extends Equatable {
  final String farmerId;
  final String farmerName;
  final String mobileNo;
  final String alternateMobileNo;
  final String address;
  final String cropIds;
  final String cropAcreage;
  final String usedProduct;
  final String cropStage;
  final String employeeNameHq;
  final String successVideo;
  final String createdDate;
  final String videoUrl; 
    final String cropNames; 

  const SuccessStoryItemEntity({
    required this.farmerId,
    required this.farmerName,
    required this.mobileNo,
    required this.alternateMobileNo,
    required this.address,
    required this.cropIds,
    required this.cropAcreage,
    required this.usedProduct,
    required this.cropStage,
    required this.employeeNameHq,
    required this.successVideo,
    required this.createdDate,
    required this.videoUrl, 
    required this.cropNames,
  });

  // Returns crop IDs as a list.
  // Example: "149,146" -> ["149", "146"]
  List<String> get cropIdList => cropIds
      .split(',')
      .map((id) => id.trim())
      .where((id) => id.isNotEmpty)
      .toList();

  // Check whether a video is available.
  bool get hasVideo => successVideo.trim().isNotEmpty;

  // Safe acreage conversion.
  double get acreageValue => double.tryParse(cropAcreage) ?? 0.0;

  @override
  List<Object?> get props => [
    farmerId,
    farmerName,
    mobileNo,
    alternateMobileNo,
    address,
    cropIds,
    cropAcreage,
    usedProduct,
    cropStage,
    employeeNameHq,
    successVideo,
    createdDate,
    videoUrl,
    cropNames,
  ];
}
