import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/reports/report_card.dart';
import 'package:project_management/model/report.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late bool isManager;
  late String companyId;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;
    init();
  }

  init() async {
    setState(() {
      isLoading = true;
    });
    CurrentUser user = await FirebaseMethods()
        .getCurrentUserByUserId(userId: FirebaseAuth.instance.currentUser!.uid);
    companyId = user.companyId;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isLoading ? Center(
        child: LoadingAnimationWidget.inkDrop(
                    color: darkblueAppbarColor, size: 32),
      ) : StreamBuilder(
          stream: (isManager)
              ? FirebaseFirestore.instance
                  .collection('companies')
                  .doc(companyId)
                  .collection('reports')
                  .orderBy('createDate', descending: true)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection('companies')
                  .doc(companyId)
                  .collection('reports')
                  .where('ownId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .orderBy('createDate', descending: true)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingAnimationWidget.inkDrop(
                  color: darkblueAppbarColor, size: 32);
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => ReportCard(
                      report:
                          Report.fromSnap(doc: snapshot.data!.docs[index]),
                    ));
          }),
    );
  }
}
