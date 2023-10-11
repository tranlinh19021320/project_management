import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management/home/widgets/comments/comment_card.dart';
import 'package:project_management/model/comment.dart';
import 'package:project_management/model/report.dart';
import 'package:project_management/utils/parameters.dart';

class CommentList extends StatefulWidget {
  final Report report;
  const CommentList({super.key, required this.report,});

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  String commentOwnId = '';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('companies')
            .doc(widget.report.companyId)
            .collection('reports')
            .doc(widget.report.reportId)
            .collection('comments')
            .orderBy('createDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Không có Comment"),
            );
          }
         
          return Container(
            constraints:BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.45),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(),
              color: darkblueColor
            ),
            child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                
                shrinkWrap: true,
                itemBuilder: (context, index) => CommentCard(
                    comment:
                        CommentReport.fromSnap(doc: snapshot.data!.docs[index]))),
          );
        });
  }
}
