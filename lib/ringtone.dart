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
      backgroundColor: Color(0xFF2A2A3B),
      appBar: AppBar(
         backgroundColor: Color(0xFF2A2A3B),
      ),
      body: SafeArea(
        child: Center(
          child: CustomRadioButton(
            selectedBorderColor: Color(0xFF2A2A3B),
            unSelectedBorderColor: Colors.white,
            elevation: 0,
            horizontal: true,
            autoWidth: true,
            height: 65,
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
                unSelectedColor: Color(0xFF2A2A3B),
                textStyle: TextStyle(fontSize: 30)),
            radioButtonValue: (value) {
              print(value);
              setState(() {
                ring2 = value;
              });
              Navigator.pop(context, ring2);
            },
            selectedColor: Color(0xFF2A2A3B),
          ),
        ),
      ),
    );
  }
}
