import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infoboard/app/data/apis/warning/warning_model.dart';
import 'package:infoboard/app/data/core/AppInfo.dart';
import 'package:infoboard/app/modules/home/new_warning_modal.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(builder: (context, value) {
      return WillPopScope(
        onWillPop: (() async {
          return value!.isLoggingOut;
        }),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () => alertLogout(), icon: Icon(Icons.exit_to_app))
            ],
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            title: Text('Boards'),
          ),
          body: SafeArea(
            child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.deepPurple,
                      Color.fromARGB(255, 14, 1, 17),
                    ])),
                child: _buildBody()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              modalAddWarning();
            },
            child: Icon(Icons.add),
          ),
        ),
      );
    });
  }

  _buildBody() {
    //TODO exibir acima os próximos eventos (ordenar)
    return StreamBuilder<Object>(
        stream: controller.getWarnings(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: controller.warnings.length,
                    itemBuilder: ((context, index) {
                      if (controller.warnings[index].type == 'ABSENT') {
                        return Column(
                          children: [
                            absentCard(controller.warnings[index]),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      } else
                        return Container();
                    }),
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                SizedBox(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'AVISOS',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: controller.warnings.length,
                    itemBuilder: ((context, index) {
                      if (controller.warnings[index].type == 'WARNING') {
                        return Column(
                          children: [
                            absentCard(controller.warnings[index]),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        );
                      } else
                        return Container();
                    }),
                  ),
                )
              ],
            ),
          );
        });
  }

  absentCard(WarningModel warning) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 26),
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(warning.type == 'ABSENT' ? 'Ausencia: ' : 'Aviso: '),
                    Text(warning.owner!,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                if (warning.owner == AppInfo.authUser.name)
                  IconButton(
                      onPressed: () {
                        alertDelete(warning);
                      },
                      icon: Icon(Icons.delete_outline))
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(6)),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  Flexible(child: Text(warning.description!)),
                ],
              )),
          SizedBox(
            height: 4,
          ),
          if (warning.dateType == 'PERIOD')
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('de: '),
                Text(controller.getFormattedDate(warning.fromDate!),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 20),
                Text('até: '),
                Text(controller.getFormattedDate(warning.toDate!),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          if (warning.dateType == 'DATE')
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('dia: '),
                Text(controller.getFormattedDate(warning.fromDate!),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
        ],
      ),
    );
  }

  modalAddWarning() {
    return showModalBottomSheet(
        // isDismissible: false,
        context: context,
        builder: (context) {
          return NewWarningModal();
        });
  }

  alertLogout() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Sair')),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Deseja realmente sair?')]),
            actions: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        controller.logOut();
                      },
                      child: Center(
                        child: Text(
                          'Sair',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        Modular.to.pop();
                      },
                      child: Center(
                        child: Text('Cancelar'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  alertDelete(WarningModel warning) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: Text('Apagar')),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text('Deseja realmente apagar esse aviso?'))
                ]),
            actions: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        Modular.to.pop();
                        controller.deleteWarning(warning);
                      },
                      child: Center(
                        child: Text(
                          'Apagar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          side: BorderSide(
                              color: Theme.of(context).primaryColor)),
                      onPressed: () {
                        Modular.to.pop();
                      },
                      child: Center(
                        child: Text('Cancelar'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
