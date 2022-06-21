import 'package:flutter_modular/flutter_modular.dart';
import 'package:infoboard/app/data/core/LocalStorageService.dart';

import 'modules/home/home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => LocalStorageService()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];
}
