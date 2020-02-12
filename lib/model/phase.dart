class Phase {
  String name;
  String owner;
  int turnaround_time;
  String passed_by;
  int passed_on;
  String status;
  String comment;
  String ownerImageUrl;
  String ownerEmailID;
  int started_on;
  int dueDate;

  Phase(
      {this.name,
      this.owner,
      this.turnaround_time,
      this.passed_by,
      this.passed_on,
      this.status,
      this.comment,
      this.ownerImageUrl,
      this.ownerEmailID,
      this.started_on,
      this.dueDate}
      );

  Phase.fromJson(Map<dynamic, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    turnaround_time = json['turnaround_time'];
    passed_by = json['passed_by'];
    passed_on = json['passed_on'];
    status = json['status'];
    comment = json['comment'];
    ownerImageUrl = json['owner_image_url'];
    ownerEmailID = json['owner_email_id'];
    started_on = json['started_on'];
    dueDate = json['due_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['owner'] = this.owner;
    data['turnaround_time'] = this.turnaround_time;
    data['passed_by'] = this.passed_by;
    data['passed_on'] = this.passed_on;
    data['status'] = this.status;
    data['comment'] = this.comment;
    data['owner_image_url'] = this.ownerImageUrl;
    data['owner_email_id'] = this.ownerEmailID;
    data['started_on'] = this.started_on;
    data['due_date'] = this.dueDate;
    return data;
  }
}
