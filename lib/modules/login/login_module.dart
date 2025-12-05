import 'package:flutter_modular/flutter_modular.dart';
import 'package:djsync/modules/login/view/login_page.dart';
import 'package:djsync/modules/login/view/settings_page.dart';

class LoginModule extends Module {
  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.child('/', child: (_) => LoginPage());
    r.child('/settings', child: (_) => SettingsPage());
  }
}
