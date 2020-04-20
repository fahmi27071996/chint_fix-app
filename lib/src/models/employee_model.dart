import 'dart:convert';

import 'dart:ffi';

List<Employee> employeeFromJson(String str) =>
    List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  String time_stamp;
  String energy_total;
  String energy_a;
  String energy_b;
  String energy_c;

  List waktu;

  Employee({
    this.time_stamp,
    this.energy_total,
    this.energy_a,
    this.energy_b,
    this.energy_c,
    this.waktu,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        // waktu:json["time_stamp"].toString().split('.'),

        // untuk menit //

        //  time_stamp: json["time_stamp"].toString().split('.')[0].toString(),

        // untuk menit //

        // untuk jam //

        time_stamp: json["time_stamp"].toString(),

        // untuk jam //

        //
        //
        energy_total: json["energy_total"].toString(),
        energy_a: json["energy_a"].toString(),
        energy_b: json["energy_b"].toString(),
        energy_c: json["energy_c"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "time_stamp": time_stamp,
        "energy_total": energy_total,
        "energy_a": energy_a,
        "energy_b": energy_b,
        "energy_c": energy_c,
      };
}
