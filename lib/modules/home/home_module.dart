import 'package:flutter_modular/flutter_modular.dart';
import 'package:djsync/modules/home/view/home_page.dart';

class HomeModule extends Module {
  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.child('/', child: (_) => HomePage());
  }
}
