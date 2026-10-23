
import 'package:farmer_consultant/features/products/domain/entity/fertilizer_category_entity.dart';
import 'package:farmer_consultant/features/products/domain/entity/product_name.dart';

abstract class ProductRepository {
  Future<List<FertilizerCategoryEntity>> getProductList(String searchText);

   Future<ProductResponseEntity> getProductNameList(String searchText);
}
