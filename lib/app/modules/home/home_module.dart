import 'package:flutter_modular/flutter_modular.dart';
import 'package:infoboard/app/modules/home/login_page.dart';
import 'package:infoboard/app/modules/home/splash_page.dart';
import 'home_controller.dart';

import 'home_page.dart';

class HomeModule extends Module {
  static const SPLASH_PAGE = '/';
  static const HOME_PAGE = '/home_page';
  static const LOGIN_PAGE = '/login_page';

  @override
  final List<Bind> binds = [
    Bind((i) => HomeController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SplashPage()),
    ChildRoute('/home_page', child: (_, args) => HomePage()),
    ChildRoute('/login_page', child: (_, args) => LoginPage()),
  ];
}
