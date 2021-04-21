import 'package:sasageyo/alarm.dart';
import 'package:sasageyo/ringtone.dart';
import 'package:sasageyo/utils/database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

void main() {
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
  var c;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
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

  void getSecond() {
    var d = DateFormat('k k:mm:ss').format(DateTime.now()).toString();
  }

  Widget alarmList() {
    return Column(
      children: [
        ListTile(
          title: Text("Alarm 1",
              style: TextStyle(fontSize: 20, color: Colors.white)),
          // subtitle: Text("1 minute"),
          onTap: () {
            print("Tapped 1");
          },
        ),
        ListTile(
          title: Text("Alarm 2",
              style: TextStyle(fontSize: 20, color: Colors.white)),
          // subtitle: Text("Sasageyo"),
          onTap: () {
            print("Tapped 1");
          },
        ),
        ListTile(
          title: Text("Alarm 3",
              style: TextStyle(fontSize: 20, color: Colors.white)),
          // subtitle: Text("Wake up"),
          onTap: () {
            print("Tapped 1");
          },
        ),
        // ListView.builder(
        //   itemCount: c.length,
        //   itemBuilder: (BuildContext context, index) {
        //     return ListTile(
        //       title: Text(c[index].title),
        //     );
        //   },
        // )
      ],
    );
  }

  // Widget check() {
  //   return Column(
  //     children: [Text(DBProvider.db.getClient(1))],
  //   );
  // }

  Widget del() {
    return MaterialButton(
        child: Text("Delete all"),
        onPressed: () {
          DBProvider.db.deleteAll();
          print(Text("All deleted"));
        });
  }

  Widget getAll() {
    return MaterialButton(
        child: Text(
          "Print all",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          c = await DBProvider.db.getAllClients();

          print(DBProvider.db.getAllClients());
          print(c[0].time);
          print(c[0].label);
        });
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
            getAll(),
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
                })
          ],
        ),
      ),
    );
  }
}
