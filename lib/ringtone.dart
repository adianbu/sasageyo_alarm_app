import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class Ringtone extends StatefulWidget {
  @override
  _RingtoneState createState() => _RingtoneState();
}

class _RingtoneState extends State<Ringtone> {
  String ring2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: CustomRadioButton(
          elevation: 0,
          horizontal: false,
          absoluteZeroSpacing: false,
          unSelectedColor: Theme.of(context).canvasColor,
          buttonLables: [
            'Sasageyo',
            'Kono Dio da',
          ],
          buttonValues: [
            "Sasageyo",
            "Kono Dio da",
          ],
          buttonTextStyle: ButtonTextStyle(
              selectedColor: Colors.white,
              unSelectedColor: Colors.black,
              textStyle: TextStyle(fontSize: 16)),
          radioButtonValue: (value) {
            print(value);
            setState(() {
              ring2 = value;
            });
            Navigator.pop(context, ring2);
          },
          selectedColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
