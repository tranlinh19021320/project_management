import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/widgets/create_project.dart';
import 'package:project_management/home/admin/widgets/drawer_bar.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/utils.dart';

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
        : Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(backgroundImage), fit: BoxFit.fill),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: darkblueAppbarColor,
            title: const Text("Dự án"),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: notifications(3),
              )
            ],
          ),
          drawer: const DrawerMenu(
            selectedPage: IS_PROJECTS_PAGE,
          ),
          body: 
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('companies').doc(companyId).collection('projects').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => Text(snapshot.data!.docs[index].data()['nameProject']));
                }),
            
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const CreateProjectScreen()));
            },
            tooltip: 'Tạo mới dự án',
            child: Icon(Icons.add),
          )),
    );
  }
}
