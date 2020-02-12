class States {
  String name;
  String owner;
  int dueTime;
  String ownerEmail;
  List<dynamic> transitTo;

  States({
    this.name,
    this.owner,
    this.dueTime,
    this.ownerEmail,
    this.transitTo,
  });

  States.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    dueTime = json['due_time'];
    ownerEmail = json['owner_email'];
    transitTo = json['transit_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['due_time'] = this.dueTime;
    data['owner_email'] = this.ownerEmail;
    data['transit_to'] = this.transitTo;
    return data;
  }
}
