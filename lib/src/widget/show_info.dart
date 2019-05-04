import 'package:flutter/material.dart';

class InfoWidgetBuilder {
  static void showInfoMessage(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("How-to Huiswerk App"),
          content: new Text(
"""Sleep eerst de taken naar de dag waarop die gereed moet zijn."
Sleep dan rode stopwatch naar een taak waaraan je gaat werken, en als daarmee klaar bent de groene stopwatch.
""",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize:15),
            maxLines: 8,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ik snap het"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
