import 'dart:convert';
import 'dart:io';

import 'package:chint_fix/src/models/employee_model.dart';
import 'package:chint_fix/src/providers/db_provider.dart';
import 'package:dio/dio.dart';

class EmployeeApiProvider {
  Future<List<Employee>> getAllEmployees() async {
    // var url = "http://demo8161595.mockable.io/employee";
    // var url = "https://raw.githubusercontent.com/fahmi27071996/sudnaya_chint/master/energy_chint";
    // var url = "https://raw.githubusercontent.com/fahmi27071996/sudnaya_chint/master/energy_chint1.json";
    var url = "http://192.168.2.8:8001/api/chint/hourly";
  //  var url = "http://192.168.2.8:8001/api/chint/5minutes";
    //var url = "https://raw.githubusercontent.com/fahmi27071996/sudnaya_chint/master/chint_hourly"; // github
    var token = '87zPVKPw.h3Up7yBVHenVx184JvHOf5qpOYM7yhyf';

    HttpClient client = new HttpClient();

    HttpClientRequest request = await client.getUrl(Uri.parse(url));

    request.headers.set('content-type', 'application/json');
    request.headers.set('x-api-key', '$token');

    HttpClientResponse response = await request.close();

    var reply = await response.transform(utf8.decoder).join();

    //  Response response = await Dio().get(url);

    var data = json.decode(reply);
    // List listt = data[0]['data'];

    // print("last : "+listt.length.toString());

    //  print(data[0]['chint'].toString());
    //var data = resp

    return (data[0]['data'] as List).map((employee) {
       print('Inserting $employee');
      DBProvider.db.createEmployee(Employee.fromJson(employee));
    }).toList();
  }
}
