import 'package:farmer_consultant/features/dealer/data/datasource/dealer_datasource.dart';
import 'package:farmer_consultant/features/dealer/data/model/DealerListModel.dart';
import 'package:farmer_consultant/features/dealer/domain/repository/dealer_repo.dart';

class DealerListRepositoryImpl implements DealerListRepository {
  final DealerListDataSource dealerListDatasource;

  DealerListRepositoryImpl(this.dealerListDatasource);

  @override
  Future<List<DealerListModel>> getDealers(
    String farmerId,
    String latitude,
    String longitude,
  ) async {
    try {
      print('');
      print('========================================');
      print('DEALER REPOSITORY START');
      print('========================================');

      print('userId: $farmerId');
      print('latitude: $latitude');
      print('longitude: $longitude');

      final response = await dealerListDatasource.fetchDealerList(
        farmerId,
        latitude,
        longitude,
      );

      print('');
      print('========================================');
      print('DEALER REPOSITORY RESPONSE');
      print('========================================');

      print('Dealer count: ${response.length}');
      print('Dealers: $response');

      for (final dealer in response) {
        print(
          'Dealer ID: ${dealer.outletId} | '
          'Name: ${dealer.outletName}',
        );
      }

      return response;
    } catch (e, stackTrace) {
      print('');
      print('========================================');
      print('DEALER REPOSITORY ERROR');
      print('========================================');

      print('ERROR: $e');
      print('STACK: $stackTrace');

      throw Exception('Failed to fetch dealer list: $e');
    }
  }
}
