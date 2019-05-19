///
/// `alert.dart`
/// Class contains static methods to show alerts
///

import 'package:flutter/material.dart';

class Alert {
  static Future displayAlert({
    BuildContext context,
    String title,
    String content,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }

  static Future displayConfirm({
    BuildContext context,
    String title = '',
    String content = '',
    String confirm = 'OK',
    Function onPressed,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text(confirm),
              onPressed: onPressed ?? () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
