import 'package:line_up_tracker/model/phase.dart';

class Journey {
  var journeyList = <Phase>[];

  Journey({this.journeyList});

  Journey.fromJson(List<dynamic> json) {
    var templist = json.toList(growable: true);
    for (var i = 0; i < templist.length; i++) {
      journeyList.add(new Phase.fromJson(templist[i]));
    }
  }

  List<dynamic> toJson() {
    List<dynamic> data = new List<dynamic>(journeyList.length);
    for (var i = 0; i < journeyList.length; i++) {
      data[i] = this.journeyList[i].toJson();
    }
    return data;
  }
}
