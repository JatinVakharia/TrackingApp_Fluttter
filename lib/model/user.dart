
class User {
  String uid;
  String email;
  String photoUrl;
  String displayName;
  int lastSeen;

  User({
    this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
    this.lastSeen,
  });

  User.fromJson(Map<dynamic, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    photoUrl = json['photoURL'];
    displayName = json['displayName'];
    lastSeen = json['lastSeen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.uid;
    data['email'] = this.email;
    data['photoURL'] = this.photoUrl;
    data['displayName'] = this.displayName;
    data['lastSeen'] = this.lastSeen;
    return data;
  }
}
