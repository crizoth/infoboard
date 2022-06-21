import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:infoboard/app/data/apis/users/user_model.dart';
import 'package:infoboard/app/data/apis/users/user_service.dart';
import 'package:infoboard/app/data/apis/warning/warning_model.dart';
import 'package:infoboard/app/data/apis/warning/warning_service.dart';
import 'package:infoboard/app/data/core/AppInfo.dart';
import 'package:infoboard/app/data/core/LocalStorageService.dart';
import 'package:infoboard/app/modules/home/home_module.dart';

class HomeController extends ChangeNotifier {
  //control variables
  bool loading = false;
  bool hasError = false;
  String? errorMsg;
  bool isLoggingOut = false;
  bool dateTypePeriod = false;
  bool isAbsentWarning = true;

  //streams
  final _warningService = WarningService();
  Stream<QuerySnapshot<Map<String, dynamic>>>? _warningsStream;
  List<WarningModel> warnings = [];
  List<WarningModel> tempWarnings = [];
  List<WarningModel> warningsToDelete = [];
  WarningModel newWarning = WarningModel();

  //storage
  final _storage = Modular.get<LocalStorageService>();
  //Users
  UserModel newUser = UserModel();
  final _userService = UserService();

  toggleLoading([bool? value]) {
    loading = value ?? !loading;
    notifyListeners();
  }

  initializeWarningModal() {
    newWarning = WarningModel(
        fromDate: DateTime.now().toIso8601String(),
        toDate: DateTime.now().toIso8601String(),
        type: 'ABSENT',
        description: '',
        dateType: 'DATE');
    dateTypePeriod = false;
    isAbsentWarning = true;
  }

  changeWarningType(bool value) {
    isAbsentWarning = value;
    if (value) {
      newWarning.type = 'ABSENT';
    } else {
      newWarning.type = 'WARNING';
    }
    notifyListeners();
  }

  changeWarningDateType(bool value) {
    dateTypePeriod = value;
    if (value) {
      newWarning.dateType = 'PERIOD';
    } else {
      newWarning.dateType = 'DATE';
    }
    notifyListeners();
  }

  toggleHasError([bool? value]) {
    hasError = value ?? !hasError;
  }

  logOut() async {
    toggleLoading(true);
    isLoggingOut = true;
    notifyListeners();
    await LocalStorageService().save(key: 'user', value: UserModel().toJson());
    AppInfo.authUser = UserModel();
    Modular.to.pushNamed(HomeModule.SPLASH_PAGE);
    await Future.delayed(Duration(seconds: 2));
    isLoggingOut = false;
    toggleLoading(false);
  }

  setUserName(String value) {
    newUser.name = value.toLowerCase();
  }

  setUserTeam(String value) {
    newUser.team = value.toLowerCase();
  }

  saveNewUser() async {
    toggleLoading(true);

    //alterar o id do time e do user enviados nos warnings
    if (newUser.name != null && newUser.team != null) {
      // pesquisar se o time existe, atribuir Id do time para o user caso o time ja exista
      var teamSearch = await verifyTeam(newUser.team!);
      print(teamSearch);
      if (teamSearch == '') {
        toggleHasError(true); //TODO show error message
        errorMsg = 'Time não inexistente';
        return;
      }
      if (teamSearch != '') {
        var userSearch =
            await verifyUser(newUser.name!); //buscar se user ja existe
        if (userSearch.id != null) {
          userSearch.teamId = teamSearch; // salvar o id do time no user
          // _userService.updateUser(userSearch);
          await _storage.save(key: 'user', value: userSearch.toJson());
          await AppInfo.initialize();
          Modular.to.popAndPushNamed(HomeModule.SPLASH_PAGE);
        } else {
          newUser.teamId = teamSearch;
          await _userService.saveUser(newUser);
          await _storage.save(key: 'user', value: newUser.toJson());
          AppInfo.initialize();
          Modular.to.pushNamed(HomeModule.HOME_PAGE);
          //stream salvar usuário no Firebase
        }
      }
    }
    toggleLoading(false);
  }

  //init splashPage
  initApp() async {
    toggleLoading(true);
    var userRef;
    try {
      userRef = await LocalStorageService().read('user');
    } catch (e) {}
    if (userRef != null) {
      AppInfo.authUser = UserModel.fromJson(source: userRef);
    } else {
      await LocalStorageService()
          .save(key: 'user', value: UserModel().toJson());
    }
    if (AppInfo.authUser.name != null) {
      var loggedUser = await verifyUser(AppInfo.authUser.name!);
      if (loggedUser.name != null) {
        Modular.to.pushNamed(HomeModule.HOME_PAGE);
      }
    } else {
      toggleLoading(false);
      Modular.to.pushNamed(HomeModule.LOGIN_PAGE);
    }
  }

  //WARNINGS
  //front end functions
  getFormattedDate(String date) {
    var onlyDate = date.split('T')[0].split('-');
    return '${onlyDate[2]}/${onlyDate[1]}/${onlyDate[0]}';
  }

  //firebase functions
  void saveWarning() async {
    Modular.to.pop();
    newWarning.createdAt = DateTime.now().toIso8601String();
    newWarning.owner = AppInfo.authUser.name;

    await _warningService.saveWarning(
        warning: newWarning, teamId: AppInfo.authUser.teamId);
  }

  Stream<List<WarningModel>> getWarnings() {
    _warningsStream =
        _warningService.getWarnings(teamId: AppInfo.authUser.teamId);
    Stream<List<WarningModel>> data = _warningsStream!.map((snapshot) {
      warnings = [];
      warningsToDelete = [];
      return snapshot.docs.map((doc) {
        var warning = WarningModel.fromMap(doc.id, doc.data());
        var warningDate = DateTime.parse(
            warning.dateType == 'DATE' ? warning.fromDate! : warning.toDate!);
        if (warningDate.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
          warnings.add(warning);
        } else {
          deleteWarning(warning);
          // warningsToDelete.add(warning);
        }
        return WarningModel.fromMap(doc.id, doc.data());
      }).toList();
    });
    return data;
  }

  deleteWarning(WarningModel item) async {
    await _warningService.deleteWarnings(AppInfo.authUser.teamId!, item.id!);
  }

  //USER STREAMS
  Future<UserModel> verifyUser(String userName) async {
    List<UserModel> users = [];
    await _userService.searchUser(userName).then((usersDocs) {
      if (usersDocs.docs.length > 0) {
        users = usersDocs.docs.map((documentSnapshot) {
          return UserModel.fromMap(
              id: documentSnapshot.id, map: documentSnapshot.data());
        }).toList();
      }
    });
    try {
      if (users.isNotEmpty) {
        var user = users[0];
        return user;
      } else
        return UserModel();
    } catch (e) {
      rethrow;
    }
  }

  //TEAMS STREAMS

  Future<String> verifyTeam(String teamName) async {
    List<String> teamId = [];
    await _userService.searchTeam(teamName).then((teamDocs) {
      if (teamDocs.docs.length > 0) {
        teamId = teamDocs.docs.map((documentSnapshot) {
          return documentSnapshot.id;
        }).toList();
      }
    });
    try {
      if (teamId.isNotEmpty) {
        return teamId[0];
      } else {
        return '';
      }
    } catch (e) {
      rethrow;
    }
  }
}
