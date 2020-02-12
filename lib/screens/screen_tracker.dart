import 'package:flutter_widgets/src/visibility_detector/src/visibility_detector.dart';

class ScreenTracker {
  static final ScreenTracker _singleton = ScreenTracker._internal();

  Screen _currentScreen = Screen.UNKNOWN;

  static final VISIBLE_FRACTION = 1.0;

  factory ScreenTracker() {
    return _singleton;
  }

  ScreenTracker._internal();

  static ScreenTracker getInstance() {
    return _singleton;
  }

  void onScreen(Screen screen, VisibilityInfo info) {
    if (info != null &&
        info.visibleFraction == ScreenTracker.VISIBLE_FRACTION) {
      _currentScreen = screen;
      print("ScreenTracker : $screen");
    }
  }

  Screen getCurrentScreen() {
    return _currentScreen;
  }
}

enum Screen {
  HOME,
  ADD_PROFILE,
  CANDIDATE_DETAILS,
  ACTION_ITEMS,
  SETTINGS,
  UNKNOWN
}
