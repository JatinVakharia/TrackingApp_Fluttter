import 'package:flutter/material.dart';
import 'package:line_up_tracker/config/app_config.dart';
import 'package:line_up_tracker/screens/home.dart';
import 'package:line_up_tracker/themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  // To restart App
  static restartApp(BuildContext context) {
    final _MainScreenState state =
        context.ancestorStateOfType(const TypeMatcher<_MainScreenState>());
    state.restartApp();
  }

  final Map<String, dynamic> user;

  MainScreen(Map<String, dynamic> this.user);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String theme;

  //To Restart app
  Key key = UniqueKey();

  restartApp() {
    if (mounted) {
      setState(() {
        key = UniqueKey();
      });
      checkTheme();
    }
  }

  @override
  void initState() {
    super.initState();
    checkTheme();
  }

  checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefTheme =
        prefs.getString("theme") == null ? "light" : prefs.getString("theme");
    print("THEME: $prefTheme");
    if (mounted) {
      setState(() {
        theme = prefTheme;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);
    return MaterialApp(
      key: key,
      title: "${config.appDisplayName}",
      debugShowCheckedModeBanner: false,
      home: Home(
        title: "${config.appDisplayName}",
        user: widget.user,
      ),
      theme: theme == "dark" ? AppTheme.dark : AppTheme.light,
    );
  }
}
