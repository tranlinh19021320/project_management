import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_management/utils/utils.dart';
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
    try {
      var snap = await _firestore.collection("users").doc(userId).get();
      String email = snap.data()!['email'];
      if (email == "") await _auth.signInAnonymously();
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

  Future<CurrentUser> getCurrentUserByUserId(String userId) async {
    var snap = await _firestore.collection("users").doc(userId).get();
    return CurrentUser(
        email: (snap.data()!)['email'],
        username: (snap.data()!)['username'],
        password: (snap.data()!)['password'],
        isManager: (snap.data()!)['isManager'],
        nameDetails: (snap.data()!)['nameDetails'],
        role: (snap.data()!)['role'],
        userId: (snap.data()!)['userId'],
        managerId: (snap.data()!)['managerId'],
        managerEmail: (snap.data()!)['managerEmail']);
  }

  //update user profile
  Future<String> updateProfile(
      String userId, String email, String nameDetails) async {
    String res = "error";

    try {
      await _firestore.collection("users").doc(userId).update({
        'email': email,
        'nameDetails': nameDetails,
      });
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // get userId from username or email
  Future<String> getUserIdFromAccount(String account) async {
    String userId = '';

    try {
      QuerySnapshot<Map<String, dynamic>> snap;
      if (isValidEmail(account)) {
        snap = await _firestore
            .collection("users")
            .where("email", isEqualTo: account)
            .get();
      } else {
        snap = await _firestore
            .collection("users")
            .where("username", isEqualTo: account)
            .get();
      }

      if (snap.docs.isNotEmpty) {
        userId = snap.docs.first.data()['userId'];
      }
    } catch (e) {
      print(e.toString());
    }
    return userId;
  }

  deleteUser(String userId) {
    _firestore.collection("users").doc(userId).delete();
  }

  // check state of email text field
  Future<int> checkAlreadyEmail(String email) async {
    int state = IS_DEFAULT_STATE;
    if (email == "") {
      state = IS_DEFAULT_STATE;
    } else if (!isValidEmail(email)) {
      // email is invalid format
      state = IS_ERROR_FORMAT_STATE;
    } else {
      String userId = await FirebaseMethods().getUserIdFromAccount(email);

      if (userId == "") {
        // email not registered yet
        state = IS_CORRECT_STATE;
      } else {
        // email registered
        state = IS_ERROR_STATE;
      }
    }
    return state;
  }

  // check state of account text field
  Future<int> checkAlreadyAccount(String username) async {
    int state = IS_DEFAULT_STATE;
    if (username == "") {
      state = IS_DEFAULT_STATE;
    } else {
      String userId = await FirebaseMethods().getUserIdFromAccount(username);

      if (userId == "") {
        //username not registered yet
        state = IS_CORRECT_STATE;
      } else {
        //username registered
        state = IS_ERROR_STATE;
      }
    }
    return state;
  }

  Future<String> changePassword(String userId, String oldpassword, String newpassword) async {
    String res = "error";
    try {
      CurrentUser user = await getCurrentUserByUserId(userId);
      
      await _firestore
          .collection("users")
          .doc(userId)
          .update({'password': newpassword});
          
      if (user.email != '') {
        final cred = EmailAuthProvider.credential(email: user.email, password: oldpassword);
        _auth.currentUser!.reauthenticateWithCredential(cred).then((value) {
          _auth.currentUser!.updatePassword(newpassword).then((value) {
            res ="success";
          }).catchError((onError) {
            res = onError.toString();
          });
        }).catchError((onError) {
          res = onError.toString();
        });
        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  updateEmail(String userId, String email) async {
    CurrentUser user = await getCurrentUserByUserId(userId);
    createUser(
        email: email,
        username: user.username,
        password: user.password,
        isManager: user.isManager,
        nameDetails: user.nameDetails,
        role: user.role,
        managerId: user.managerId,
        managerEmail: user.managerEmail);

    deleteUser(userId);
  }
}
