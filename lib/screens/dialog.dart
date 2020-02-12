import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.transparent,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).accentColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        /*Text(
                          "Please Wait....",
                          style: TextStyle(color: Colors.blueAccent),
                        )*/
                      ]),
                    )
                  ]));
        });
  }
}
