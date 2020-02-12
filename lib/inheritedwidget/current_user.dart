import 'package:flutter/widgets.dart';

class CurrentUser extends InheritedWidget {

  final Map<String, dynamic> userProfile;

  CurrentUser ({
    Key key,
    @required this.userProfile,
    @required Widget child,
}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(CurrentUser profile) {
    return userProfile != profile.userProfile;
  }

  static CurrentUser of(BuildContext context){
    return context.inheritFromWidgetOfExactType(CurrentUser) as CurrentUser;
  }
}