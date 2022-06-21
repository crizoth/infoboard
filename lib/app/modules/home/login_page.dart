import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infoboard/app/modules/home/home_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = Modular.get<HomeController>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(26),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Center(
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      infoBoardLogo(),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  buildForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildForm() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              label: Text('Time'),
            ),
            onChanged: (value) {
              controller.newUser.team = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text('Nome'),
            ),
            onChanged: (value) {
              controller.newUser.name = value;
            },
          ),
          SizedBox(
            height: 16,
          ),
          TextButton(
              style: TextButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).primaryColor)),
              onPressed: () {
                controller.saveNewUser();
              },
              child: Container(
                  width: 110, height: 40, child: Center(child: Text('Entrar'))))
        ],
      ),
    );
  }

  infoBoardLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Info',
          style: TextStyle(color: Colors.white, fontSize: 26),
        ),
        Text(
          'Board',
          style: TextStyle(
              color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
