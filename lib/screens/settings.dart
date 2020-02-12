import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:line_up_tracker/authentication/auth.dart';
import 'package:line_up_tracker/screens/mainscreen.dart';
import 'package:line_up_tracker/screens/screen_tracker.dart';
import 'package:line_up_tracker/widget/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final String title;

  Settings({Key key, this.title}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched;

  checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefTheme =
        prefs.getString("theme") == null ? "light" : prefs.getString("theme");

    if (prefTheme == "light") {
      if (mounted) {
        setState(() {
          isSwitched = false;
        });
      }
    } else if (prefTheme == "dark") {
      if (mounted) {
        setState(() {
          isSwitched = true;
        });
      }
    } else {
      print("This is literally imposible to execute");
    }
  }

  @override
  void initState() {
    super.initState();
    checkTheme();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(Screen.SETTINGS.toString()),
      onVisibilityChanged: (VisibilityInfo info) {
        ScreenTracker.getInstance().onScreen(Screen.SETTINGS, info);
      },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        title: Text(
          "Settings",
          style: TextStyle(),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(
                  "Dark Mode",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                subtitle: Text("Use the dark mode"),
                trailing: Switch(
                  value: isSwitched == null ? false : isSwitched,
                  onChanged: (value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String prefTheme = prefs.getString("theme") == null
                        ? "light"
                        : prefs.getString("theme");
                    if (prefTheme == "light") {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setString("theme", "dark");
                      MainScreen.restartApp(context);
                    } else if (prefTheme == "dark") {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setString("theme", "light");
                      MainScreen.restartApp(context);
                    }
                  },
                  activeColor: Theme.of(context).accentColor,
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  // Restart App
                  RestartWidget.restartApp(context);
                  // LogOut
                  authService.signOut();
                },
                child: ListTile(
                  title: Text(
                    "LogOut",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
