import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/home/widgets/project_titles/title_card.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/model/title.dart';
import 'package:project_management/utils/parameters.dart';

class TitleList extends StatefulWidget {
  final Project project;
  const TitleList({super.key, required this.project});

  @override
  State<TitleList> createState() => _TitleListState();
}

class _TitleListState extends State<TitleList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('companies')
            .doc(widget.project.companyId)
            .collection('projects')
            .doc(widget.project.projectId)
            .collection('title')
            .orderBy('createDate', descending: false)
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
              itemBuilder: (context, index) => TitleCard(

                    index: index,
                    project: widget.project,
                    title:
                        TitleProject.fromSnap(doc: snapshot.data!.docs[index]),
                  ));
        });
  }
}
