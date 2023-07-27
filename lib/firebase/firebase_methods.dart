
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_management/stateparams/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:project_management/model/user.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create a new user
  Future<String> createUser(
      {required String email,
      required String username,
      required String password,
      required bool isManager,
      required String nameDetails,
      required String role,
      required String managerId,
      required String managerEmail}) async {
    String res = "error";
    String userId = const Uuid().v1();
    try {
      if (email != '') {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        userId = cred.user!.uid;
        managerId = userId;
      }

      CurrentUser user = CurrentUser(
          email: email,
          username: username,
          password: password,
          isManager: isManager,
          nameDetails: nameDetails,
          role: role,
          userId: userId,
          managerId: managerId,
          managerEmail: managerEmail);

      await _firestore.collection('users').doc(userId).set(user.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  //login Firebase with userId
  Future<String> loginWithUserId(
      {required String userId, required String password}) async {
    String res = "error";
    String email = "";

    try {
      var snap = await _firestore.collection("users").doc(userId).get();
      String email = snap.data()!['email'];
      if (email == "" ) email = snap.data()!["managerId"];
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  // sign out
  signOut() async {
    await _auth.signOut();
  }

  // get userId from username or email
  Future<String> getUserIdFromAccount(String account) async {
    String userId = '';

    try {
      var snap;
      if (isValidEmail(account)) {
      snap = await _firestore.collection("users").where("email", isEqualTo: account).get();
      } else {
      snap = await _firestore.collection("users").where("username", isEqualTo: account).get();
      }

      if (snap.docs.isNotEmpty) {
        userId = snap.docs.first.data()['userId'];
      }
    } catch(e) {
      print(e.toString());
    }
    return userId;
  }
}
