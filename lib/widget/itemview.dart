import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:line_up_tracker/constant/constant.dart';
import 'package:line_up_tracker/model/phase.dart';
import 'package:line_up_tracker/screens/candidatedetails.dart';
import 'package:line_up_tracker/screens/screen_tracker.dart';
import 'package:line_up_tracker/widget/superhero_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemView extends StatefulWidget {
  final id;
  final name;
  final email;
  final mobno;
  final mobno1;
  final mobno2;
  final gender;
  final skill;
  final currentCompany;
  final noticePeriod;
  var img;
  final journey;
  final states;
  final Map<String, dynamic> user;
  int days;
  String date;

  ItemView({
    Key key,
    @required this.id,
    @required this.name,
    @required this.email,
    @required this.mobno,
    @required this.mobno1,
    @required this.mobno2,
    @required this.skill,
    @required this.currentCompany,
    @required this.noticePeriod,
    @required this.gender,
    this.journey,
    @required this.states,
    @required this.user,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    List<Phase> phases = widget.journey.journeyList as List<Phase>;
    getDueTime(phases.last);
    Color timerColor = getTimerColor(phases.last);
    Color backgroundColor = getBackgroundColor(phases.last);
    bool status = phases.last.status == Constant.PASSED_STATE ||
        phases.last.status == Constant.FAILED_STATE;

    widget.img = widget.gender == "male" || widget.gender == "Male"
        ? "assets/images/male-240.png"
        : "assets/images/female-240.png";
    return Card(
      clipBehavior: Clip.antiAlias,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        child: InkWell(
            onTap: () {
              if (ScreenTracker.getInstance().getCurrentScreen() !=
                  Screen.CANDIDATE_DETAILS) {
                var router =
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return CandidateDetails(
                      img: widget.img,
                      id: widget.id,
                      name: widget.name,
                      email: widget.email,
                      mobno: widget.mobno,
                      mobno1: widget.mobno1,
                      mobno2: widget.mobno2,
                      gender: widget.gender,
                      skill: widget.skill,
                      currentCompany: widget.currentCompany,
                      noticePeriod: widget.noticePeriod,
                      journey: widget.journey,
                      states: widget.states,
                      user: widget.user);
                });

                Navigator.of(context).push(router);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SuperheroAvatar(img: widget.img),
                          SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${widget.name}",
                                  style: textTheme.title,
                                ),
                                Text(
                                  phases.last.status == Constant.FAILED_STATE
                                      ? Constant.CANDIDATE_REJECTED
                                      : (phases.last.status ==
                                              Constant.PASSED_STATE
                                          ? Constant.CANDIDATE_SELECTED
                                          : "${phases.last.name}"),
                                  style: textTheme.subtitle
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                      )
                                      .apply(color: Colors.black),
                                  maxLines: 2,
                                ),
                                Text(
                                  "${widget.email}",
                                  style: textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        status
                            ? SizedBox()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.timer,
                                    size: 18,
                                    color: timerColor,
                                  ),
                                  Text(
                                    "${showTime()}",
                                    style: TextStyle(
                                        color: timerColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                        Row(
                          children: <Widget>[
                            Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: InkWell(
                                  onTap: () => launch('tel:${widget.mobno}'),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.call,
                                      size: 22,
                                      color: Colors.blueAccent,
                                    ),
                                  )),
                            ),
                            SizedBox(width: 5),
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: const Color(0xff7c94b6),
                                image: DecorationImage(
                                  image: NetworkImage(getImageUrl((widget
                                          .journey.journeyList as List<Phase>)
                                      .last
                                      .ownerImageUrl)),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(50.0)),
                                border: new Border.all(
                                  color: Colors.blueAccent,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  getDueTime(Phase phase) {
    Jiffy lastMidnight = Jiffy()
      ..subtract(days: 1)
      ..startOf("day");

    DateTime dueDate = DateTime.fromMillisecondsSinceEpoch(phase.dueDate);
    Duration difference = dueDate.difference(lastMidnight.dateTime);
    widget.days = difference.inDays;
    widget.date = DateFormat("EEE, d MMM").format(dueDate);
  }

  showTime() {
    if (widget.days <= 0) {
      return widget.date;
    }
    return "${widget.days} Days (${widget.date})";
  }

  getTimerColor(Phase phase) {
    if (widget.days <= 0) {
      return Colors.red;
    } else if (widget.days > 2) {
      return Colors.black;
    } else {
      return Colors.orange;
    }
  }

  getBackgroundColor(Phase phase) {
    if (widget.days <= 0) {
      return Color(0xFFFFCDD2);
    } else if (widget.days > 0 && widget.days <= 2) {
      return Color(0xFFFFF9C4);
    } else {
      return Colors.white;
    }
  }

  String getImageUrl(String ownerImageUrl) {
    if (ownerImageUrl != null) {
      return ownerImageUrl;
    }
    return "https://cdn5.vectorstock.com/i/1000x1000/25/09/user-icon-man-profile-human-avatar-vector-10552509.jpg";
  }
}
