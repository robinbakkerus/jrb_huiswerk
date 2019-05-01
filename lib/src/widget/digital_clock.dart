import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import '../events/app_events.dart';

class DigitalClock extends StatefulWidget {
  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  int _elapsed;

  _DigitalClockState() {
    AppEvents.onTick(_handleTick);
  }

  void _handleTick(TimeTickEvent event) {
    if (mounted) {
      setState(() {
        _elapsed = event.elapsed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 20,
        child: Row(
          children: <Widget>[
            _clockNr(_nrs()[0]),
            _clockNr(_nrs()[1]),
            _clockNr(_nrs()[2]),
          ],
        ));
  }

  Widget _clockNr(String value) {
    return Container(
      decoration: new BoxDecoration(
        border: new Border.all(color: Colors.blue),
        color: Colors.black,
      ),
      child: Text(
        value,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  List<String> _nrs() {
    List<String> r = List();
    if (_elapsed == null) {
      r = ['0', '0', '0'];
    } else {
      if (_elapsed < 10) {
        r.add('0'); r.add('0');
        r.add(_elapsed.toString());
      } else {
        r.add('0');
        _elapsed.toString().runes.forEach((int rune) {
          r.add(new String.fromCharCode(rune));
        });
      }
    }
    // print(r);
    return r;
  }
}
