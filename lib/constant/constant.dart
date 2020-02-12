import 'package:rxdart/subjects.dart';
import 'package:line_up_tracker/model/phase.dart';
import 'package:rxdart/rxdart.dart';

class Constant {
  static const String CANDIDATE_COLLECTION = "candidate";
  static const String STATES_COLLECTION = "states";
  static const String USERS_COLLECTION = "users";
  static const String CURRENT_STATE = "current";
  static const String PASSED_STATE = "passed";
  static const String FAILED_STATE = "Failed";
  static const String CANDIDATE_SELECTED = "Candidate is selected";
  static const String CANDIDATE_REJECTED = "Candidate is rejected";
  static PublishSubject<List<Phase>> updatePhase = new PublishSubject();
  static PublishSubject<String> nextRound = new PublishSubject();
}
