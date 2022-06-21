import 'dart:convert';

class WarningModel {
  String? createdAt;
  String? id;
  String? fromDate;
  String? toDate;
  String? owner;
  String? description;
  String? type;
  String? dateType;
  WarningModel({
    this.createdAt,
    this.id,
    this.fromDate,
    this.toDate,
    this.owner,
    this.description,
    this.type,
    this.dateType,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'id': id,
      'fromDate': fromDate,
      'toDate': toDate,
      'owner': owner,
      'description': description,
      'type': type,
      'dateType': dateType,
    };
  }

  factory WarningModel.fromMap(String id, Map<String, dynamic> map) {
    return WarningModel(
      createdAt: map['createdAt'],
      id: id,
      fromDate: map['fromDate'],
      toDate: map['toDate'],
      owner: map['owner'],
      description: map['description'],
      type: map['type'],
      dateType: map['dateType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WarningModel.fromJson(String idX, String source) =>
      WarningModel.fromMap(idX, json.decode(source));

  @override
  String toString() {
    return 'WarningModel(createdAt: $createdAt, id: $id, fromDate: $fromDate, toDate: $toDate, owner: $owner, description: $description, type: $type, dateType: $dateType)';
  }
}
