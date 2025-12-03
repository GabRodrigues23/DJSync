import 'package:djsync/modules/products/data/model/product.dart';

abstract class ProductRepositoryInterface {
  Future<List<Product>> importProducts();
  Future<void> saveProduct(List<Product> products);
}
