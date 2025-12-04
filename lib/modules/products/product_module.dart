import 'package:flutter_modular/flutter_modular.dart';
import 'package:djsync/modules/products/data/repository/api_product_repository.dart';
import 'package:djsync/modules/products/data/repository/product_repository_interface.dart';
import 'package:djsync/modules/products/viewmodel/products_viewmodel.dart';
import 'package:djsync/modules/products/view/product_page.dart';

class ProductModule extends Module {
  @override
  void binds(Injector i) {
    super.binds(i);

    i.add<ProductRepositoryInterface>(ApiProductRepository.new);
    i.addSingleton(ProductsViewmodel.new);
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.child('/', child: (_) => ProductPage());
  }
}
