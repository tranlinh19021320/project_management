import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/widgets/create_staff.dart';
import 'package:project_management/home/admin/widgets/staff_card.dart';
import 'package:project_management/model/user.dart';
import '../../../utils/utils.dart';
import '../widgets/drawer_bar.dart';

class PersonalScreen extends StatefulWidget {
  final String userId;
  const PersonalScreen({
    super.key,
    required this.userId,
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
    CurrentUser user =
        await FirebaseMethods().getCurrentUserByUserId(userId: widget.userId);
    companyId = user.companyId;
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
                    child: notifyIcon(3),
                  )
                ],
              ),
              drawer: DrawerMenu(
                selectedPage: IS_PERSONAL_PAGE,
                userId: widget.userId,
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
                        SizedBox(
                          height: 48,
                          child: Stack(
                            children: [
                              const Text(
                                "Nhóm:",
                                style: TextStyle(fontSize: 16),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: groupDropdown(
                                    companyId: companyId,
                                    groupSelect: groupSelect,
                                    isWordAtHead: "Tất cả",
                                    onSelectValue: (String selectValue) {
                                      setState(() {
                                        groupSelect = selectValue;
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('companies')
                                .doc(companyId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LoadingAnimationWidget.fallingDot(
                                    color: darkblueAppbarColor, size: 20);
                              }

                              List<String> groups = [];
                              for (var value in snapshot.data!['group']) {
                                groups.add(value.toString());
                              }
                              return Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => CreateStaff(
                                              userId: widget.userId,
                                              groups: groups,
                                            ));
                                  },
                                  icon: addIcon,
                                  highlightColor: focusBlueColor,
                                ),
                              );
                            })
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
                                      currentUserId: widget.userId,
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
