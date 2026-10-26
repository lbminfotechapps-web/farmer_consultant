import 'dart:io';

import 'package:farmer_consultant/features/dealer/data/model/DealerListModel.dart';



abstract class DealerListRepository {
  Future<List<DealerListModel>> getDealers(
     String farmerId,
    String latitude,
    String longitude,
  );


}
