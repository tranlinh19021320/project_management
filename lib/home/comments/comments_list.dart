import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management/home/comments/comment_card.dart';
import 'package:project_management/model/comment.dart';
import 'package:project_management/model/report.dart';

class CommentList extends StatefulWidget {
  final Report report;
  final bool isLast;
  const CommentList({super.key, required this.report, this.isLast = true});

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
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Không có Comment"),
            );
          }
          int maxLength = snapshot.data!.docs.length;
          print(maxLength);
          if (widget.isLast) {
            String commentOwnId = snapshot.data!.docs.first['ownId'];
            maxLength = 1;
            bool findFirstOwnId = true;
            while (findFirstOwnId) {
              if (maxLength >= snapshot.data!.docs.length ||
                  commentOwnId != snapshot.data!.docs[maxLength]['ownId']) {
                findFirstOwnId = false;
              } else {
                maxLength++;
              }
            }
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height*0.4,
            child: ListView.builder(
                itemCount: maxLength,
                
                shrinkWrap: true,
                itemBuilder: (context, index) => CommentCard(
                    comment:
                        CommentReport.fromSnap(doc: snapshot.data!.docs[index]))),
          );
        });
  }
}
