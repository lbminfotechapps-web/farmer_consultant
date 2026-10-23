

import 'package:farmer_consultant/features/products/data/product_datasource/product_datasource.dart';
import 'package:farmer_consultant/features/products/domain/entity/fertilizer_category_entity.dart';
import 'package:farmer_consultant/features/products/domain/entity/product_name.dart';
import 'package:farmer_consultant/features/products/domain/repository/product_repository.dart';

class ProductRepoImp implements ProductRepository {
  final ProductDatasource productDatasource;

  ProductRepoImp(this.productDatasource);

  @override
  Future<List<FertilizerCategoryEntity>> getProductList(
    String searchText,
  ) async {
    try {
      final result = await productDatasource.getProductList(searchText);

      return result;
    } catch (e) {
      rethrow;
    }
  }

@override
Future<ProductResponseEntity> getProductNameList(
  String searchText,
) async {
  try {
    return await productDatasource.getProductNameList(
      searchText,
    );
  } catch (e) {
    rethrow;
  }
}


  
}
