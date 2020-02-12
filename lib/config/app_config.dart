import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  AppConfig({this.appDisplayName,this.appInternalId, this.stringResource,
    Widget child}):super(child: child);

  final String appDisplayName;
  final int appInternalId;
  final StringResource stringResource;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

  static AppConfig of(BuildContext context) {
    return context.ancestorWidgetOfExactType(AppConfig);
  }

}

abstract class StringResource {
  String appName;
}