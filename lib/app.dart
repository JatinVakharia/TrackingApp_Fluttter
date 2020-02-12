import 'package:flutter/material.dart';
import 'package:line_up_tracker/authentication/auth.dart';
import 'package:line_up_tracker/config/app_config.dart';
import 'package:line_up_tracker/screens/mainscreen.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var config = AppConfig.of(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterBase',
      home: Builder(
        builder: (context) => Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 250.0),
                  child: Center(
                    child: Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        config.appDisplayName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.white,
                          onPressed: () =>
                              authService.googleSignIn().catchError((error) {
                            showErrorDialog(context);
                          }),
                          child: new Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 20.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Text(
                                    "LOGIN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                UserProfile()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showErrorDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please try again'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
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

class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Map<String, dynamic> _profile;
  bool _loading = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    authService.getCurrentUser().then((user) {
      authService.profile.listen((state) {
        _profile = state;
        if (_profile != null && _profile.length > 0) {
          if (mounted) {
            setState(() {
              _isLoggedIn = true;
            });
          }
        }
      });

      if (mounted) {
        authService.loading.listen((state) => setState(() => _loading = state));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
            ),
          )
        : _isLoggedIn
            ? showMainScreen(context)
            : Column(children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "You are Logged Out",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ]);
  }

  showMainScreen(BuildContext context) {
    var router = new MaterialPageRoute(builder: (BuildContext context) {
      return MainScreen(_profile);
    });

    Future.delayed(Duration(milliseconds: 50)).then((_) {
      Navigator.pushReplacement(context, router);
    });
    return new Container();
  }
}
