import 'dart:convert';

class UserModel {
  String? id;
  String? name;
  String? team;
  String? teamId;
  UserModel({
    this.id,
    this.name,
    this.team,
    this.teamId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'team': team,
      'teamId': teamId,
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson({String? idX, required String source}) =>
      UserModel.fromMap(id: idX, map: json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, team: $team, teamId: $teamId)';
  }

  factory UserModel.fromMap({String? id, required Map<String, dynamic> map}) {
    return UserModel(
      id: id ?? map['id'],
      name: map['name'],
      team: map['team'],
      teamId: map['teamId'],
    );
  }
}
