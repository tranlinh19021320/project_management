import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:project_management/firebase/storage_method.dart';
import 'package:project_management/utils/utils.dart';
import 'package:project_management/model/user.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //create a new company
  Future<String> createCompany(
      {required String companyName, required String companyId}) async {
    String res = "";
    try {
      await _firestore.collection("companies").doc(companyId).set({
        'companyId': companyId,
        'companyName': companyName,
        'group': [
          manager,
        ]
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // create a new user
  Future<String> createUser(
      {required String email,
      required String username,
      required String password,
      required String nameDetails,
      required String photoURL,
      required String group,
      required String companyId,
      required String companyName}) async {
    String res = "error";
    String url;
    String userId;
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        userId = cred.user!.uid;
      } else {
        String uid = currentUser.uid;
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        userId = cred.user!.uid;
        await loginWithUserId(userId: uid);
      }
      if (photoURL == "") {
        ByteData dataImage = await rootBundle.load(defaultProfileImage);
        Uint8List image = dataImage.buffer.asUint8List();
        url = await StorageMethods()
            .uploadImageToStorage('profile', username, image);
      } else {
        url = photoURL;
      }

      CurrentUser user = CurrentUser(
          email: email,
          username: username,
          password: password,
          nameDetails: nameDetails,
          group: group,
          photoURL: url,
          userId: userId,
          companyId: companyId,
          companyName: companyName,
          notifyNumber: 0);

      await _firestore.collection('users').doc(userId).set(user.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  //login Firebase with userId
  Future<String> loginWithUserId({required String userId}) async {
    String res = "error";
    try {
      var snap = await _firestore.collection("users").doc(userId).get();
      String email = snap.data()!['email'];
      String password = snap.data()!['password'];
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

  // get user
  Future<CurrentUser> getCurrentUserByUserId({required String userId}) async {
    var snap = await _firestore.collection("users").doc(userId).get();
    return CurrentUser(
        email: (snap.data()!)['email'],
        username: (snap.data()!)['username'],
        password: (snap.data()!)['password'],
        nameDetails: (snap.data()!)['nameDetails'],
        photoURL: (snap.data()!)['photoURL'],
        group: (snap.data()!)['group'],
        userId: (snap.data()!)['userId'],
        companyId: (snap.data()!)['companyId'],
        companyName: (snap.data()!)['companyName'],
        notifyNumber: (snap.data()!)['notifyNumber']);
  }

  //update user profile
  Future<String> updateNameDetail(
      {required String userId, required String nameDetails}) async {
    String res = "error";

    try {
      await _firestore.collection("users").doc(userId).update({
        'nameDetails': nameDetails,
      });
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // get userId from username or email
  Future<String> getUserIdFromAccount({required String account}) async {
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

  //delete user use userId
  deleteUser({required String deleteUserId}) {
    _firestore.collection("users").doc(deleteUserId).delete();
  }

  //check state of company
  Future<int> isAlreadyCompany({required String companyName}) async {
    int state = IS_DEFAULT_STATE;
    try {
      var snap = await _firestore
          .collection("companies")
          .where('companyName', isEqualTo: companyName)
          .get();

      if (snap.size == 0) {
        state = IS_CORRECT_STATE;
      } else {
        state = IS_ERROR_STATE;
      }

      if (companyName == '') {
        state = IS_DEFAULT_STATE;
      }
    } catch (e) {
      print(e.toString());
    }
    return state;
  }

  // check state of email text field
  Future<int> checkAlreadyEmail({required String email}) async {
    int state = IS_DEFAULT_STATE;
    if (email == "") {
      state = IS_DEFAULT_STATE;
    } else if (!isValidEmail(email)) {
      // email is invalid format
      state = IS_ERROR_FORMAT_STATE;
    } else {
      String userId =
          await FirebaseMethods().getUserIdFromAccount(account: email);

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
  Future<int> checkAlreadyAccount({required String username}) async {
    int state = IS_DEFAULT_STATE;
    if (username == "") {
      state = IS_DEFAULT_STATE;
    } else {
      String userId =
          await FirebaseMethods().getUserIdFromAccount(account: username);

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

  //change password
  Future<String> changePassword(
      {required String userId,
      required String oldpassword,
      required String newpassword}) async {
    String res = "error";
    try {
      CurrentUser user = await getCurrentUserByUserId(userId: userId);

      await _firestore
          .collection("users")
          .doc(userId)
          .update({'password': newpassword});

      if (user.email != '') {
        final cred = EmailAuthProvider.credential(
            email: user.email, password: oldpassword);
        _auth.currentUser!.reauthenticateWithCredential(cred).then((value) {
          _auth.currentUser!.updatePassword(newpassword).then((value) {
            res = "success";
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

  Future<String> changeProfileImage({
    required Uint8List image,
  }) async {
    String res = '';
    CurrentUser user =
        await getCurrentUserByUserId(userId: _auth.currentUser!.uid);
    try {
      String photoURL = await StorageMethods()
          .uploadImageToStorage('profile', user.username, image);
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'photoURL': photoURL,
      });

      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> addGroup(
      {required String companyId, required String groupName}) async {
    String res = "";
    try {
      var snap = await _firestore.collection('companies').doc(companyId).get();
      List groups = (snap.data()! as dynamic)['group'];
      if (!groups.contains(groupName)) {
        await _firestore.collection('companies').doc(companyId).update({
          'group': FieldValue.arrayUnion([groupName]),
        });
        res = 'success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> changeUserGroup(
      {required String userId, required String group}) async {
    String res = "error";
    try {
      await _firestore.collection('users').doc(userId).update({'group': group});
      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> searchSnapshot(
      {required String groupSelect}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snap;
    if (groupSelect == 'Tất cả') {
      snap = _firestore.collection('users').snapshots();
    } else {
      snap = _firestore
          .collection('users')
          .where('group', isEqualTo: groupSelect)
          .snapshots();
    }

    return snap;
  }

  // function to create project
  Future<String> createProject({
    required String projectId,
    required String nameProject,
    required String description,
    required String startDate,
    required String endDate,
  }) async {
    String res = 'error';
    try {
      CurrentUser user =
          await getCurrentUserByUserId(userId: _auth.currentUser!.uid);
      await _firestore
          .collection('companies')
          .doc(user.companyId)
          .collection('projects')
          .doc(projectId)
          .set({
        'projectId': projectId,
        'nameProject': nameProject,
        'description': description,
        'startDate': startDate,
        'endDate': endDate,
        'companyId': user.companyId,
      });

      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

}
