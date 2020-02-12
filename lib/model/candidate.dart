import 'package:line_up_tracker/model/journey.dart';

class CandidateItem {
  String id;
  String name;
  String mobno, mobno1, mobno2;
  String email;
  String skill;
  String currentCompany;
  String noticePeriod;
  String ticket;
  String gender;
  var journey;
  bool isActive;
  int timeDifference = 0;

  CandidateItem(
      {this.id,
      this.name,
      this.mobno,
      this.mobno1,
      this.mobno2,
      this.email,
      this.skill,
      this.currentCompany,
      this.noticePeriod,
      this.ticket,
      this.gender,
      this.journey,
      this.isActive});

  CandidateItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobno = json['mobno'];
    mobno1 = json['mobno1'];
    mobno2 = json['mobno2'];
    email = json['email'];
    skill = json['skill'];
    currentCompany = json['currentCompany'];
    noticePeriod = json['noticePeriod'];
    ticket = json['ticket'];
    gender = json['gender'];
    isActive = json['isActive'];
    journey =
        json['journey'] != null ? new Journey.fromJson(json['journey']) : null;
    timeDifference = json['timeDifference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobno'] = this.mobno;
    data['mobno1'] = this.mobno1;
    data['mobno2'] = this.mobno2;
    data['email'] = this.email;
    data['skill'] = this.skill;
    data['currentCompany'] = this.currentCompany;
    data['noticePeriod'] = this.noticePeriod;
    data['ticket'] = this.ticket;
    data['gender'] = this.gender;
    if (this.journey != null) {
      data['journey'] = this.journey.toJson();
    }
    data['isActive'] = this.isActive;
    data['timeDifference'] = this.timeDifference;
    return data;
  }

  CandidateItem.updatedFromJson(Map<String, dynamic> json, isActive) {
    id = json['id'];
    name = json['name'];
    mobno = json['mobno'];
    mobno1 = json['mobno1'];
    mobno2 = json['mobno2'];
    email = json['email'];
    skill = json['skill'];
    currentCompany = json['currentCompany'];
    noticePeriod = json['noticePeriod'];
    ticket = json['ticket'];
    gender = json['gender'];
    isActive = isActive;
    journey =
        json['journey'] != null ? new Journey.fromJson(json['journey']) : null;
    timeDifference = json['timeDifference'];
  }
}
