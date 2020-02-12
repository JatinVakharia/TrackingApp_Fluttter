import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:line_up_tracker/app.dart';
import 'package:line_up_tracker/config/app_config.dart';
import 'package:line_up_tracker/config/dev/string_resource.dart';
import 'package:line_up_tracker/widget/restart_app.dart';

void main() {
  var stringResource = DevStringResource();
  var configuredApp = AppConfig(
    appDisplayName: stringResource.appName,
    appInternalId: 1,
    stringResource: stringResource,
    child: MyApp(),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(RestartWidget(child: configuredApp));
  });
}
