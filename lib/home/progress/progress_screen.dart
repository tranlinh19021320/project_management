import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/home/progress/progress_card.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/progress.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:provider/provider.dart';

class ProgressScreen extends StatefulWidget {
  final Mission mission;
  const ProgressScreen({super.key, required this.mission,});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
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
      body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('missions')
                  .doc(widget.mission.missionId)
                  .collection('progress')
                  .orderBy('createDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.inkDrop(
                      color: darkblueAppbarColor, size: 32);
                }

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => ProgressCard(
                         progress: Progress.fromSnap(doc: snapshot.data!.docs[index]) ,)
                );
              }),
      
    );
  }
}
