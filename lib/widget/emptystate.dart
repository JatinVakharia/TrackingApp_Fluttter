import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  String message;

  EmptyStateWidget(String message) {
    this.message = message;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
        child: Padding(
      child: Center(
          child: Text(
        message,
        textAlign: TextAlign.center,
        style: textTheme.subtitle,
      )),
      padding: const EdgeInsets.all(4.0),
    ));
  }
}
