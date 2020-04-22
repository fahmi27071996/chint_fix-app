import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:chint_fix/src/providers/db_provider.dart';
import 'package:chint_fix/src/providers/employee_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:chint_fix/src/pages/getDate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:zoom_widget/zoom_widget.dart';

String DataStop = "20200414T160000";
String DataStop1 = ""; //20200414T160000
var GeserStatus = false;
var DateLimit = false;

String dataQuery = "";
//  'SELECT * FROM EMPLOYEE WHERE time_stamp BETWEEN "20200414T164647" AND "20200414T180459"';

String mulai;
String akhir;

String Qmulai, Qakhir;

int counter = 1;

List<String> titles = [
  'Phasa A',
  'Phasa B',
  'Phasa C',
];

int data_tinggi = 60;
int data_lebar = 200;

var red = "#db0202";
var data2 = new List();
var panjang = 31;

// ==================== scALE========================//

var StartScale, EndScale, ChangeScale;
var StatusStartScale = false;

// ==================== scALE========================//

int AddManual = 0;
int AddManualLeft = 0;

var tahan = false;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

void ShowToast() {
  Fluttertoast.showToast(
      msg: "Minimum Data ..!!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

_onDragUpdate(BuildContext context, DragUpdateDetails update) {
  // print("update : " + update.globalPosition.toString());
  RenderBox getBox = context.findRenderObject();
  var local = getBox.globalToLocal(update.globalPosition);
  print("update : " +
      local.dx.toInt().toString() +
      "|" +
      local.dy.toInt().toString());
}

_onDragStart(BuildContext context, DragStartDetails start) {
  //tambah();

  //print(tampilTanggal());

  print(newDate());

  print("start :  " + start.globalPosition.toString());
  RenderBox getBox = context.findRenderObject();
  var local = getBox.globalToLocal(start.globalPosition);
  // print(local.dx.toString() + "|" + local.dy.toString());
}

_onDragEnd(BuildContext context, DragEndDetails end) {
  print(end.toString());
  RenderBox getBox = context.findRenderObject();
// var local = getBox.globalToLocal(end.globalPosition);
  // print(local.dx.toString() + "|" + local.dy.toString());
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  int a = 0;
  int GestureLeft, GestureRight, ValueData, ValueStart;

  void tambah() {
    counter++;
  }


  void baca(){
    Future.delayed(const Duration(seconds: 2), () {
    AddManual++;
    changeQuery1("data1", "data2");});
  }

  void tunda() async {
    const oneSec = const Duration(seconds: 5);
    new Timer.periodic(oneSec, (Timer t) {

      
      

      if (!tahan) {
        tahan = false;
        AddManual = AddManual + 1;
        print("manual : " + AddManual.toString());
      }

      setState(() {
        changeQuery1("data1", "data2");        
        //tahan = true;
      });
    });
  }

// Timer _timer;
// int _start = 0;

// void startTimer() {
//   const oneSec = const Duration(seconds: 1);
//   _timer = new Timer.periodic(
//     oneSec,
//     (Timer timer) => setState(
//       () {
//         if (_start > 40) {
//           timer.cancel();
//         } else {
//           _start = _start + 1;
//           AddManual = _start;
//         }
//       },
//     ),
//   );
// }

  @override
  Widget build(BuildContext context) {
    // tunda();
    baca();
    return Scaffold(
      appBar: AppBar(
        // title: Text('Get Json'),
        centerTitle: true,
        actions: <Widget>[
          // Container(
          //   padding: EdgeInsets.only(right: 10.0),
          //   child: IconButton(
          //     icon: Icon(Icons.settings_input_antenna),
          //     onPressed: () async {
          //       await _loadFromApi();
          //     },
          //   ),
          // ),
          Center(
            //padding: EdgeInsets.all( 15.0),
            child: FlatButton(
              child: Text(
                "Update Data",
                textScaleFactor: 1.0,
                style: TextStyle(fontSize: 10.0, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.white)),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),

          Padding(padding: EdgeInsets.all(6)),

          // Center(
          //   //padding: EdgeInsets.all( 15.0),
          //   child: FlatButton(
          //     child: Text(
          //       "Delete DB Data",
          //       textScaleFactor: 1.0,
          //       style: TextStyle(fontSize: 10.0, color: Colors.white),
          //     ),
          //     shape: RoundedRectangleBorder(
          //         borderRadius: new BorderRadius.circular(10.0),
          //         side: BorderSide(color: Colors.white)),
          //     onPressed: () //{
          //         //  DataStop = "20200414T160000";
          //         // }
          //         async {
          //       await getCustomers1(); //_deleteData();
          //     },
          //   ),
          // ),

          Center(
              child: new IconButton(
            icon: new Icon(Icons.add_box),
            onPressed: () {
              setState(() {
                // AddManual=0;
                AddManualLeft++;

                changeQuery1("data1", "data2");
              });
            },
          )),

          Center(
              child: new IconButton(
            icon: new Icon(Icons.indeterminate_check_box),
            onPressed: () {
              setState(() {
                //  AddManual=0;
                AddManualLeft--;
                changeQuery1("data1", "data2");
              });
            },
          )),

          Center(
              child: new IconButton(
            icon: new Icon(Icons.indeterminate_check_box),
            onPressed: () {
              setState(() {
                // AddManualLeft = 0;
                AddManual--;
                changeQuery1("data1", "data2");
                // AddManual = 0;
              });
            },
          )),

          Center(
              child: new IconButton(
            icon: new Icon(Icons.add_box),
            onPressed: () {
              setState(() {
                //AddManualLeft = 0;
                AddManual++;
                changeQuery1("data1", "data2");
                // AddManual = 0;
              });
            },
          )),

          // Container(
          //   padding: EdgeInsets.only(right: 10.0),
          //   child: IconButton(
          //     icon: Icon(Icons.minimize),
          //     onPressed: () {
          //       DateTimeRangePicker(
          //           startText: "From",
          //           endText: "To",
          //           doneText: "Yes",
          //           cancelText: "Cancel",
          //           interval: 5,
          //           initialStartTime: DateTime.now(),
          //           initialEndTime: DateTime.now().add(Duration(days: 20)),
          //           mode: DateTimeRangePickerMode.dateAndTime,
          //           minimumTime: DateTime.now().subtract(Duration(days: 5)),
          //           maximumTime: DateTime.now().add(Duration(days: 25)),
          //           onConfirm: (start, end) {
          //             mulai =
          //                 start.toString().split('.')[0].replaceAll('-', '');
          //             mulai = mulai.replaceAll(' ', 'T');
          //             mulai = mulai.replaceAll(':', '');
          //             akhir = end.toString().split('.')[0].replaceAll('-', '');
          //             akhir = akhir.replaceAll(' ', 'T');
          //             akhir = akhir.replaceAll(':', '');
          //             print(mulai);
          //             print(akhir);
          //             changeQuery1(mulai, akhir);
          //             a = 0;

          //             // mulai = start.toString();//.toString().split('.')[0];
          //             // akhir = end.toString();//.toString().split('.')[0];
          //           }).showPicker(context);
          //     },
          //   ),
          // ),
          // Container(
          //   padding: EdgeInsets.only(right: 10.0),
          //   child: IconButton(
          //     icon: Icon(Icons.delete),
          //     onPressed: () async {
          //       await _deleteData();
          //     },
          //   ),
          // ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Expanded(
                    child: Center(
                  child: _buildEmployeeListView(),
                )),
                Center(
                  child: Text(
                    "Start : " +
                        Qmulai.toString() +
                        "\nEnd   : " +
                        Qakhir.toString(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Colors.red, fontSize: 18.0),
                  ),
                ),
                Center(
                    child: GestureDetector(
                  onHorizontalDragStart: (details) {
                    // a++;
                    ValueStart = details.globalPosition.dx.toInt();
                    //  changeQuery1("data1", "data2");
                    // print(details.globalPosition.dx.toInt().toString());
                    // changeQuery1("data1", "data2");
                  },

                  onHorizontalDragUpdate: (details) {
                    ValueData = details.globalPosition.dx.toInt();

                    // print("drag update  : "+details.globalPosition.dx.toInt().toString());
                    int DragData =
                        details.globalPosition.dx.toInt() - ValueStart;
                    DragData =
                        (36 * DragData / MediaQuery.of(context).size.width)
                            .toInt();

                    print("DragData : " + DragData.toString());
                    //  sleep(const Duration(milliseconds: 100));

                    if (ValueStart < ValueData) {
                      //  print("ke kanan");

                      a = DragData;

                      if (a >= 0) {
                        a = DragData;
                      } else {
                        // ShowToast();
                        a = 0;
                      }
                    } else {
                      // print("ke kiri");
                      a = DragData;
                    }

                    // if(a > 16){a = 16;}
                    // if(a <-16){a =-16;}

                    print("daata A : " + DragData.toString());
                    //var data = DateLimit;

                    changeQuery1("data1", "data2");
                  },

                  // onPanUpdate: (details) {
                  //   print("pan kemana : " + details.toString());
                  // },
                  // onPanEnd: (details) {
                  //   //  print("mandek kemana : " + details.toString());
                  // },

                  onHorizontalDragEnd: (details) {
                    DataStop = DataStop1;

                    print("stop");

                    setState(() {
                      AddManual = 0;
                    });
                  },

                  //normal code

                  onScaleStart: (ScaleStartDetails details) {
                    print("startScale : " + details.toString());
                    // StartScale = details;
                  },

                  onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
                    if (!StatusStartScale) {
                      StartScale = scaleDetails.scale;
                      StatusStartScale = true;
                    }

                    var ValueScale = scaleDetails.scale;
                    // var ChangeScaleValue;

                    // if (ValueScale < 1) {
                    //   ChangeScaleValue  = (1- ValueScale)*20;
                    //  // print("zoom out");
                    // } else if (ValueScale > 1) {
                    //   ChangeScaleValue  = ValueScale-ValueStart;
                    //  // print("zoom in");
                    // }

                    // ChangeScaleValue  = ValueScale-ValueStart;
                    print("New Scale" + ValueScale.toString());

                    // print( "scale :" + scaleDetails.focalPoint.toString() + "  " + details.localFocalPoint.toString());
                    //  double get distance => math.sqrt(dx * dx + dy * dy);
                    // print("details : " +
                    //     (scaleDetails.scale.toString()));
                  },

                  onScaleEnd: (ScaleEndDetails scaleDetails) {
                    // print( "scale :" + scaleDetails.focalPoint.toString() + "  " + details.localFocalPoint.toString());
                    //  double get distance => math.sqrt(dx * dx + dy * dy);
                    print("End Scale : " + scaleDetails.toString());
                    StartScale = 0;
                    StatusStartScale = false;
                  },

                  //(DragStartDetails start) =>
                  //     _onDragStart(context, start),
                  // onHorizontalDragUpdate: (DragUpdateDetails update) =>
                  //     _onDragUpdate(context, update),
                  // onHorizontalDragEnd: (DragEndDetails end)
                  // onHorizontalDragEnd: (details) {
                  //  a=0;
                  // },
                  child: Center(
                    child: new Container(
                      child: Center(
                        child: Text(
                          "Touchpad",
                          textScaleFactor: 1.0,
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                      height: 100,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  ),
                )),
              ],
            ),

      //       bottomNavigationBar: BottomNavigationBar(
      //    currentIndex: 0, // this will be set when a new tab is tapped
      //    items: [
      //      BottomNavigationBarItem(
      //        icon: new Icon(Icons.home),
      //        title: new Text('Home'),
      //      ),
      //      BottomNavigationBarItem(
      //        icon: new Icon(Icons.mail),
      //        title: new Text('Messages'),
      //      ),
      //      BottomNavigationBarItem(
      //        icon: Icon(Icons.person),
      //        title: Text('Profile')
      //      )
      //    ],
      //  ),
    );
  }

  changeQuery() {
    setState(() {
      // sleep(const Duration(milliseconds: 10));
      dataQuery =
          'SELECT * FROM EMPLOYEE WHERE time_stamp BETWEEN "20200414T155754" AND "20200414T171455"';
    });
  }

  changeQuery1(String data1, String data2) {
    //var today = new DateTime.now();
//20200414T160000
    DateTime tempDate;
    // if(!DateLimit){
    tempDate = DateTime.parse(DataStop.split('+')[0].toString()); //}

    // else{
    //      tempDate = DateTime.parse("20200414T160000");
    // }
    //if(a < 0 )a=0;
    // untuk menit //

    // var fiftyDaysFromNow = tempDate.add(new Duration(minutes: -a));
    // var format =
    //     DateFormat('yyyyMMddTkkmmss').format(fiftyDaysFromNow).toString();

    // //DateTime tempDate1 = DateTime.parse(fiftyDaysFromNow);

    // var fiftyDaysFromNow1 = fiftyDaysFromNow.add(new Duration(minutes: 35));
    // var format1 =
    //     DateFormat('yyyyMMddTkkmmss').format(fiftyDaysFromNow1).toString();

    // untuk menit //

    // untuk jam //

    var fiftyDaysFromNow =
        tempDate.add(new Duration(hours: -a - AddManualLeft));
    var format =
        DateFormat('yyyyMMddTkkmmss').format(fiftyDaysFromNow).toString();

    //DateTime tempDate1 = DateTime.parse(fiftyDaysFromNow);

    var plus;

    var fiftyDaysFromNow1 = fiftyDaysFromNow
        .add(new Duration(hours: (35 + AddManual + AddManualLeft)));
    var format1 =
        DateFormat('yyyyMMddTkkmmss').format(fiftyDaysFromNow1).toString();

    // untuk jam //

    data2 = format1.replaceAll("T24", "T00");

    data1 = format.replaceAll("T24", "T00");

    data1 = data1.replaceAll("14T15", "14T16");

    DateTime tempDateStart = DateTime.parse(data1);
    var DisplayFormatStart =
        DateFormat('yyyy-MM-dd kk-mm-ss').format(tempDateStart).toString();

    if (!DateLimit) {
      Qmulai = DisplayFormatStart;
    }

    DateTime tempDateFinish = DateTime.parse(data2);
    DisplayFormatStart =
        DateFormat('yyyy-MM-dd kk-mm-ss').format(tempDateFinish).toString();

    if (!DateLimit) {
      Qakhir = DisplayFormatStart;
    }

    // if(DateLimit)
    // {data1 = "20200414T160000";

    // }
    print("start " + data1.toString());
    print("stop " + data2.toString());

    DateTime data_limit = DateTime.parse("20200414T160000");

    // try {
    if (tempDateStart.isAfter(data_limit)) {
      DataStop1 = data1.toString();
      print("yes");
    } else if (tempDateStart.isBefore(data_limit)) {
      data1 = "20200414T160000";
      data2 = "20200416T040000";
    }

    // else {
    //   DataStop1 = "20200414T160000";
    //   data1 = "20200414T160000";
    // }

    setState(() {
      dataQuery =
          'SELECT * FROM EMPLOYEE WHERE time_stamp BETWEEN "$data1" AND "$data2"';
        //  tahan = true;
    });
    // } catch (e) {}

    // else
    // {
    //   data1 = "20200414T160000";
    //   print("no");
    // }
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      //changeQuery();

      isLoading = false;
    });
  }

  // _queryy (){
  //   var dataQ = DBProvider.db.getAllEmployees(dataQuery);
  //   dataQ.whenComplete();

  // }
//SELECT * FROM tablename ORDER BY column DESC LIMIT 1;
//SELECT * FROM SAMPLE_TABLE ORDER BY ROWID ASC LIMIT 1
  Future<List> getCustomers() async {
    var result = await DBProvider.db.getAllEmployees(
        'SELECT * FROM EMPLOYEE WHERE time_stamp BETWEEN "20200414T155754" AND "20200416T171455"');
    //'SELECT * FROM EMPLOYEE ORDER BY time_stamp');

    //print(result.toList()[0].toString());
    return result.toList();
  }

  Future<List> getCustomers1() async {
    var result = await DBProvider.db.getAllEmployees(
        'SELECT * FROM EMPLOYEE WHERE time_stamp LIKE "20200414T160000+0700"');

    // var res =await  db.query("Client", where: "id = ?", whereArgs: [id]);
    //'SELECT * FROM EMPLOYEE ORDER BY time_stamp');

    print(result);
    return result.toList();
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('All employees deleted');
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(dataQuery),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // print(snapshot.data[0].energy_enjoy.toString());
          List raw_data = new List();
          List phasaA = new List();
          List phasaB = new List();
          List phasaC = new List();

          for (int i = 0; i < snapshot.data.length; i++) {
            raw_data.add(snapshot.data[i].time_stamp.toString());
            phasaA.add(snapshot.data[i].energy_a.toString());
            phasaB.add(snapshot.data[i].energy_b.toString());
            phasaC.add(snapshot.data[i].energy_c.toString());
          }
          // DataStop = raw_data[0].toString().split("+")[0].toString();

          try {
            print('pertama : ' + raw_data[0].toString());
            // DataStop = raw_data[0].toString().split("+")[0].toString();
          } catch (e) {}
          try {
            print('terakhir : ' + raw_data[35].toString());
            // DataStop1 = raw_data[35].toString();
          } catch (e) {
            if (snapshot.data.length > 1) {
              print('terakhir : ' +
                  raw_data[snapshot.data.length - 1].toString());
              //  DataStop1 = raw_data[snapshot.data.length - 1].toString();
              // Qakhir = raw_data[snapshot.data.length - 1].toString();
            }
          }

          // print("A" + phasaA.reduce((num1, num2) => num1 - num2));
          // print("B" + phasaB.reduce((num1, num2) => num1 - num2));
          // print("C" + phasaC.reduce((num1, num2) => num1 - num2));

          // print('Energy A : ' + snapshot.data.energy_c.toString());
          //  print('last Energy A : ' + phasaA.toString());

          // print('Energy A : ' + phasaA.toString());
          // print('Energy B : ' + phasaB.toString());
          // print('Energy C : ' + phasaC.toString());

          // var object = jsonEncode(phasaA);
          // var object1 = jsonEncode(phasaA);
          // var object2 = jsonEncode(phasaA);
          // var data_akhir = new List();
          // data_akhir.add(object);
          // data_akhir.add(object1);
          // data_akhir.add(object2);
          // print(object);
          //  data2 = phasaA;
          // panjang = data2.length;

          // var min_data = phasaA.reduce((num1, num2) => num1 - num2);
          var min_data = 10;

          return Container(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),

              //itemCount: snapshot.data.length, //31
              itemCount: titles.length,
              //itemCount: (present <= originalItems.length) ? items.length + 1 : items.length,
              itemBuilder: (BuildContext context, int index) {
                // int indexx = index + 1;
                // return (indexx == snapshot.data.length)
                // int indexx = 0;//index + 1;

                //  if (raw_data.length == 35) {
                //changeQuery1("data1", "data2");
                DateLimit = false;

                if (index == 0) {
                  data2 = phasaA;
                  // print("daat1");
                }
                if (index == 1) {
                  data2 = phasaB;
                  //  print("daat2");
                }

                if (index == 2) {
                  data2 = phasaC;
                  // print("daat3");
                }
                // } else {
                //   DateLimit = true;
                // }

                return (index == titles.length)
                    ? Container(
                        color: Colors.greenAccent,
                        child: FlatButton(
                          child: Text(
                            "Load More",
                            textScaleFactor: 1.0,
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onPressed: () {},
                        ),
                      )
                    : Column(
                        children: <Widget>[
                          Center(
                            child: ListTile(
                              leading: Text(
                                "${titles[index]}",
                                textScaleFactor: 1.0,
                                style: TextStyle(fontSize: 18.0),
                              ),
                              // title: Text('grafik disini'
                              //     //"Data: ${snapshot.data[snapshot.data.length - indexx].energy_total} ${snapshot.data[snapshot.data.length - indexx].energy_a} "
                              //     ),
                              title: Container(
                                width: double.infinity,
                                height: data_tinggi.toDouble(),
                                // mainAxisSize: MainAxisSize.max,
                                // child: Column(
                                //   children: <Widget>[

                                child: Echarts(option: '''
              {
                animation:false,
                height:'$data_tinggi',
              
                grid: {
                        left: '0px',
                        right: '0px',
                        top:'0px'
                      },
               
                xAxis: {
                        type: 'category',

                       
                       
                        show: false,                         
                        },
                yAxis: {
                    type: 'value',
                    show: false,  
                    min:'$min_data',
                    max:24848600,
                   
                        },

                series: [{
                    
                    data: $data2,
                    type: 'bar',
                    itemStyle: {color: '$red'},
                    showBackground: true,
                    backgroundStyle: {
                        color: '#ffffff'
                    }
                    
                }]

              }
              
              '''),

                                //  ],

                                // ),,
                                // onTap: () {}, // Text(item,textAlign: TextAlign.left,style: TextStyle(fontSize: 15.0),
                              ),
                              // subtitle: Text(titles[index]
                              //     //'Time: ${snapshot.data[snapshot.data.length - indexx].time_stamp}'
                              //     ),
                            ),
                          ),
                        ],
                      );
              },
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    changeQuery1("data1", "data2");

    super.initState();
  }
}
