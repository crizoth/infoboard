import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infoboard/app/data/apis/warning/warning_model.dart';
import 'package:infoboard/app/modules/home/home_controller.dart';

class NewWarningModal extends StatefulWidget {
  const NewWarningModal({Key? key}) : super(key: key);

  @override
  State<NewWarningModal> createState() => _NewWarningModalState();
}

class _NewWarningModalState extends State<NewWarningModal> {
  final controller = Modular.get<HomeController>();

  @override
  void initState() {
    controller.initializeWarningModal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(builder: (context, value) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 6,
                child: ListView(
                  children: [
                    buildForm(),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            side: BorderSide(
                                color: Theme.of(context).primaryColor)),
                        onPressed: () {
                          controller.saveWarning();
                        },
                        child: Container(
                          height: 36,
                          child: Center(
                            child: Text('Enviar'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 0, child: Container())
            ],
          ),
        ),
      );
    });
  }

  buildForm() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Text(controller.newWarning.type == 'ABSENT'
              ? 'Periodo de ausência'
              : 'Aviso'),
          Row(
            children: [
              Switch(
                  value: controller.isAbsentWarning,
                  onChanged: (value) {
                    controller.changeWarningType(value);
                  }),
              Text(
                (controller.newWarning.type == 'ABSENT'
                    ? 'Informar ausência'
                    : 'Enviar aviso'),
              )
            ],
          ),
          Row(
            children: [
              Switch(
                  value: controller.dateTypePeriod,
                  onChanged: (value) {
                    controller.changeWarningDateType(value);
                  }),
              Text('Periodo'),
            ],
          ),
          _buildDateType(controller.dateTypePeriod),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text('Descrição'),
            ),
            onChanged: (value) {
              controller.newWarning.description = value;
            },
          ),
        ],
      ),
    );
  }

  _buildDateType(bool period) {
    if (period) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Text('de: '),
              Container(
                child: InkWell(
                    onTap: () async {
                      DateTime value = await showModalCalendar();
                      controller.newWarning.fromDate = value.toIso8601String();
                      controller.notifyListeners();
                    },
                    child: Text(controller
                        .getFormattedDate(controller.newWarning.fromDate!))),
              ),
            ],
          ),
          Row(
            children: [
              Text('até: '),
              Container(
                child: InkWell(
                    onTap: () async {
                      DateTime value = await showModalCalendar();
                      controller.newWarning.toDate = value.toIso8601String();
                      controller.notifyListeners();
                    },
                    child: Text(controller
                        .getFormattedDate(controller.newWarning.toDate!))),
              ),
            ],
          ),
        ]),
      );
    } else {
      return Container(
        child: Row(children: [
          Text('dia: '),
          Container(
            child: InkWell(
                onTap: () async {
                  DateTime value = await showModalCalendar();
                  controller.newWarning.fromDate = value.toIso8601String();
                  controller.notifyListeners();
                },
                child: Text(controller
                    .getFormattedDate(controller.newWarning.fromDate!))),
          )
        ]),
      );
    }
  }

  showModalCalendar() {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(DateTime.now().year + 1));
  }
}
