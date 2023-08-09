import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:project_management/firebase/storage_method.dart';
import 'package:project_management/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:project_management/model/user.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //create a new company
  Future<String> createCompany(String companyName, String companyId) async {
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
    String userId = const Uuid().v1();
    String url;
    try {
      if (email != '') {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        userId = cred.user!.uid;
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
          companyName: companyName);

      await _firestore.collection('users').doc(userId).set(user.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  //login Firebase with userId
  Future<String> loginWithUserId(
      {required String userId}) async {
    String res = "error";
    try {
      var snap = await _firestore.collection("users").doc(userId).get();
      String email = snap.data()!['email'];
      String password = snap.data()!['password'];
      if (email != "") {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      }
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
  Future<CurrentUser> getCurrentUserByUserId(String userId) async {
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
        companyName: (snap.data()!)['companyName']);
  }

  //update user profile
  Future<String> updateNameDetail(
      String userId,  String nameDetails) async {
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

  //delete user use userId
  deleteUser(String aduserId, String userId, String email, String password) {
    if (email != "") {
      loginWithUserId(userId: aduserId);
      final cred = EmailAuthProvider.credential(email: email, password: password);
      _auth.currentUser!.reauthenticateWithCredential(cred).then((value) => 
      _auth.currentUser!.delete());
      signOut();
      loginWithUserId(userId: aduserId);
    }
    _firestore.collection("users").doc(userId).delete();
  }

  

  //check state of company
  Future<int> isAlreadyCompany(String companyName) async {
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

  //change password
  Future<String> changePassword(
      String userId, String oldpassword, String newpassword) async {
    String res = "error";
    try {
      CurrentUser user = await getCurrentUserByUserId(userId);

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

  //update email if email is empty
  updateEmail(String userId, String email) async {
    CurrentUser user = await getCurrentUserByUserId(userId);
    String res = 'error';
    String res1 = await createUser(
        email: email,
        username: user.username,
        password: user.password,
        nameDetails: user.nameDetails,
        photoURL: user.photoURL,
        group: user.group,
        companyId: user.companyId,
        companyName: user.companyName);

    deleteUser(userId,userId, "", "");
    if (res1 == 'success') {
    String res2 = await loginWithUserId(userId: await getUserIdFromAccount(email));
    res = res2;
    } else {
      res = res1;
    }
    return res;
  }

  changeProfileImage(Uint8List image, String username, String userId) async {
    String res = '';
    try {
      String photoURL = await StorageMethods()
          .uploadImageToStorage('profile', username, image);
      await _firestore.collection('users').doc(userId).update({
        'photoURL': photoURL,
      });

      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  updateGroup(String companyId, String groupName) async {
    String res = "";
    try {
      await _firestore.collection('companies').doc(companyId).update({
        'group': FieldValue.arrayUnion([groupName]),
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  changeUserGroup(String userId, String group) async {
    String res = "error";
    try {
      await _firestore.collection('users').doc(userId).update({
        'group': group
      });
      res = 'success';

    } catch(e) {
      res = e.toString();
    }

    return res;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchSnapshot(
      String groupSelect) async {
    QuerySnapshot<Map<String, dynamic>> snap;
    if (groupSelect == 'Tất cả') {
      snap = await _firestore.collection('users').get();
    } else {
      snap = await _firestore
          .collection('users')
          .where('group', isEqualTo: groupSelect)
          .get();
    }

    return snap;
  }
}
