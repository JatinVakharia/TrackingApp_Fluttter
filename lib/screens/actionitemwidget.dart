import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:line_up_tracker/constant/constant.dart';
import 'package:line_up_tracker/database/data_repository.dart';
import 'package:line_up_tracker/model/actionitem.dart';
import 'package:line_up_tracker/model/candidate.dart';
import 'package:line_up_tracker/observer/generalized_observer.dart';
import 'package:line_up_tracker/screens/screen_tracker.dart';
import 'package:line_up_tracker/widget/actionitemview.dart';
import 'package:line_up_tracker/widget/emptystate.dart';

class ActionItemWidget extends StatefulWidget {
  Map<String, dynamic> user;

  ActionItemWidget(user) {
    this.user = user;
  }

  @override
  _ActionItem createState() {
    return _ActionItem();
  }
}

class _ActionItem extends State<ActionItemWidget> implements StateListener {
  List<ActionItem> actionItemList = new List();
  List<Map<dynamic, dynamic>> stateList;
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(Screen.ACTION_ITEMS.toString()),
        onVisibilityChanged: (VisibilityInfo info) {
          ScreenTracker.getInstance().onScreen(Screen.ACTION_ITEMS, info);
        },
    child: Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Action Items",
          style: TextStyle(),
        ),
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
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: actionItemList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: false,
                            itemCount: actionItemList == null
                                ? 0
                                : actionItemList.length,
                            itemBuilder: (BuildContext context, int index) {
                              ActionItem actionItem = actionItemList[index];
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ActionItemView(
                                    actionItem, stateList, widget.user),
                              );
                            },
                          )
                        : EmptyStateWidget("Hello, " +
                            widget.user["displayName"] +
                            "\n Not having any pending actions for you.\n Please check again later")),
              ),
            ),
    )
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void onStateChanged(ObserverState state) {

  }

  void getMyActionItems() {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    DataRepository.getCandidateList((candidates) {
      actionItemList.clear();
      for (var candidate in candidates) {
        List<dynamic> journeyList = candidate["journey"];
        for (var journey in journeyList) {
          if (journey["status"] == Constant.CURRENT_STATE &&
              journey["owner_email_id"] == widget.user["email"]) {
            CandidateItem candidateItem = CandidateItem.fromJson(candidate);
            actionItemList.add(ActionItem(
                name: journey["name"],
                owner: journey["owner"],
                dueTime: journey["deadline"],
                candidateItem: candidateItem));
          }
        }
      }
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  void getStateList() {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }
    DataRepository.getStateList((onData) {
      stateList = onData;
      if (mounted) {
        setState(() {
          _loading = false;
          getMyActionItems();
        });
      }
    });
  }

  void fetchData() {
    getStateList();
  }
}
