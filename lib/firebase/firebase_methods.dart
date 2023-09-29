import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:project_management/firebase/storage_method.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/notification.dart';
import 'package:project_management/model/progress.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/model/report.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';
import 'package:project_management/model/user.dart';
import 'package:uuid/uuid.dart';

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
            .uploadImageToStorage(folderName: 'profile', username : username,image: image);
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
          notifyNumber: 0,
          reportNumber: 0,
          timekeeping: {});

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
        timekeeping: (snap.data()!)['timekeeping'],
        email: (snap.data()!)['email'],
        username: (snap.data()!)['username'],
        password: (snap.data()!)['password'],
        nameDetails: (snap.data()!)['nameDetails'],
        photoURL: (snap.data()!)['photoURL'],
        group: (snap.data()!)['group'],
        userId: (snap.data()!)['userId'],
        companyId: (snap.data()!)['companyId'],
        companyName: (snap.data()!)['companyName'],
        notifyNumber: (snap.data()!)['notifyNumber'],
        reportNumber: (snap.data()!)['reportNumber']);
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
          .uploadImageToStorage(folderName: 'profile', username: user.username, image: image);
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
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    String res = 'error';
    try {
      CurrentUser user =
          await getCurrentUserByUserId(userId: _auth.currentUser!.uid);
      Project project = Project(
          companyId: user.companyId,
          projectId: projectId,
          nameProject: nameProject,
          description: description,
          createDate: DateTime.now(),
          startDate: startDate,
          endDate: endDate);
      await _firestore
          .collection('companies')
          .doc(user.companyId)
          .collection('projects')
          .doc(projectId)
          .set(project.toJson());

      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> deleteProject(
      {required String companyId, required String projectId}) async {
    String res = 'error';
    try {
      await _firestore
          .collection('companies')
          .doc(companyId)
          .collection('projects')
          .doc(projectId)
          .delete();
      res = 'success';
    } catch (er) {
      res = er.toString();
    }
    return res;
  }

  Future<String> updateProject(
      {required Project project,
      required String nameProject,
      required String description,
      required DateTime startDate,
      required DateTime endDate}) async {
    String res = 'error';
    try {
      await _firestore
          .collection('companies')
          .doc(project.companyId)
          .collection('projects')
          .doc(project.projectId)
          .update({
        'nameProject': nameProject,
        'description': description,
        'createDate': DateTime.now(),
        'startDate': startDate,
        'endDate': endDate,
      });

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> createMission(
      {required Project project,
      required String missionId,
      required String nameMission,
      required String description,
      required DateTime startDate,
      required DateTime endDate,
      required String staffId}) async {
    String res = 'error';
    try {
      Mission mission = Mission(
          nameProject: project.nameProject,
          companyId: project.companyId,
          projectId: project.projectId,
          missionId: missionId,
          nameMission: nameMission,
          description: description,
          createDate: DateTime.now(),
          startDate: startDate,
          endDate: endDate,
          percent: 0,
          staffId: staffId);
      await _firestore
          .collection('missions')
          .doc(missionId)
          .set(mission.toJson());

      await createNotification(
          uid: staffId, mission: mission, type: STAFF_RECIEVE_MISSION);
      res = 'success';
      if (res == 'success') {
        await _firestore
            .collection('companies')
            .doc(project.companyId)
            .collection('projects')
            .doc(project.projectId)
            .update({
          'missions': project.missions + 1,
        });
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<Mission?> getMissionInDay(
      {required String userId, required DateTime date}) async {
    try {
      var snap = await _firestore
          .collection('missions')
          .where('staffId', isEqualTo: userId)
          .get();
      var docs = snap.docs;
      docs.removeWhere((element) {
        DateTime startDate = element['startDate'].toDate();
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        DateTime endDate = element['endDate'].toDate();
        endDate = DateTime(endDate.year, endDate.month, endDate.day);

        return (date.isBefore(startDate) || date.isAfter(endDate));
      });

      if (docs.isNotEmpty) {
        return Mission.fromSnap(mission: docs.first);
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<String> updateMission(
      {required Mission mission,
      required String nameMission,
      required String description,
      required String staffId,
      required DateTime startDate,
      required DateTime endDate}) async {
    String res = 'error';
    try {
      await _firestore.collection('missions').doc(mission.missionId).update({
        'nameMission': nameMission,
        'description': description,
        'staffId': staffId,
        'startDate': startDate,
        'endDate': endDate,
        'createDate': DateTime.now(),
      });
      if (staffId != mission.staffId) {
        await createNotification(
            uid: staffId,
            mission: mission,
            type: STAFF_RECIEVE_MISSION_FROM_OTHER);
        await createNotification(
            uid: mission.staffId, mission: mission, type: MISSION_CHANGE_STAFF);
      } else {
        await createNotification(
          uid: mission.staffId,
          mission: mission,
          type: MISSION_IS_CHANGED,
        );
      }
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updatePercentMission(
      {required String missionId, required double percent}) async {
    String res = 'error';
    try {
      var snap = await _firestore.collection('missions').doc(missionId).get();
      double percentMission = snap.data()!['percent'];
      if (percentMission <= percent) {
        await _firestore
            .collection('missions')
            .doc(missionId)
            .update({'percent': percent});
      }
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deleteMission({required Mission mission}) async {
    String res = 'error';
    try {
      _firestore.collection('missions').doc(mission.missionId).delete();

      var snap = await _firestore
          .collection('companies')
          .doc(mission.companyId)
          .collection('projects')
          .doc(mission.projectId)
          .get();
      int missions = snap.data()!['missions'];
      await _firestore
          .collection('companies')
          .doc(mission.companyId)
          .collection('projects')
          .doc(mission.projectId)
          .update({
        'missions': missions - 1,
      });
      await createNotification(
          uid: mission.staffId, mission: mission, type: MISSION_IS_DELETED);

      res = 'success';
    } catch (er) {
      res = er.toString();
    }
    return res;
  }

  Future<String> updateMissionProgress({
    required String missionId,
    required String description,
    required double percent,
    required String date,
    int state = IS_DOING,
  }) async {
    String res = "error";
    try {
      Progress progress = Progress(
          createDate: DateTime.now(),
          date: date,
          description: description,
          state: IS_DOING,
          missionId: missionId,
          percent: percent);
      await _firestore
          .collection('missions')
          .doc(missionId)
          .collection('progress')
          .doc(date)
          .set(progress.toJson());
      if (state == IS_SUBMIT) {
        var snap = await _firestore
            .collection('missions')
            .doc(progress.missionId)
            .get();
        Mission mission = Mission.fromSnap(mission: snap);
        CurrentUser user =
            await getCurrentUserByUserId(userId: mission.staffId);
        createNotification(
            mission: mission,
            type: STAFF_COMPLETE_MISSION,
            group: manager,
            description: description,
            username: user.nameDetails,
            percent: percent);
      }
      res = await updatePercentMission(missionId: missionId, percent: percent);
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> changeStateProgress(
      {required Progress progress, int state = IS_DOING}) async {
    String res = 'error';
    try {
      var snap =
          await _firestore.collection('missions').doc(progress.missionId).get();
      Mission mission = Mission.fromSnap(mission: snap);
      await _firestore
          .collection('missions')
          .doc(progress.missionId)
          .collection('progress')
          .doc(progress.date)
          .update({'state': state});
      if (state == IS_DOING) {
        createNotification(
            uid: mission.staffId, mission: mission, type: MISSION_IS_OPEN);
        res = 'success';
      } else {
        createNotification(
            uid: mission.staffId,
            mission: mission,
            type: MANAGER_APPROVE_PROGRESS);
        res = await updateTimeKeeping(
            userId: mission.staffId, date: progress.date, state: state);
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateTimeKeeping(
      {required String userId,
      required String date,
      required int state}) async {
    String res = "error";
    try {
      await _firestore.collection('users').doc(userId).update({
        'timekeeping.$date': state,
      });
      if (state != IS_CLOSING) {
        createNotification(
            type: TIME_KEEPING, date: date, uid: userId, state: state);
      }
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> refreshNotifyNumber() async {
    String res = "error";
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'notifyNumber': 0});
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> imclementNotifyNumber({required String uid}) async {
    var snap = await _firestore.collection('users').doc(uid).get();
    int number = snap.data()!['notifyNumber'];
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'notifyNumber': number + 1});
  }

  Future<void> createNotification(
      {int state = 0,
      String date = "",
      String? uid,
      Mission? mission,
      required int type,
      String? group,
      String username = "",
      String description = "",
      double percent = 0}) async {
    if (group != null) {
      var snapshot = await _firestore
          .collection('users')
          .where('group', isEqualTo: group)
          .get();
      snapshot.docs.forEach((element) async {
        String userId = (element as dynamic)['userId'];
        String notifyId = const Uuid().v1();

        Notify? notification = Notify.getNotify(
            percent: percent,
            nameDetails: username,
            description: description,
            notifyId: notifyId,
            isRead: (type == MISSION_IS_DELETED || type == TIME_KEEPING),
            missionId: (mission == null) ? "" : mission.missionId,
            nameMission: (mission == null) ? "" : mission.nameMission,
            nameProject: (mission == null) ? "" : mission.nameProject,
            userId: userId,
            createDate: DateTime.now(),
            type: type);
        if (notification != null) {
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('notifications')
              .doc(notifyId)
              .set(notification.toJson());
          imclementNotifyNumber(uid: userId);
        }
      });
    } else {
      String notifyId = const Uuid().v1();
      Notify? notification = Notify.getNotify(
          state: state,
          date: date,
          percent: percent,
          nameDetails: username,
          description: description,
          notifyId: notifyId,
          isRead: (type == MISSION_IS_DELETED || type == TIME_KEEPING),
          missionId: (mission == null) ? "" : mission.missionId,
          nameMission: (mission == null) ? "" : mission.nameMission,
          nameProject: (mission == null) ? "" : mission.nameProject,
          userId: uid!,
          createDate: DateTime.now(),
          type: type);
      if (notification != null) {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('notifications')
            .doc(notifyId)
            .set(notification.toJson());

        imclementNotifyNumber(uid: uid);
      }
    }
  }

  Future<String> deleteNotification({required Notify notify}) async {
    String res = 'error';
    try {
      await _firestore
          .collection('users')
          .doc(notify.userId)
          .collection('notifications')
          .doc(notify.notifyId)
          .delete();
      res = 'success';
    } catch (er) {
      res = er.toString();
    }
    return res;
  }

  Future<String> refreshReportNumber() async {
    String res = "error";
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'reportNumber': 0});
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<void> imclementReportNumber({required String uid}) async {
    var snap = await _firestore.collection('users').doc(uid).get();
    int number = snap.data()!['reportNumber'];

    await _firestore
        .collection('users')
        .doc(uid)
        .update({'reportNumber': number + 1});
  }

  Future<String> createReport({
    required String nameReport,
    required int type,
    required String description,
    required List<Uint8List> imageList,
  }) async {
    String res = 'error';
    try {
      String reportId = const Uuid().v1();
      CurrentUser user =
          await getCurrentUserByUserId(userId: _auth.currentUser!.uid);
      List photoURL = [];
      if (imageList.isNotEmpty) {
        for (int i = 0; i < imageList.length; i++) {
          String url = await StorageMethods().uploadImageToStorage(
              folderName: 'reports',
              username: user.username,
              imageReport: const Uuid().v1(),
              image: imageList[i]);
          photoURL.add(url);
        }
      }
      Report report = Report(
          ownPhotoURL: user.photoURL,
          type: type,
          companyId: user.companyId,
          ownId: user.userId,
          createDate: DateTime.now(),
          nameReport: nameReport,
          description: description,
          photoURL: photoURL,
          reportId: reportId,
          ownRead: true,
          managerRead: false);
      _firestore
          .collection('companies')
          .doc(user.companyId)
          .collection('reports')
          .doc(reportId)
          .set(report.toJson());

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
