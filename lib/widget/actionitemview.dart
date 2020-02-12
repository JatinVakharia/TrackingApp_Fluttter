import 'package:flutter/material.dart';
import 'package:line_up_tracker/model/actionitem.dart';
import 'package:line_up_tracker/model/candidate.dart';
import 'package:line_up_tracker/screens/candidatedetails.dart';
import 'package:line_up_tracker/screens/screen_tracker.dart';

class ActionItemView extends StatelessWidget {
  ActionItem actionItem;
  CandidateItem candidateItem;
  List<Map> stateList;
  Map<String, dynamic> user;

  ActionItemView(
      ActionItem actionItem, List<Map> stateList, Map<String, dynamic> user) {
    this.actionItem = actionItem;
    this.candidateItem = actionItem.candidateItem;
    this.stateList = stateList;
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
      if (ScreenTracker.getInstance().getCurrentScreen() !=
          Screen.CANDIDATE_DETAILS) {
        var img =
        candidateItem.gender == "male" || candidateItem.gender == "Male"
            ? "assets/images/male-240.png"
            : "assets/images/female-240.png";
        var router = new MaterialPageRoute(builder: (BuildContext context) {
          return CandidateDetails(
              img: img,
              id: candidateItem.id,
              name: candidateItem.name,
              email: candidateItem.email,
              mobno: candidateItem.mobno,
              mobno1: candidateItem.mobno1,
              mobno2: candidateItem.mobno2,
              gender: candidateItem.gender,
              skill: candidateItem.skill,
              currentCompany: candidateItem.currentCompany,
              noticePeriod: candidateItem.noticePeriod,
              journey: candidateItem.journey,
              states: stateList,
              user: user);
        });

        Navigator.of(context).push(router);
      }
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
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
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            actionItem.name,
                            style: textTheme.title,
                          ),
                          Expanded(
                            child: Text(
                              candidateItem.name != null
                                  ? candidateItem.name
                                  : "Unknown",
                              style: textTheme.subtitle.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
