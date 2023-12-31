import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:project_management/firebase/storage_method.dart';
import 'package:project_management/model/comment.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/notification.dart';
import 'package:project_management/model/progress.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/model/report.dart';
import 'package:project_management/model/title.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
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
        ByteData dataImage = await rootBundle.load(defaultProfileImagePath);
        Uint8List image = dataImage.buffer.asUint8List();
        url = await StorageMethods().uploadImageToStorage(
            folderNamev1: 'profile', folderNamev2: username, image: image);
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

  // get user List
  Future<List<CurrentUser>> getCurrentUserList(
      {List<String>? userIdList}) async {
    List<CurrentUser> currentUserList = [];
    if (userIdList != null) {
      userIdList.forEach((element) async {
        currentUserList.add(await getCurrentUserByUserId(userId: element));
      });
    } else {
      var snap = await _firestore
          .collection('users')
          .where('group', isNotEqualTo: manager)
          .get();
      for (var element in snap.docs) {
        currentUserList.add(CurrentUser(
            timekeeping: (element.data())['timekeeping'],
            email: (element.data())['email'],
            username: (element.data())['username'],
            password: (element.data())['password'],
            nameDetails: (element.data())['nameDetails'],
            photoURL: (element.data())['photoURL'],
            group: (element.data())['group'],
            userId: (element.data())['userId'],
            companyId: (element.data())['companyId'],
            companyName: (element.data())['companyName'],
            notifyNumber: (element.data())['notifyNumber'],
            reportNumber: (element.data())['reportNumber']));
      }
    }

    return currentUserList;
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
      String photoURL = await StorageMethods().uploadImageToStorage(
          folderNamev1: 'profile', folderNamev2: user.username, image: image);
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

  // type = 0 => all report
  // type = 1 => own report
  // type = 2 => share report
  Stream<QuerySnapshot<Map<String, dynamic>>> reportSnapshot(
      {required String companyId, required int type}) {
    String userId = _auth.currentUser!.uid;
    switch (type) {
      case 1:
        return _firestore
            .collection('companies')
            .doc(companyId)
            .collection('reports')
            .where('ownId', isEqualTo: userId)
            .orderBy('createDate', descending: true)
            .snapshots();
      case 2:
        return _firestore
            .collection('companies')
            .doc(companyId)
            .collection('reports')
            .where('member', arrayContains: userId)
            .orderBy('createDate', descending: true)
            .snapshots();
      default:
        return _firestore
            .collection('companies')
            .doc(companyId)
            .collection('reports')
            .orderBy('createDate', descending: true)
            .snapshots();
    }
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

  Future<String> createTitle(
      {required Project project, required String titleContent}) async {
    String res = 'error';
    try {
      String titleId = const Uuid().v1();
      TitleProject title = TitleProject(
        companyId: project.companyId,
        projectId: project.projectId,
        titleId: titleId,
        title: titleContent,
        createDate: DateTime.now(),
        startDate: DateTime.now(),
        endDate: DateTime.now(),
      );
      await _firestore
          .collection('companies')
          .doc(project.companyId)
          .collection('projects')
          .doc(project.projectId)
          .collection('title')
          .doc(titleId)
          .set(title.toJson());
      var snap = await _firestore
          .collection('companies')
          .doc(project.companyId)
          .collection('projects')
          .doc(project.projectId)
          .get();
      int numberTitle = snap.data()!['title'];
      await _firestore
          .collection('companies')
          .doc(project.companyId)
          .collection('projects')
          .doc(project.projectId)
          .update({
        'title': numberTitle + 1,
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateTitleContent(
      {required TitleProject titleProject,
      required String titleContent}) async {
    String res = 'error';

    try {
      await _firestore
          .collection('companies')
          .doc(titleProject.companyId)
          .collection('projects')
          .doc(titleProject.projectId)
          .collection('title')
          .doc(titleProject.titleId)
          .update({
        'title': titleContent,
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> deleteTitle(
      {required TitleProject titleProject}) async {
    String res = 'error';

    try {
      await _firestore
          .collection('companies')
          .doc(titleProject.companyId)
          .collection('projects')
          .doc(titleProject.projectId)
          .collection('title')
          .doc(titleProject.titleId)
          .delete();
      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  

  Future<String> createMission(
      {required Project project,
      required TitleProject title,
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
          titleId: title.titleId,
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
      DateTime startTitle = startDate;
      DateTime endTitle = endDate;
      if (title.missions != 0) {
        if (title.startDate.isBefore(startDate)) startTitle = title.startDate;
        if (title.endDate.isAfter(endDate)) startTitle = title.endDate;
      }
      await _firestore
          .collection('companies')
          .doc(title.companyId)
          .collection('projects')
          .doc(title.projectId)
          .collection('title')
          .doc(title.titleId)
          .update({
        'startDate': startTitle,
        'endDate': endTitle,
      });
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
        'missions': missions + 1,
      });
      var snapshot = await _firestore
          .collection('companies')
          .doc(mission.companyId)
          .collection('projects')
          .doc(mission.projectId)
          .collection('title')
          .doc(mission.titleId)
          .get();
      int missionsTitle = snapshot.data()!['missions'];
      await _firestore
          .collection('companies')
          .doc(mission.companyId)
          .collection('projects')
          .doc(mission.projectId)
          .collection('title')
          .doc(mission.titleId)
          .update({
        'missions': missionsTitle + 1,
      });
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
      docs.removeWhere((element) => !dateInTime(
          startDate: element['startDate'].toDate(),
          endDate: element['endDate'].toDate(),
          date: date));

      if (docs.isNotEmpty) {
        return Mission.fromSnap(doc: docs.first);
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
      var snap = await _firestore
          .collection('companies')
          .doc(mission.companyId)
          .collection('projects')
          .doc(mission.projectId)
          .collection('title')
          .doc(mission.titleId).get();
      TitleProject title = TitleProject.fromSnap(doc: snap);
      DateTime startTitle = startDate;
      DateTime endTitle = endDate;
      if (title.missions != 0) {
        if (title.startDate.isBefore(startDate)) startTitle = title.startDate;
        if (title.endDate.isAfter(endDate)) startTitle = title.endDate;
      }
      await _firestore
          .collection('companies')
          .doc(title.companyId)
          .collection('projects')
          .doc(title.projectId)
          .collection('title')
          .doc(title.titleId)
          .update({
        'startDate': startTitle,
        'endDate': endTitle,
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
      var snapshot = await _firestore
          .collection('companies')
          .doc(mission.companyId)
          .collection('projects')
          .doc(mission.projectId)
          .collection('title')
          .doc(mission.titleId)
          .get();
      int missionsTitle = snapshot.data()!['missions'];
      await _firestore
          .collection('companies')
          .doc(mission.companyId)
          .collection('projects')
          .doc(mission.projectId)
          .collection('title')
          .doc(mission.titleId)
          .update({
        'missions': missionsTitle - 1,
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
    required List<Uint8List> imageList,
  }) async {
    String res = "error";

    try {
      CurrentUser user =
          await getCurrentUserByUserId(userId: _auth.currentUser!.uid);
      List photoURL = [];
      if (imageList.isNotEmpty) {
        for (int i = 0; i < imageList.length; i++) {
          String url = await StorageMethods().uploadImageToStorage(
              folderNamev1: 'progress',
              folderNamev2: user.username,
              folderNamev3: const Uuid().v1(),
              image: imageList[i]);
          photoURL.add(url);
        }
      }
      Progress progress = Progress(
          createDate: DateTime.now(),
          date: date,
          description: description,
          state: IS_DOING,
          missionId: missionId,
          percent: percent,
          imageList: photoURL);
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
        Mission mission = Mission.fromSnap(doc: snap);
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
      Mission mission = Mission.fromSnap(doc: snap);
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
      Report? report,
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
          nameReport: (report == null) ? '' : report.nameReport,
          isRead: (type == MISSION_IS_DELETED ||
              type == TIME_KEEPING ||
              type == INVITE_REPORT),
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

  // type = 0 => manager send all other
  // type = 1 => send to other & manager
  Future<void> imclementReportNumber({
    int type = 0,
    required Report report,
  }) async {
    String currentUserId = _auth.currentUser!.uid;
    List member = report.member;
    member.add(report.ownId);

    if (type == 0) {
    } else {
      if (member.contains(currentUserId)) member.remove(currentUserId);
      var snapshot = await _firestore
          .collection('users')
          .where('group', isEqualTo: manager)
          .get();
      snapshot.docs.forEach((element) async {
        String userId = (element as dynamic)['userId'];
        member.add(userId);
      });
    }

    member.forEach((element) async {
      var snapshot = await _firestore.collection('users').doc(element).get();
      int number = (snapshot.data()! as dynamic)['reportNumber'];
      await _firestore.collection('users').doc(element).update({
        'reportNumber': number + 1,
      });
    });
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
              folderNamev1: 'reports',
              folderNamev2: user.username,
              folderNamev3: const Uuid().v1(),
              image: imageList[i]);
          photoURL.add(url);
        }
      }
      Report report = Report(
          ownName: user.nameDetails,
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
          managerRead: false,
          member: []);
      _firestore
          .collection('companies')
          .doc(user.companyId)
          .collection('reports')
          .doc(reportId)
          .set(report.toJson());
      imclementReportNumber(
        report: report,
        type: 1,
      );
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateMemberReport({
    required Report report,
    required String userId,
  }) async {
    String res = 'error';
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('companies')
          .doc(report.companyId)
          .collection('reports')
          .doc(report.reportId)
          .get();
      List member = (snapshot.data()! as dynamic)['member'];
      await _firestore
          .collection('companies')
          .doc(report.companyId)
          .collection('reports')
          .doc(report.reportId)
          .update((member.contains(userId))
              ? {
                  'member': FieldValue.arrayRemove([userId]),
                }
              : {
                  'member': FieldValue.arrayUnion([userId]),
                });
      if (!member.contains(userId)) {
        createNotification(
            type: INVITE_REPORT,
            report: report,
            username: report.ownName,
            uid: userId);
      }
      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> changeIsReadReportState(
      {required Report report,
      required bool isManager,
      required bool isRead}) async {
    String res = 'error';
    try {
      _firestore
          .collection('companies')
          .doc(report.companyId)
          .collection('reports')
          .doc(report.reportId)
          .update((isManager) ? {"managerRead": isRead} : {'ownRead': isRead});
      res = 'success';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> postComment(
      {required Report report,
      String comment = '',
      Uint8List? imageFile}) async {
    String res = 'error';
    try {
      CurrentUser user =
          await getCurrentUserByUserId(userId: _auth.currentUser!.uid);
      String commentId = const Uuid().v1();
      String photoComment = '';
      if (imageFile != null) {
        photoComment = await StorageMethods().uploadImageToStorage(
            folderNamev1: 'comments',
            folderNamev2: report.reportId,
            folderNamev3: const Uuid().v1(),
            image: imageFile);
      }
      CommentReport commentReport = CommentReport(
          commentId: commentId,
          companyId: report.companyId,
          reportId: report.reportId,
          createDate: DateTime.now(),
          ownId: user.userId,
          isManager: (user.group == manager),
          ownName: user.nameDetails,
          photoURL: user.photoURL,
          photoComment: photoComment,
          comment: comment);
      await _firestore
          .collection('companies')
          .doc(report.companyId)
          .collection('reports')
          .doc(report.reportId)
          .collection('comments')
          .doc(commentId)
          .set(commentReport.toJson());
      await _firestore
          .collection('companies')
          .doc(report.companyId)
          .collection('reports')
          .doc(report.reportId)
          .update({
        'createDate': DateTime.now(),
      });
      if (user.group == manager) {
        imclementReportNumber(report: report, type: 0);
      } else {
        imclementReportNumber(report: report, type: 1);
      }
      changeIsReadReportState(
          report: report, isManager: !(user.group == manager), isRead: false);
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
