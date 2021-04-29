import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:sasageyo/alarm.dart';
import 'package:sasageyo/ringtone.dart';
import 'package:sasageyo/utils/clientModel.dart';
import 'package:sasageyo/utils/database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/enums.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = AndroidInitializationSettings('clock');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {});
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await flutterLocalNotificationsPlugin.cancel(0);
  });
  runApp(MaterialApp(
    routes: {
      '/time': (context) => TimeOfDays(),
      '/alarm': (context) => Alarm(),
      '/ring': (context) => Ringtone(),
    },
    home: Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Alarm(),
      ),
    ),
  ));
}

class TimeOfDays extends StatefulWidget {
  @override
  _TimeOfDaysState createState() => _TimeOfDaysState();
}

class _TimeOfDaysState extends State<TimeOfDays> {
  var _alarms;
  int alarmBit;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      var now = DateTime.now();
      var currentTime =
          DateTime(now.year, now.month, now.day, now.hour, now.minute);

      // DateTime d = DateFormat('kk:mm:ss', 'en-US').parseLoose('22:59:30');
      var startTime = DateTime(now.year, now.month, now.day, 19, 22, 0);

      if (currentTime.millisecondsSinceEpoch ==
          startTime.millisecondsSinceEpoch) {
        print("show notification");
        showNotification();
      }
    });

    super.initState();
  }

  get() async {
    var data = await DBProvider.db.getAllClients();
    _alarms = data;
    return data;
  }

  String _timeString;
  var time = DateTime.now();

  void getTime() {
    final String formattedDateTime =
        DateFormat('k k:mm:ss').format(DateTime.now()).toString();

    setState(() {
      _timeString = formattedDateTime;
      print(_timeString);
    });
  }

  // Widget alarm() {
  //   return FutureBuilder(
  //       future: _alarms,
  //       builder: (BuildContext context, snapshot) {
  //         // if (snapshot.data.length == 0) {
  //         //   print("No elements in db");
  //         //   return Container(
  //         //     child: Text("No alarm"),
  //         //   );
  //         // }
  //         if (snapshot.hasData) {
  //           return ListTile(
  //             title: Text(snapshot.data[0].label),
  //           );
  //         } else {
  //           if (snapshot.hasError) {
  //             print(snapshot.error);
  //           }
  //           return Container(
  //             child: Text("No alarm"),
  //           );
  //         }
  //       });
  // }

  Widget alarmList() {
    get();
    return Column(
      children: [
        _alarms != null
            ? (_alarms.length != 0
                ? (Container(
                    width: double.infinity / 1.2,
                    height: 65,
                    child: Center(
                      child: Text("Alarm set at 4:20",
                          style: TextStyle(fontSize: 30, color: Colors.white)),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ))
                : (Container(
                    width: double.infinity / 1.2,
                    height: 65,
                    child: Center(
                      child: Text("No Alarms",
                          style: TextStyle(fontSize: 30, color: Colors.white)),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )))
            : Container()
      ],
    );
  }

  Widget del() {
    var d;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
      child: ElevatedButton(        
        child: Container(
           width: double.infinity / 1.2,
          height: 65,
          child: Center(child: Text("Delete all",
              style: TextStyle(fontSize: 30, color: Color(0xFF2A2A3B))))),
        onPressed: () async {
          d = await DBProvider.db.getAllClients();
          if (d.length == 0) {
            print("No items to be deleted");
          } else {
            DBProvider.db.deleteAll();
            print(Text("All deleted"));
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
    return MaterialButton(
        color: Colors.white,
        minWidth: double.infinity / 1.2,
        height: 65,
        child: Text("Delete all",
            style: TextStyle(fontSize: 20, color: Colors.black)),
        onPressed: () async {
          d = await DBProvider.db.getAllClients();
          if (d.length == 0) {
            print("No items to be deleted");
          } else {
            DBProvider.db.deleteAll();
            print(Text("All deleted"));
          }
        });
  }

  Widget getAll() {
    var e;
    return MaterialButton(
        child: Text(
          "Print all",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          e = await DBProvider.db.getAllClients();
          if (e.length != 0) {
            print(DBProvider.db.getAllClients());
            print("Time is" + e[0].time);
            print(e[0].label);
          } else {
            print('No items in db');
          }
        });
  }

  showNotification() async {
    Random random = new Random();
    int randomNumber = random.nextInt(2);

    var androidDetails = AndroidNotificationDetails(
      'this channel',
      'Adithya Anbu',
      'Adithya Anbu',
      // priority: Priority.high,
      icon: 'clock',
      sound: RawResourceAndroidNotificationSound(
          randomNumber == 0 ? 'dio' : "sasageyo"),
      // sound: RawResourceAndroidNotificationSound('dio'),

      largeIcon: DrawableResourceAndroidBitmap('clock'),
      importance: Importance.max,
      enableVibration: true,
      // timeoutAfter: 280000,
      playSound: true,
    );
    var iosDetails = IOSNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);

    var generalNotifications =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    //variable for datetime
    DateTime d = DateFormat('kk:mm:ss', 'en-US').parseLoose('21:34:45');

    //to show instantly
    Timer.periodic(Duration(seconds: 1), (cr) async {
      if (DateTime.now() == d) {
        print("object");
      }
    });

    //checking if element is present in db or not
    var e = await DBProvider.db.getAllClients();
    if (e.length != 0) {
      await flutterLocalNotificationsPlugin.show(0, "Wake yo ass up!!!",
          "Click to cancel alarm", generalNotifications);
    }

    // await flutterLocalNotificationsPlugin.periodicallyShow(
    //     0, "Wake yo ass up!!!", "Click to cancel alarm", RepeatInterval.daily, generalNotifications);
  }

  //to schedule
  // await flutterLocalNotificationsPlugin.zonedSchedule(0, "title", "body", DateTime.tuesday, notificationDetails, uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation, androidAllowWhileIdle: androidAllowWhileIdle)

  @override
  Widget build(BuildContext context) {
    // Timer.periodic(Duration(seconds: 1), (Timer t) => getSecond());

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(30),
        color: Color(0xFF2A2A3B),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 50),
              child: Center(
                  child: Text(
                      DateFormat('kk:mm:ss').format(DateTime.now()).toString(),
                      style: TextStyle(
                          fontFamily: 'digital-7',
                          fontSize: 100,
                          color: Colors.white))),
            ),
            alarmList(),
            
            del(),
            // getAll(),
            FloatingActionButton(
                backgroundColor: Colors.white70,
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/alarm',
                  );
                }),
          ],
        ),
      ),
    );
  }
}
