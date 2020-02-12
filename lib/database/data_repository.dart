import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:line_up_tracker/constant/constant.dart';
import 'package:line_up_tracker/model/user.dart';

class DataRepository {
  static void getStateList(Function(dynamic) onDataFunc) {
    Firestore.instance
        .collection(Constant.STATES_COLLECTION)
        .snapshots(includeMetadataChanges: false)
        .listen((onData) {
      onDataFunc(onData.documents.map((DocumentSnapshot docSnapshot) {
        return docSnapshot.data;
      }).toList());
    });
  }

  static void getCandidateList(Function(dynamic) onDataFunc) {
    Firestore.instance
        .collection(Constant.CANDIDATE_COLLECTION)
        .where("isActive", isEqualTo: true)
        .snapshots(includeMetadataChanges: false)
        .listen((onData) {
      onDataFunc(onData.documents.map((DocumentSnapshot docSnapshot) {
        return docSnapshot.data;
      }).toList());
    });
  }

  static void getCandidateDetails(
      String candidateId, bool listen, Function(dynamic) onDataFunc) {
    DocumentReference documentReference = Firestore.instance
        .collection(Constant.CANDIDATE_COLLECTION)
        .document(candidateId);

    if (listen) {
      documentReference
        ..snapshots(includeMetadataChanges: false).listen((onData) {
          onDataFunc(onData.data);
        });
    } else {
      documentReference.get().then((onData) {
        onDataFunc(onData.data);
      });
    }
  }

  static void updateDueDateCandidate(
      String candidateId, int timestamp, Function(dynamic) onDataFunc) {
    // get candidate information first
    getCandidateDetails(candidateId, false, (candidate) {
      var journeyList = candidate['journey'];
      if (journeyList != null) {
        for (int i = 0; i < journeyList.length; i++) {
          var journey = journeyList[i];
          if (journey['status'] == Constant.CURRENT_STATE) {
            journey['due_date'] = timestamp;
            updateCandidateDetails(candidateId, candidate, onDataFunc);
          }
        }
      }
    });
  }

  static void getUsersList(Function(dynamic) onDataFunc) {
    Firestore.instance
        .collection(Constant.USERS_COLLECTION)
        .getDocuments()
        .then((querySnapshot) {
      List<User> users =
          querySnapshot.documents.map((DocumentSnapshot documentSnapshot) {
        return User.fromJson(documentSnapshot.data);
      }).toList();
      onDataFunc(users);
    });
  }

  static void updateAssignStageOwner(
      String candidateId, User newOwner, Function(dynamic) onDataFunc) {
    getCandidateDetails(candidateId, false, (candidate) {
      var journeyList = candidate['journey'];
      if (journeyList != null) {
        for (int i = 0; i < journeyList.length; i++) {
          var journey = journeyList[i];
          if (journey['status'] == Constant.CURRENT_STATE) {
            journey['owner'] = newOwner.displayName;
            journey['owner_email_id'] = newOwner.email;
            updateCandidateDetails(candidateId, candidate, onDataFunc);
          }
        }
      }
    });
  }

  static void updateCandidateDetails(
      String candidateId, dynamic candidate, Function(dynamic) onDataFunc) {
    Firestore.instance
        .collection(Constant.CANDIDATE_COLLECTION)
        .document(candidateId)
        .updateData(candidate)
        .then((onData) {
      onDataFunc(true);
    });
  }
}
