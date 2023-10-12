import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/home/widgets/missions/mission_detail.dart';
import 'package:project_management/home/widgets/missions/mission_card.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:provider/provider.dart';

class MissionsScreen extends StatefulWidget {
  final Project? project;
  const MissionsScreen({super.key, this.project});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  late bool isManager;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;
  }

  createNewMission() => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImage), fit: BoxFit.fill),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: darkblueAppbarColor,
                title: const Text('Nhiệm vụ mới'),
                centerTitle: true,
              ),
              body: MissionDetailScreen(project: widget.project!),
            ),
          )));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: (widget.project == null)
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('missions')
                  .where('staffId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .orderBy('endDate', descending: false)
                  .orderBy('startDate', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.inkDrop(
                      color: darkblueAppbarColor, size: 32);
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Bạn không có nhiệm vụ"),
                  );
                }

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => MissionCard(
                          mission: Mission.fromSnap(
                              doc: snapshot.data!.docs[index]),
                        ));
              })
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('missions')
                  .where('companyId', isEqualTo: widget.project!.companyId)
                  .where('projectId', isEqualTo: widget.project!.projectId)
                  .orderBy('endDate', descending: false)
                  .orderBy('startDate', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.inkDrop(
                      color: darkblueAppbarColor, size: 32);
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("Dự án không có nhiệm vụ"),
                  );
                }

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => MissionCard(
                          mission: Mission.fromSnap(
                              doc: snapshot.data!.docs[index]),
                        ));
              }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: (widget.project == null)
          ? null
          : FloatingActionButton(
              heroTag: "createMissionButton",
              onPressed: createNewMission,
              tooltip: "Tạo nhiệm vụ mới",
              child: const Icon(Icons.create),
            ),
    );
  }
}
