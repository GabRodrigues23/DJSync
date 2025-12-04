import 'package:flutter_modular/flutter_modular.dart';
import 'package:djsync/modules/login/login_module.dart';
import 'package:djsync/modules/home/home_module.dart';
import 'package:djsync/modules/products/product_module.dart';

class AppModule extends Module {
  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.module('/', module: LoginModule());
    r.module('/home', module: HomeModule());
    r.module('/products', module: ProductModule());
  }
}
