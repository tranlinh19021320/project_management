import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/projects/project_card.dart';
import 'package:project_management/home/widgets/projects/project_detail.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({
    super.key,
  });

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  late String companyId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
            ),
          )
        : mainScreen(IS_PROJECTS_PAGE, body: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('companies')
                        .doc(companyId)
                        .collection("projects")
                        .orderBy("createDate", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => ProjectCard(
                              project: Project.fromSnap(
                                  snapshot.data!.docs[index])));
                    }), floatingActionButton: FloatingActionButton(
                  heroTag: "createProjectButton",
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(backgroundImage),
                                    fit: BoxFit.fill),
                              ),
                              child: Scaffold(
                                backgroundColor: Colors.transparent,
                                appBar: AppBar(
                                  backgroundColor: darkblueAppbarColor,
                                  title: const Text('Dự án mới'),
                                  centerTitle: true,
                                ),
                                body: const ProjectDetailScreen(),
                              ),
                            )));
                  },
                  tooltip: 'Tạo mới dự án',
                  child: const Icon(Icons.add),
                ));
        
  }
}
