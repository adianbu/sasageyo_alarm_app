// import 'package:coin_toss_app/pages/Coin.dart';
// import 'package:coin_toss_app/pages/Flip.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.repeat}) : super(key: key);

  final String repeat;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool animateTrigger = true;

  int timeToFlip = 5;

  List<String> _cheatList = ['Heads', 'Tails', 'Normal'];
  String _selectedCheat;

  Widget flip() {
    if (widget.repeat != null) {
      _selectedCheat = widget.repeat;
    }
    Coin coin = new Coin(clientName: _selectedCheat);

    if (animateTrigger) {
      return coin;
    } else {
      return Flip(repeat:_selectedCheat );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          animateTrigger = false;
        });
      },
      child: Scaffold(
        body: flip(),
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: Center(
            child: DropdownButton(
              hint: Text('Please choose'),
              value: _selectedCheat,
              onChanged: (newValue) {
                setState(() {
                  _selectedCheat = newValue;
                  print(_selectedCheat);
                });
              },
              items: _cheatList.map((cheat) {
                return DropdownMenuItem(
                  child: Text(cheat),
                  value: cheat,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
