import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:line_up_tracker/constant/constant.dart';
import 'package:line_up_tracker/database/data_repository.dart';
import 'package:line_up_tracker/model/candidate.dart';
import 'package:line_up_tracker/model/journey.dart';
import 'package:line_up_tracker/model/phase.dart';
import 'package:line_up_tracker/model/states.dart';
import 'package:line_up_tracker/model/user.dart';
import 'package:line_up_tracker/observer/generalized_observer.dart';
import 'package:line_up_tracker/screens/addprofile.dart';
import 'package:line_up_tracker/screens/dialog.dart';
import 'package:line_up_tracker/screens/screen_tracker.dart';
import 'package:line_up_tracker/widget/superhero_avatar.dart';

class CandidateDetails extends StatefulWidget {
  String title;
  String id;
  String img;
  String name;
  String email;
  String mobno;
  String mobno1;
  String mobno2;
  String gender;
  String skill;
  String currentCompany;
  String noticePeriod;
  String ticket;
  var journey;
  final states;
  final Map<String, dynamic> user;

  CandidateDetails(
      {Key key,
      this.title,
      this.id,
      this.img,
      this.name,
      this.email,
      this.mobno,
      this.mobno1,
      this.mobno2,
      this.gender,
      this.skill,
      this.currentCompany,
      this.noticePeriod,
      this.ticket,
      this.journey,
      this.states,
      this.user})
      : super(key: key);

  @override
  _CandidateDetailsState createState() => _CandidateDetailsState();
}

class _CandidateDetailsState extends State<CandidateDetails> {
  bool _loading = false;
  bool profileCalled = false;

  @override
  void initState() {
    super.initState();
    monitorCandidateDataChanges();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(Screen.CANDIDATE_DETAILS.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          ScreenTracker.getInstance().onScreen(Screen.CANDIDATE_DETAILS, info);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0.0,
            title: Text(widget.name),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.mode_edit),
                onPressed: (() {
                  if (ScreenTracker.getInstance().getCurrentScreen() !=
                      Screen.ADD_PROFILE) {
                    final profile = Profile(
                      name: widget.name,
                      email: widget.email,
                      mobno: widget.mobno,
                      mobno1: widget.mobno1,
                      mobno2: widget.mobno2,
                      skill: widget.skill,
                      currentCompany: widget.currentCompany,
                      noticePeriod: widget.noticePeriod,
                      ticket: widget.ticket,
                      gender: widget.gender,
                    );

                    var router =
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return profileCalled ? null : profile;
                    });

                    Navigator.of(context).push(router).then((onValue) {
                      profileCalled = false;
                      if (onValue != null) modifyCandidate(widget.id, onValue);
                    });
                  }
                }),
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
                  padding:
                      EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SuperheroDetails(candidateDetails: widget),
                  ),

                  /*SuperheroDetails(candidateDetails: widget),*/
                ),
        ));
  }

  modifyCandidate(String id, CandidateItem candidate) {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    Firestore.instance
        .collection(Constant.CANDIDATE_COLLECTION)
        .document(id)
        .updateData({
      'name': candidate.name,
      'email': candidate.email,
      'mobno': candidate.mobno,
      'mobno1': candidate.mobno1,
      'mobno2': candidate.mobno2,
      'skill': candidate.skill,
      'currentCompany': candidate.currentCompany,
      'noticePeriod': candidate.noticePeriod,
      'ticket': candidate.ticket,
      'gender': candidate.gender,
    });
  }

  void monitorCandidateDataChanges() {
    DataRepository.getCandidateDetails(widget.id, true, (data) {
      widget.name = data['name'];
      widget.email = data['email'];
      widget.mobno = data['mobno'];
      widget.mobno1 = data['mobno1'];
      widget.mobno2 = data['mobno2'];
      widget.skill = data['skill'];
      widget.currentCompany = data['currentCompany'];
      widget.noticePeriod = data['noticePeriod'];
      widget.ticket = data['ticket'];
      widget.gender = data['gender'];
      widget.journey = data['journey'] != null
          ? new Journey.fromJson(data['journey'])
          : null;
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }
}

class SuperheroDetails extends StatefulWidget {
  const SuperheroDetails({
    Key key,
    @required this.candidateDetails,
  }) : super(key: key);

  final CandidateDetails candidateDetails;

  @override
  _SuperheroDetailsState createState() => _SuperheroDetailsState();
}

class _SuperheroDetailsState extends State<SuperheroDetails> {
  Map<String, bool> _categoryExpansionStateMap = Map<String, bool>();
  bool isExpandedo;
  List<Map<dynamic, dynamic>> stateList;

  @override
  void initState() {
    super.initState();
    _categoryExpansionStateMap = {
      /*"Transfer": true,*/
      "Journey": false,
    };

    isExpandedo = false;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SuperheroAvatar(
              img: widget.candidateDetails.img,
              radius: 50.0,
            ),
            SizedBox(
              height: 13.0,
            ),
            Text(
              widget.candidateDetails.email,
              style: textTheme.title,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  widget.candidateDetails.mobno.toString(),
                  style: textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  "/",
                  style: textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  widget.candidateDetails.mobno1.toString(),
                  style: textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  "/",
                  style: textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  widget.candidateDetails.mobno2.toString(),
                  style: textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  widget.candidateDetails.skill.toString(),
                  style: textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "/",
                  style: textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  widget.candidateDetails.currentCompany.toString(),
                  style: textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "/",
                  style: textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  widget.candidateDetails.noticePeriod.toString(),
                  style: textTheme.subtitle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            widget.candidateDetails.ticket != null
                ? Align(
                    child: Text('Ticket ID : ${widget.candidateDetails.ticket}',
                        style: textTheme.subtitle.copyWith(
                          fontWeight: FontWeight.w500,
                        )),
                  )
                : SizedBox(
                    height: 10.0,
                  ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black26,
                  width: 1.0,
                ),
                color: Colors.white,
                //borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Transfer(
                    states: widget.candidateDetails.states,
                    phases: widget.candidateDetails.journey.journeyList,
                    candidateDetails: widget.candidateDetails,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                if (mounted) {
                  setState(() {
                    _categoryExpansionStateMap[_categoryExpansionStateMap.keys
                        .toList()[index]] = !isExpanded;
                  });
                }
              },
              children: <ExpansionPanel>[
                ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                          title: Text(
                        "Journey",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ));
                    },
                    body: JourneyWidget(
                      states: widget.candidateDetails.states,
                      phases: widget.candidateDetails.journey.journeyList,
                      candidateDetails: widget.candidateDetails,
                    ),
                    isExpanded: _categoryExpansionStateMap["Journey"]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Transfer extends StatefulWidget {
  final List<Map> states;
  List<Phase> phases;
  final CandidateDetails candidateDetails;
  final constToCancel = "###%%%&&&";
  String transitToState = "";

  Transfer({
    Key key,
    @required this.states,
    this.phases,
    this.candidateDetails,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  List<dynamic> assignTransitStates() {
    if (widget.phases[widget.phases.length - 1].status ==
        Constant.FAILED_STATE) {
      List<dynamic> x = new List();
      x.add(Constant.FAILED_STATE);
      return x;
    } else
      for (var i = 0; i < widget.phases.length; i++) {
        if (widget.phases[i].status == Constant.CURRENT_STATE)
          for (var j = 0; j < widget.states.length; j++) {
            States state = States.fromJson(widget.states[j]);
            if (widget.phases[i].name == state.name) return state.transitTo;
          }
      }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> transitTo = assignTransitStates();
    List<Widget> widgetList = new List<Widget>();
    if (transitTo == null) {
      widget.transitToState = null;
      widgetList.add(
        Text(
          Constant.CANDIDATE_SELECTED,
          style: TextStyle(
              color: Colors.green, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      );
    } else {
      widget.transitToState = transitTo[0].toString();
      for (var i = 0; i < transitTo.length; i++) {
        widgetList.add(
          transitTo[0].toString() == Constant.FAILED_STATE
              ? Text(
                  Constant.CANDIDATE_REJECTED,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  softWrap: true,
                )
              : Text(
                  transitTo[i].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  softWrap: true,
                ),
        );
      }
    }

    return Row(
      children: <Widget>[
        widget.transitToState == null ||
                widget.transitToState == Constant.FAILED_STATE
            ? SizedBox.shrink()
            : Text(
                "Next Round - ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetList,
        ),
      ],
    );
  }
}

class JourneyWidget extends StatefulWidget {
  List<Phase> phases;
  List<Phase> uiRepresentationPhases;
  final List<Map> states;
  final CandidateDetails candidateDetails;
  final constToCancel = "###%%%&&&";
  final constToSuccess = "###%%%&&&";

  JourneyWidget({
    Key key,
    @required this.states,
    this.phases,
    this.candidateDetails,
  }) : super(key: key) {
    this.uiRepresentationPhases = this.phases.reversed.toList();
  }

  @override
  State<StatefulWidget> createState() {
    return _JorneyState();
  }
}

class _JorneyState extends State<JourneyWidget> {
  String nextRound = "";
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    Constant.nextRound.listen((onNextState) {
      if (mounted) {
        setState(() {
          nextRound = onNextState;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> transitTo = assignTransitStates();
    List<Widget> widgetList = new List<Widget>();
    for (var i = 0; i < widget.uiRepresentationPhases.length; i++) {
      widgetList.add(
        Padding(
          padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black26,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        widget.uiRepresentationPhases[i].name,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                        textAlign: TextAlign.start,
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      widget.uiRepresentationPhases[i].status.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                widget.uiRepresentationPhases[i].passed_on == null
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          DateFormat('dd-MM-yyyy | hh:mm').format(
                              DateTime.fromMicrosecondsSinceEpoch(int.parse(
                                      widget.uiRepresentationPhases[i].passed_on
                                          .toString()) *
                                  1000)),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Owner : " + widget.uiRepresentationPhases[i].owner,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      widget.uiRepresentationPhases[i].status ==
                              Constant.CURRENT_STATE
                          ? Column(
                              children: <Widget>[
                                Container(
                                  width: 90.0,
                                  height: 30.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      _asyncMoveStateInputDialog(
                                              context,
                                              transitTo[0] == null
                                                  ? ""
                                                  : transitTo[0].toString(),
                                              getHintTextFromCurrentStage(widget
                                                  .uiRepresentationPhases[i]
                                                  .name),
                                              transitTo)
                                          .then((comment) {
                                        if (comment != widget.constToCancel) {
                                          moveToNextPhase(
                                              nextRound,
                                              comment,
                                              User.fromJson(widget
                                                      .candidateDetails.user)
                                                  .displayName
                                                  .toString(),
                                              widget.candidateDetails.id);
                                        }
                                      });
                                    },
                                    child: Text('Move'),
                                    color: Theme.of(context).accentColor,
                                    textColor: Colors.white,
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width: 90.0,
                                  height: 30.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      _asyncAssignStateInputDialog(
                                              widget.candidateDetails.id)
                                          .then((selectedUser) {
                                        if (selectedUser != null) {
                                          DataRepository.updateAssignStageOwner(
                                              widget.candidateDetails.id,
                                              selectedUser,
                                              (result) {});
                                        }
                                      });
                                    },
                                    child: Text('Assign'),
                                    color: Theme.of(context).accentColor,
                                    textColor: Colors.white,
                                    elevation: 3.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                widget.uiRepresentationPhases[i].passed_by == null
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Passed By : " +
                              widget.uiRepresentationPhases[i].passed_by
                                  .toString(),
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                widget.uiRepresentationPhases[i].comment == null ||
                        widget.uiRepresentationPhases[i].comment.isEmpty
                    ? SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Comment : " +
                              widget.uiRepresentationPhases[i].comment
                                  .toString(),
                          style: TextStyle(fontWeight: FontWeight.w600),
                          maxLines: 3,
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: widgetList,
    );
  }

  void moveToNextPhase(String newState, String comment, String currentUser,
      String candidateId) async {
    //Updated current round details.
    Dialogs.showLoadingDialog(context, _keyLoader);
    Phase currentPhase = widget.phases.last;
    currentPhase.comment = comment;
    currentPhase.passed_by = currentUser;
    currentPhase.passed_on = new DateTime.now().millisecondsSinceEpoch;
    currentPhase.turnaround_time = 20;
//    widget.phases.last = currentPhase;

    if (newState == Constant.FAILED_STATE) {
      currentPhase.status = Constant.FAILED_STATE;
      widget.phases.last = currentPhase;
    } else {
      currentPhase.status = Constant.PASSED_STATE;
      widget.phases.last = currentPhase;
      QuerySnapshot query = await Firestore.instance
          .collection('states')
          .where('name', isEqualTo: newState)
          .getDocuments();

      if (query.documents.length > 0) {
        States newStateDetails = States.fromJson(query.documents[0].data);
        Phase newPhase = new Phase();
        newPhase.name = newStateDetails.name;
        newPhase.status = Constant.CURRENT_STATE;
        newPhase.owner = newStateDetails.owner;
        newPhase.ownerEmailID = newStateDetails.ownerEmail;
        newPhase.started_on = currentPhase.passed_on;
        newPhase.dueDate =
            Jiffy().add(days: newStateDetails.dueTime).millisecondsSinceEpoch;

        QuerySnapshot userQuery = await Firestore.instance
            .collection('users')
            .where("displayName", isEqualTo: newStateDetails.owner)
            .getDocuments();
        if (userQuery.documents.length > 0) {
          User user = User.fromJson(userQuery.documents[0].data);
          newPhase.ownerImageUrl = user.photoUrl;
        }
        widget.phases.last = currentPhase;
        widget.phases.add(newPhase);
      }
    }

    //Updated Candidates Journey details.
    Journey journey = new Journey(journeyList: widget.phases);
    await Firestore.instance
        .collection(Constant.CANDIDATE_COLLECTION)
        .document(widget.candidateDetails.id)
        .updateData({'journey': journey.toJson()});
    StateProvider _stateProvider = StateProvider();
    _stateProvider.notify(ObserverState.STATE_TRANSFERRED);
    Navigator.of(_keyLoader.currentContext).pop();
    if (mounted) {
      setState(() {
        widget.phases = widget.phases;
        widget.uiRepresentationPhases = widget.phases.reversed.toList();
      });
    }
  }

  List<dynamic> assignTransitStates() {
    for (var i = 0; i < widget.phases.length; i++) {
      if (widget.phases[i].status == Constant.CURRENT_STATE)
        for (var j = 0; j < widget.states.length; j++) {
          States state = States.fromJson(widget.states[j]);
          if (widget.phases[i].name == state.name) return state.transitTo;
        }
    }
    return null;
  }

  Future<String> _asyncMoveStateInputDialog(
      BuildContext context,
      String stateName,
      String currentPhaseCommentHint,
      List<dynamic> allStates) async {
    String comment = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Provide Comment and choose next round'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _MoveStageAlertDialogContent(nextRounds: allStates),
              TextField(
                autofocus: false,
                decoration: new InputDecoration(
                    labelText: currentPhaseCommentHint),
                onChanged: (value) {
                  comment = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(widget.constToCancel);
              },
            ),
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(comment);
              },
            ),
          ],
        );
      },
    );
  }

  Future<User> _asyncAssignStateInputDialog(String candidateId) async {
    return showDialog<User>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        var assignStageAlertDialog = _AssignStageAlertDialogContent();
        return AlertDialog(
          title: Text('Provide select owner from the dropdown'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[assignStageAlertDialog],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            FlatButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(assignStageAlertDialog.selectedUser);
              },
            ),
          ],
        );
      },
    );
  }

  String getHintTextFromCurrentStage(String stageName) {
    for (int i = 0; i < widget.states.length; i++) {
      if (widget.states[i]['name'] == stageName) {
        return widget.states[i]['comment_hint'];
      }
    }
    return 'eg. Good to go..';
  }
}

class _MoveStageAlertDialogContent extends StatefulWidget {
  List<dynamic> nextRounds;

  _MoveStageAlertDialogContent({
    Key key,
    @required this.nextRounds,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoveStageAlertDialogState();
}

class _MoveStageAlertDialogState extends State<_MoveStageAlertDialogContent> {
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _selectedState;

  String comment = '';

  @override
  void initState() {
    super.initState();
    _dropDownMenuItems = buildAndGetDropDownMenuItems(widget.nextRounds);
    _selectedState = _dropDownMenuItems[0].value;
    Constant.nextRound.add(_selectedState);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      value: _selectedState,
      items: _dropDownMenuItems,
      onChanged: changedDropDownItem,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ),
      underline: Container(
        height: 1,
        color: Colors.grey[500],
      ),
    );
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List states) {
    List<DropdownMenuItem<String>> items = List();
    for (String state in states) {
      items.add(DropdownMenuItem(value: state, child: Text(state)));
    }
    return items;
  }

  void changedDropDownItem(String selectedRound) {
    Constant.nextRound.add(selectedRound);
    if (mounted) {
      setState(() {
        _selectedState = selectedRound;
      });
    }
  }
}

class _AssignStageAlertDialogContent extends StatefulWidget {
  User selectedUser;

  @override
  State<StatefulWidget> createState() => _AssignStageAlertDialogState();
}

class _AssignStageAlertDialogState
    extends State<_AssignStageAlertDialogContent> {
  String _selectedValue;
  List<User> _usersList;

  @override
  Widget build(BuildContext context) {
    if (_usersList == null) {
      DataRepository.getUsersList((users) {
        _usersList = users;
        if (mounted) {
          setState(() {
            widget.selectedUser = _usersList[0];
            _selectedValue = widget.selectedUser.displayName;
          });
        }
      });
    }
    return _usersList != null
        ? DropdownButton(
            isExpanded: true,
            value: _selectedValue,
            items: buildAndGetDropDownMenuItems(_usersList),
            onChanged: (String selectedUserName) {
              if (mounted) {
                setState(() {
                  _usersList.forEach((user) {
                    if (user.displayName == _selectedValue) {
                      widget.selectedUser = user;
                    }
                  });
                  _selectedValue = selectedUserName;
                });
              }
            },
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ),
            underline: Container(
              height: 1,
              color: Colors.grey[500],
            ),
          )
        : CircularProgressIndicator();
  }

  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List users) {
    List<DropdownMenuItem<String>> items = List();
    for (User user in users) {
      items.add(DropdownMenuItem(
          value: user.displayName, child: Text(user.displayName)));
    }
    return items;
  }
}
