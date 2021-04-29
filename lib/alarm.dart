import 'package:sasageyo/main.dart';
import 'package:sasageyo/utils/clientModel.dart';
import 'package:sasageyo/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/services.dart';
// import 'package:sqflite/sqflite.dart';

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  List<bool> isSelected = [true, false];
  bool toggleVibrate = false;

  String ring = "Sasageyo";

  String label = "No Label";

  String time = "0000";
  int i = 1;

  // var words = <String, int>{'vibrate': 1, 'duration': 1};
  // var data = <String, String>{
  //   'time': 'null',
  //   'ringtone': 'sasageyo',
  //   'label': 'alarm'
  // };

  Future<String> createDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              // height: 30,
              child: AlertDialog(
                title: Text("Enter a label"),
                content: TextField(
                  controller: controller,
                ),
                actions: <Widget>[
                  MaterialButton(
                      elevation: 0,
                      child: Text("Submit"),
                      onPressed: () {
                        Navigator.of(context).pop(controller.text.toString());
                      })
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A3B),
      appBar: AppBar(
        elevation: 10,
        shadowColor: Color(0xFF2A2A3B),
        backgroundColor: Color(0xFF2A2A3B),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Set Alarm"),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                //for entering into database
                var e = await DBProvider.db.getAllClients();
                if (e.length != 0) {
                  print("db full");
                  return Navigator.pop(context);
                }

                var newAlarm = Client(
                    id: i,
                    time: time,
                    vibrate: i,
                    ringtone: ring,
                    label: label);

                DBProvider.db.newClient(newAlarm);

                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: Column(
        children: [
          // Text("Next alarm will ring on"),
          // Text("Day, March 1"),
          
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Enter Time",
                       style: TextStyle(fontSize: 30, color: Colors.white)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 80,
                            // color: Colors.amber,
                            child: TextField(
                              decoration: InputDecoration(hintText: '00',hintStyle: TextStyle(
                                fontSize: 70,
                                color: Colors.white
                              ),),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                              ],
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 70,
                                color: Colors.white
                              ),
                              cursorHeight: 70,
                              // cursorWidth: 10,
                              cursorColor: Colors.black,
                              onChanged: (text) {
                                time = text;
                              },
                            ),
                          ),
                          Text("hour",
                       style: TextStyle(fontSize: 20, color: Colors.white))
                        ],
                      ),
                    ),
                    Text(
                      ":",
                      style: TextStyle(fontSize: 90,
                      color: Colors.white),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 80,
                            // color: Colors.amber,
                            child: TextField(
                              decoration: InputDecoration(hintText: '00',hintStyle: TextStyle(
                                fontSize: 70,
                                color: Colors.white
                              ),),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                              ],
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 70,
                                color: Colors.white
                              ),
                              cursorHeight: 70,
                              // cursorWidth: 10,
                              // cursorColor: Colors.black,
                              onChanged: (text) {},
                            ),
                          ),
                          Text("minute",
                       style: TextStyle(fontSize: 20, color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text("Repeat",
                         style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
          Container(
            padding: EdgeInsets.only(left: 60),
            child: Center(
              child: CustomCheckBoxGroup(
                enableShape: true,
                // elevation: 0,
                absoluteZeroSpacing: false,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: [
                  "S",
                  "M",
                  "T",
                  "W",
                  "T",
                  "F",
                  "S",
                ],
                buttonValuesList: [
                  "Sunday",
                  "Monday",
                  "Tuesday",
                  "Wednesday",
                  "Thursday",
                  "Friday",
                  "Saturday",
                ],
                checkBoxButtonValues: (values) {
                  print(values);
                },
                horizontal: false,
                // padding: 4,
                width: 32,
                // height: 30,
                buttonTextStyle: ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Colors.black,
                    textStyle: TextStyle(fontSize: 16)),
                selectedColor: Theme.of(context).accentColor,
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          SwitchListTile(
            title: Text("Vibrate",
                       style: TextStyle(fontSize: 20, color: Colors.white)),
            value: toggleVibrate,
            onChanged: (value) {
              setState(() {
                toggleVibrate = value;
              });
            },
          ),
          
          ListTile(
            title: Text("Alarm Ringtone",
                       style: TextStyle(fontSize: 20, color: Colors.white)),
            subtitle: Text(ring,
                       style: TextStyle( color: Colors.white70)),
            onTap: () async {
              final ringName = await Navigator.pushNamed(context, '/ring');
              setState(() {
                ring = ringName.toString();
              });
              print(ringName);
            },
          ),
         
          ListTile(
            title: Text("Label",
                       style: TextStyle(fontSize: 20, color: Colors.white)),
            subtitle: Text(label,
                       style: TextStyle( color: Colors.white70)),
            
            onTap: () {
              return createDialog(context).then((value) {
                setState(() {
                  label = value;
                });
              });
              
              return TextField(
                onChanged: (value) => setState(() {
                  label = value;
                }),
              );
              // return showDialog(
              //     context: context,
              //     builder: (context) {
              //       return SingleChildScrollView(
              //         child: Container(
              //           // height: 30,
              //           child: AlertDialog(
              //             title: Text("Enter a label"),
              //             content: TextField(
              //               controller: controller,
              //             ),
              //             actions: <Widget>[
              //               MaterialButton(
              //                   elevation: 0,
              //                   child: Text("Submit"),
              //                   onPressed: () {
              //                     Navigator.of(context).pop(controller.text.toString());
              //                   })
              //             ],
              //           ),
              //         ),
              //       );
              //     });
            },
          ),
        ],
      ),
    );
  }
}
