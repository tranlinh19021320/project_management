import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/model/report.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';

class InviteMember extends StatefulWidget {
  final Report report;
  const InviteMember({super.key, required this.report});

  @override
  State<InviteMember> createState() => _InviteMemberState();
}

class _InviteMemberState extends State<InviteMember> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  List<CurrentUser> currentUserList = [];
  List<CurrentUser> allUserList = [];
  List<CurrentUser> searchList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    List<String> userIdList = [];
    widget.report.member.forEach((element) {
      userIdList.add(element as String);
    });
    currentUserList =
        await FirebaseMethods().getCurrentUserList(userIdList: userIdList);
    allUserList = await FirebaseMethods().getCurrentUserList();
    refreshSearchList();
    print(allUserList.length);
    setState(() {
      isLoading = false;
    });
  }

  bool checkUserInUserList(CurrentUser user) {
    bool check = false;
    currentUserList.forEach((element) {
      if (element.userId == user.userId) {
        check = true;
      }
    });
    return check;
  }

  updateMember(CurrentUser user) async {
    String res = await FirebaseMethods()
        .updateMemberReport(report: widget.report, userId: user.userId);

    if (res != 'success')  {
      if (context.mounted) {
        showNotify(context: context, content: res, isError: true);
      }
    }
  }
  refreshCurrentUserList(List member) {
    currentUserList.clear();
    allUserList.forEach((element) {
      if (member.contains(element.userId)) {
        currentUserList.add(element);
      }
    });
  }
  refreshSearchList() {
    searchList.clear();
    if (controller.text != '') {
      allUserList.forEach((element) {
        if (element.nameDetails
                .toLowerCase()
                .startsWith(controller.text.toLowerCase()) ||
            element.username
                .toLowerCase()
                .startsWith(controller.text.toLowerCase())) {
          searchList.add(element);
        }
      });
    } else {
      allUserList.forEach((element) {
        searchList.add(element);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
          color: darkblueColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Mời thành viên",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                  ),
                ),
                isLoading
                    ? const LinearProgressIndicator(
                        minHeight: 0.7,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(),
                          const Text("Thành viên hiện tại:"),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('companies')
                                  .doc(widget.report.companyId)
                                  .collection('reports')
                                  .doc(widget.report.reportId)
                                  .snapshots(),
                              builder: (context, snapshot) {

                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const LinearProgressIndicator(
                                  minHeight: 0.7,
                                );
                                
                                }
                                Report report = Report.fromSnap(doc: snapshot.data!);
                                refreshCurrentUserList(report.member);
                                if (report.member.isEmpty) {
                                  return const Text("[ ]");
                                }

                                return Container(
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          spacing: 4,
                                          runSpacing: 12,
                                          direction: Axis.vertical,
                                          children: currentUserList
                                              .map(
                                                (user) => SizedBox(
                                                  height: 42,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(color: defaultColor),
                                                            borderRadius: BorderRadius.circular(8)),
                                                        padding:const EdgeInsets.all(2),
                                                        child: user2Card(user: user),
                                                      ),
                                                      Padding( padding: const EdgeInsets.only(left: 4),
                                                        child: InkWell(
                                                            onTap: () {updateMember(user);
                                                            },
                                                            child: const Icon(Icons
                                                                .cancel_rounded)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    );
                              }),
                      
                          // member
                          const SizedBox(
                            height: 8,
                          ),
                          TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              labelText: "Tìm kiếm thành viên",
                            ),
                            onChanged: (value) => refreshSearchList(),
                          ),
                          searchList.isEmpty
                              ? const Center(child: Text("Không tìm thấy"))
                              : Container(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.2,
                                  ),
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: searchList.length,
                                      itemBuilder: (context, index) => Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: InkWell(
                                                onTap: () {
                                                  updateMember(
                                                      searchList[index]);
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                darkblueAppbarColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: user2Card(
                                                        user: searchList[
                                                            index]))),
                                          )),
                                ),
                        ],
                      ),
                //member
              ],
            ),
          ),
        ),
      ),
    );
  }
}
