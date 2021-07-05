import 'dart:convert';

class Employee {
  Employee({
    this.id,
    this.noInduk,
    this.name,
    this.address,
    this.birthDate,
    this.joinDate,
  });

  String id;
  String noInduk;
  String name;
  String address;
  String birthDate;
  String joinDate;

  Map<String, dynamic> toJson() => {
    "id": id,
    "no_induk": noInduk,
    "name": name,
    "address": address,
    "birth_date": birthDate,
    "join_date": joinDate,
  };

  factory Employee.fromJson(Map<dynamic, dynamic> json) => Employee(
    id: json["id"].toString(),
    noInduk: json["no_induk"],
    name: json["name"],
    address: json["address"],
    birthDate: json["birth_date"],
    joinDate: json["join_date"],
  );

  List<Employee> parseEmployee(String json) {
    if (json == null) {
      return [];
    }

    final List parsed = jsonDecode(json);
    return parsed.map((json) => Employee.fromJson(json)).toList();
  }
}