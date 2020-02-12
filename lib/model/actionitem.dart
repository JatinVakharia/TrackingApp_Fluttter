import 'package:line_up_tracker/model/candidate.dart';

class ActionItem {
  String name;
  String owner;
  int dueTime;
  CandidateItem candidateItem;

  ActionItem({
    this.name,
    this.owner,
    this.dueTime,
    this.candidateItem,
  });

  ActionItem.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    dueTime = json['due_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['due_time'] = this.dueTime;
    return data;
  }
}
