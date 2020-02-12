import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

//constructor
  AuthService() {
    setProfile();
  }

  setProfile(){
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);
    try {
      FirebaseUser user = await getCurrentUser();
      if (user == null) {
        GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        AuthResult result = await _auth.signInWithCredential(credential);

        user = result.user;
        updateUsersData(user);

        print("Signed in" + user.displayName);
        return user;
      }
    } finally {
      loading.add(false);
    }
    return null;
  }

  void updateUsersData(FirebaseUser user) async {

    DocumentReference ref = _db.collection('users').document(user.uid);
    String fcmToken = await _fcm.getToken();

    await ref.setData({

      'uid' : user.uid,
      'email' : user.email,
      'photoURL' : user.photoUrl,
      'displayName' : user.displayName,
      'lastSeen' : DateTime.now().millisecondsSinceEpoch,
      'token' : fcmToken
    } , merge: true);

    setProfile();
  }

  void signOut() {

    _auth.signOut();
  }

  Future<FirebaseUser> getCurrentUser() {
    return _auth.currentUser();
  }
}

final AuthService authService = AuthService();
