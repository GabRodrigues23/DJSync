import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void routes(RouteManager r) {
    super.routes(r);

    // r.module('/', module: LoginModule());
    // r.module('/', module: HomeModule());
    // r.module('/products', module: ProductsModule());
    // r.module('/clients', module: ClientsModule());
  }
}
