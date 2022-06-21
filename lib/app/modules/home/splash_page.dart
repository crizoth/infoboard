import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infoboard/app/data/core/AppInfo.dart';
import 'package:infoboard/app/data/core/LocalStorageService.dart';
import 'package:infoboard/app/modules/home/home_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _controller = Modular.get<HomeController>();

  @override
  void initState() {
    _controller.initApp();
    // LocalStorageService().deleteAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(builder: (context, value) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            body: _controller.loading ? _buildLoadScreen() : _buildScreen()),
      );
    });
  }

  _buildScreen() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Info',
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            Text(
              'Board',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            )
          ],
        )));
  }

  _buildLoadScreen() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Info',
                  style: TextStyle(color: Colors.white, fontSize: 26),
                ),
                Text(
                  'Board',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ],
        )));
  }
}
