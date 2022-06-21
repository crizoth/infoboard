import 'package:builders/builders.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infoboard/app/data/core/AppInfo.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppInfo.firebaseApp = await Firebase.initializeApp();
  AppInfo.initialize();

  Builders.systemInjector(Modular.get);
  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
