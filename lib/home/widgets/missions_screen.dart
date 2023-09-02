import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/home/admin/utils/mission_detail.dart';
import 'package:project_management/home/widgets/mission.dart';
import 'package:project_management/home/widgets/mission_card.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: (widget.project == null)
          ? Container()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('missions')
                  .where('companyId', isEqualTo: widget.project!.companyId)
                  .where('projectId', isEqualTo: widget.project!.projectId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.inkDrop(color: darkblueAppbarColor, size: 32);
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Dự án không có nhiệm vụ"),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => MissionHomeScreen(project: widget.project!,mission: Mission.fromSnap(mission: snapshot.data!.docs[index]),));
              }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: (widget.project == null)
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      MissionDetailScreen(project: widget.project!))),
              child: const Icon(Icons.create),
            ),
    );
  }
}
