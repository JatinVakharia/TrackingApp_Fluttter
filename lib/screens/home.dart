import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:jiffy/jiffy.dart';
import 'package:line_up_tracker/constant/constant.dart';
import 'package:line_up_tracker/database/data_repository.dart';
import 'package:line_up_tracker/model/candidate.dart';
import 'package:line_up_tracker/model/journey.dart';
import 'package:line_up_tracker/model/phase.dart';
import 'package:line_up_tracker/model/states.dart';
import 'package:line_up_tracker/model/user.dart';
import 'package:line_up_tracker/observer/generalized_observer.dart';
import 'package:line_up_tracker/screens/actionitemwidget.dart';
import 'package:line_up_tracker/screens/addprofile.dart';
import 'package:line_up_tracker/screens/candidatedetails.dart';
import 'package:line_up_tracker/screens/screen_tracker.dart';
import 'package:line_up_tracker/screens/settings.dart';
import 'package:line_up_tracker/widget/itemview.dart';

class Home extends StatefulWidget {
  final String title;
  final Map<String, dynamic> user;

  Home({Key key, this.title, this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> implements StateListener {
  List<Map<dynamic, dynamic>> candidateList;
  List<Map<dynamic, dynamic>> stateList;
  bool _loading;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void onStateChanged(ObserverState state) {}

  @override
  void initState() {
    super.initState();

    var stateProvider = new StateProvider();
    stateProvider.subscribe(this);

    getCandidates();
    initFcmListener();
  }

  void initFcmListener() {
    //https://fireship.io/lessons/flutter-push-notifications-fcm-guide/
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showDialog(context, message['data']['candidate_id'],
            message['notification']['title'], message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        navigateToCandidateDetails(message['data']['candidate_id']);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        navigateToCandidateDetails(message['data']['candidate_id']);
      },
    );
  }

  void _showDialog(
      BuildContext context, String candidateId, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(title),
          subtitle: Text(message),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              navigateToCandidateDetails(candidateId);
            },
          ),
        ],
      ),
    );
  }

  void navigateToCandidateDetails(String candidateId) {
    if (ScreenTracker.getInstance().getCurrentScreen() !=
        Screen.CANDIDATE_DETAILS) {
      DataRepository.getStateList((stateList) {
        DataRepository.getCandidateDetails(candidateId, true, (data) {
          var img = data['gender'] == "male" || data['gender'] == "Male"
              ? "assets/images/male-240.png"
              : "assets/images/female-240.png";
          CandidateDetails candidateDetails = CandidateDetails(
              img: img,
              id: data['id'],
              name: data['name'],
              email: data['email'],
              mobno: data['mobno'],
              mobno1: data['mobno1'],
              mobno2: data['mobno2'],
              gender: data['gender'],
              skill: data['skill'],
              currentCompany: data['currentCompany'],
              noticePeriod: data['noticePeriod'],
              journey: data['journey'] != null
                  ? new Journey.fromJson(data['journey'])
                  : null,
              states: stateList,
              user: widget.user);

          var router =
          new MaterialPageRoute(builder: (context) => candidateDetails);
          Navigator.of(context).push(router);
        });
      });
    }
  }

  String generateRandomString(bool isString, int length) {
    String chars =
    isString ? "abcdefghijklmnopqrstuvwxyz0123456789" : "0123456789";
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < length; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  void addCandidate(CandidateItem filledCandidate) async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    String random = generateRandomString(true, 20);

    // Assign an id to candidate
    filledCandidate.id = random;

    // Add first status
    Journey journey = new Journey();
    Phase phase = new Phase();
    States state = States.fromJson(stateList[0]);
    QuerySnapshot query = await Firestore.instance
        .collection('users')
        .where("displayName", isEqualTo: state.owner)
        .getDocuments();
    if (query.documents.length > 0) {
      User user = User.fromJson(query.documents[0].data);
      phase.ownerImageUrl = user.photoUrl;
    }

    phase.name = state.name;
    phase.owner = state.owner;
    phase.ownerEmailID = state.ownerEmail;
    phase.status = Constant.CURRENT_STATE;
    phase.started_on = new DateTime.now().millisecondsSinceEpoch;
    phase.dueDate = Jiffy().add(days: state.dueTime).millisecondsSinceEpoch;
    List<Phase> phaseList = new List();
    phaseList.insert(0, phase);
    journey.journeyList = phaseList;
    filledCandidate.journey = journey;

    Map<String, dynamic> candidateData = filledCandidate.toJson();

    // Add candidate to firebase
    final CollectionReference postsRef =
        await Firestore.instance.collection(Constant.CANDIDATE_COLLECTION);
    await postsRef.document(random).setData(candidateData);
  }

  getCandidates() {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    // Get all States
    DataRepository.getStateList((onData) {
      this.stateList = onData;

      // Get Candidates and update list
      DataRepository.getCandidateList((onData) {
        this.candidateList = sortCandidateList(onData);

        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(Screen.HOME.toString()),
      onVisibilityChanged: (VisibilityInfo info) {
        ScreenTracker.getInstance().onScreen(Screen.HOME, info);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "${widget.title}",
            style: TextStyle(),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () {
                  if (ScreenTracker.getInstance().getCurrentScreen() !=
                      Screen.ACTION_ITEMS) {
                    var router =
                    new MaterialPageRoute(builder: (BuildContext context) {
                      return ActionItemWidget(widget.user);
                    });

                    Navigator.of(context).push(router);
                  }
                }, tooltip: "Action Items"),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                if (ScreenTracker.getInstance().getCurrentScreen() !=
                    Screen.SETTINGS) {
                  var router =
                  new MaterialPageRoute(builder: (BuildContext context) {
                    return Settings(
                      title: widget.title,
                    );
                  });

                  Navigator.of(context).push(router);
                }
              },
              tooltip: "Search",
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: _loading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).accentColor),
          ),
        )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: candidateList == null ? 0 : candidateList.length,
                  itemBuilder: (BuildContext context, int index) {
                    CandidateItem candidateItem =
                        CandidateItem.fromJson(candidateList[index]);
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Slidable(
                        key: new Key(candidateItem.name),
                        child: ItemView(
                          name: candidateItem.name,
                          email: candidateItem.email,
                          mobno: candidateItem.mobno,
                          mobno1: candidateItem.mobno1,
                          mobno2: candidateItem.mobno2,
                          id: candidateItem.id,
                          gender: candidateItem.gender,
                          skill: candidateItem.skill,
                          currentCompany: candidateItem.currentCompany,
                          noticePeriod: candidateItem.noticePeriod,
                          journey: candidateItem.journey,
                          states: stateList,
                          user: widget.user,
                        ),
                        actions: <Widget>[
                          IconSlideAction(
                              closeOnTap: true,
                              icon: Icons.timelapse,
                              caption: "Change",
                              color: Colors.blue,
                              onTap: () =>
                                  _selectDate(context, candidateItem.id))
                        ],
                        actionPane: SlidableDrawerActionPane(),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            closeOnTap: true,
                            icon: Icons.delete,
                            caption: "Delete",
                            color: Colors.red,
                            onTap: () => _showSnackBar(
                                'Delete', context, index, candidateItem.id),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
//        onPressed: addCandidate,
          onPressed: () {
            if (ScreenTracker.getInstance().getCurrentScreen() !=
                Screen.ADD_PROFILE) {
              var router = new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Profile();
                  });

              Navigator.of(context).push(router).then((onValue) {
                print(onValue);
                if (onValue != null) addCandidate(onValue);
              });
            }
          },
          tooltip: 'Add',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showSnackBar(text, context, index, id) {
    Map<dynamic, dynamic> item;
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          if (mounted) {
            setState(() {
              _updateCandidateDetails(true, id);
              item['isActive'] = true;
              candidateList.insert(index, item);
            });
          }
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
    if (mounted) {
      setState(() {
        _updateCandidateDetails(false, id);
        item = candidateList[index];
        candidateList.removeAt(index);
      });
    }
  }

  void _updateCandidateDetails(bool isActive, id) async {
    await Firestore.instance
        .collection(Constant.CANDIDATE_COLLECTION)
        .document(id)
        .updateData({"isActive": isActive});
  }

  dynamic sortCandidateList(dynamic candidateList) {
    DateTime nowDate = DateTime.now();
    List<Map<dynamic, dynamic>> sortedList = new List();
    List<Map<dynamic, dynamic>> passOrFailCandidates = new List();
    for (int i = 0; i < candidateList.length; i++) {
      CandidateItem item = CandidateItem.fromJson(candidateList[i]);
      Journey journey = item.journey;
      Phase phase = journey.journeyList.last;

      if (phase.status == Constant.PASSED_STATE ||
          phase.status == Constant.FAILED_STATE) {
        passOrFailCandidates.add(item.toJson());
      } else {
        item.timeDifference = phase.dueDate - nowDate.millisecondsSinceEpoch;
        sortedList.add(item.toJson());
      }
    }

    sortedList.sort((m1, m2) {
      return m1["timeDifference"].compareTo(m2["timeDifference"]);
    });
    sortedList.addAll(passOrFailCandidates);
    return sortedList;
  }

  _selectDate(BuildContext context, String candidateId) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: Jiffy().add(days: -5),
        lastDate: Jiffy().add(days: 5));
    if (picked != null) {
      // update due time
      if (mounted) {
        setState(() {
          _loading = true;
        });
      }
      DataRepository.updateDueDateCandidate(
          candidateId, picked.millisecondsSinceEpoch, (onSuccess) {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      });
    }
  }
}
