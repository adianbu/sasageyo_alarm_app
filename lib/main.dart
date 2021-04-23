import 'package:sasageyo/alarm.dart';
import 'package:sasageyo/ringtone.dart';
import 'package:sasageyo/utils/clientModel.dart';
import 'package:sasageyo/utils/database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
        child: TimeOfDays(),
      ),
    ),
  ));
}

class TimeOfDays extends StatefulWidget {
  @override
  _TimeOfDaysState createState() => _TimeOfDaysState();
}

class _TimeOfDaysState extends State<TimeOfDays> {
  // var c;
  Map<String, String> newuser = {};

  var _alarms;
  // DBProvider data = new DBProvider.db();

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  get() async {
    var data = await DBProvider.db.getAllClients();
    _alarms = data;
    return data;
  }

  String _timeString;
  // TimeOfDay t = TimeOfDay.now();
  var time = DateTime.now();

  // var t = Timer.periodic(Duration );
  void getTime() {
    final String formattedDateTime =
        DateFormat('k k:mm:ss').format(DateTime.now()).toString();

    setState(() {
      _timeString = formattedDateTime;
      print(_timeString);
    });
  }

  Widget alarm() {
    return FutureBuilder(
        future: _alarms,
        builder: (BuildContext context, snapshot) {
          // if (snapshot.data.length == 0) {
          //   print("No elements in db");
          //   return Container(
          //     child: Text("No alarm"),
          //   );
          // }
          if (snapshot.hasData) {
            return ListTile(
              title: Text(snapshot.data[0].label),
            );
          } else {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            return Container(
              child: Text("No alarm"),
            );
          }

          // print(index.data);
        });
  }

  Widget alarmList() {
    get();
    return Column(
      children: [
        _alarms != null
            ? (_alarms.length != 0
                ? (ListTile(
                    title: Text("Alarm set at 4:20",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap: () {
                      print("Tapped 1");
                    },
                  ))
                : (ListTile(
                    title: Text("No Alarms",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onTap: () {
                      print("Tapped 1");
                    },
                  )))
            : Container()
      ],
    );
  }

  Widget del() {
    var d;
    return MaterialButton(
        child: Text("Delete all"),
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
    var androidDetails = AndroidNotificationDetails(
        'Channel ID', 'Adithya Anbu', 'my channel',
        importance: Importance.max);
    var iosDetails = IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    var generalNotifications =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await flutterLocalNotificationsPlugin.show(
        0, "title", "body", generalNotifications);
  }

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
            MaterialButton(
              onPressed: showNotification,
              child: Text("Notification"),
            )
          ],
        ),
      ),
    );
  }
}
