import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/widgets/create_staff.dart';
import 'package:project_management/home/widgets/group_dropdown_button.dart';
import 'package:project_management/home/cards/staff_card.dart';
import 'package:project_management/model/user.dart';
import '../../../utils/utils.dart';
import '../widgets/drawer_bar.dart';

class PersonalScreen extends StatefulWidget {
 
  const PersonalScreen({
    super.key,
 
  });

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String groupSelect = 'Tất cả';
  int isResult = IS_DEFAULT_STATE;
  String companyId = '';
  String companyName = "";
  late String userId;
  late SizedBox groupDropdownButton;
  
  // late GroupDropdownButton groupDropdownButton;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  init() async {
    setState(() {
      isLoading = true;
    });
    userId = FirebaseAuth.instance.currentUser!.uid;
    CurrentUser user =
        await FirebaseMethods().getCurrentUserByUserId(userId: userId);
    companyId = user.companyId;
    companyName = user.companyName;

    groupDropdownButton = SizedBox(
      height: 48,
      child: Stack(
        children: [
          const Text(
            "Nhóm:",
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            // group dropdown button
            child: GroupDropdownButton(
                companyId: companyId,
                groupSelect: groupSelect,
                isWordAtHead: "Tất cả",
                onSelectValue: (String value) {
                  setState(() {
                    groupSelect = value;
                  });
                }),
          ),
        ],
      ),
    );
    setState(() {
      isLoading = false;
    });
  }

  List<DocumentSnapshot> getDocuments(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    List<DocumentSnapshot> docs = snapshot.data!.docs;

    docs.removeWhere((element) {
      String nameDetails = element['nameDetails'];
      String username = element['username'];
      nameDetails = nameDetails.toLowerCase();
      username = username.toLowerCase();
      if (!nameDetails.startsWith(searchController.text.toLowerCase()) &&
          !username.startsWith(searchController.text.toLowerCase())) {
        print('loại $username');
      }
      return (!nameDetails.startsWith(searchController.text.toLowerCase()) &&
          !username.startsWith(searchController.text.toLowerCase()));
    });

    return docs;
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
                title: const Text("Nhân viên"),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: notifications(3),
                  )
                ],
              ),
              drawer: const DrawerMenu(
                selectedPage: IS_PERSONAL_PAGE,
             
              ),
              body: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: TextField(
                              controller: searchController,
                              focusNode: searchFocus,
                              decoration: InputDecoration(
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(Icons.search),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: defaultColor)),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                              onSubmitted: (value) {
                                searchFocus.unfocus;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        groupDropdownButton,
                        // button to create user
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => CreateStaff(
                                        companyId: companyId,
                                        companyName: companyName,
                                      ));
                            },
                            icon: addIcon,
                            highlightColor: focusBlueColor,
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    StreamBuilder(
                      stream: FirebaseMethods()
                          .searchSnapshot(groupSelect: groupSelect),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LoadingAnimationWidget.hexagonDots(
                                color: backgroundWhiteColor, size: 40),
                          );
                        }

                        List<DocumentSnapshot> documents =
                            getDocuments(snapshot);
                        if (documents.isEmpty) {
                          return const Text("Không tìm thấy nhân viên");
                        }
                        return Expanded(
                            child: ListView.builder(
                                itemCount: documents.length,
                                itemBuilder: (context, index) => StaffCard(
                                      staff: documents[index],
                                     
                                    )));
                      },
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
