import 'package:intl/intl.dart';

String tampilTanggal() {
  DateTime now = DateTime.now();
  String formattedDate =
      DateFormat('yyyyMMddTkkmmss').format(now).toString();
  return formattedDate;
}

String newDate()
{
  var today = new DateTime.now();
  DateTime tempDate = DateTime.parse("20200414T160000");
  var fiftyDaysFromNow = tempDate.add(new Duration(hours: 1));
  var format = DateFormat('yyyyMMddTkkmmss').format(fiftyDaysFromNow).toString();
  return format.toString();
}

String endDate()
{
  var today = new DateTime.now();
  DateTime tempDate = DateTime.parse("20200414T160000");
  var fiftyDaysFromNow = tempDate.add(new Duration(hours: 1));
  var format = DateFormat('yyyyMMddTkkmmss').format(fiftyDaysFromNow).toString();
  return format.toString();
}

void updateDate (var time){
  

}
