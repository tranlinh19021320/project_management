import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/widgets/create_staff.dart';
import 'package:project_management/home/admin/widgets/staff_card.dart';
import 'package:project_management/provider/user_provider.dart';
import 'package:provider/provider.dart';

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
  late FocusNode searchFocus = FocusNode();
  List<String> groups = ['Tất cả'];
  String groupSelect = 'Tất cả';
  int isResult = IS_DEFAULT_STATE;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    searchFocus = FocusNode();
    getListGroup();
  }

  getListGroup() async {
    try {
      groups.clear();
      groups.add('Tất cả');
      UserProvider user = Provider.of<UserProvider>(context, listen: false);
      var snap = await FirebaseFirestore.instance
          .collection('companies')
          .doc(user.getCurrentUser.companyId)
          .get();
      for (var value in snap.data()!['group']) {
        groups.add(value.toString());
      }
      setState(() {});
      //showDialog(context: context, builder: (_) => NotifyDialog(content: groups.toString(), isError: false));
    } catch (e) {
      showSnackBar(context, e.toString(), true);
    }
  }

  List<DocumentSnapshot> getDocuments(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
    return Container(
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
        drawer: const DrawerMenu(selectedPage: IS_PERSONAL_PAGE),
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
                              borderSide: BorderSide(color: defaultColor)),
                        ),
                        onEditingComplete: ()  {
                          searchFocus.unfocus;
                          setState(() {
                            
                          });
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
                          child: DropdownButton(
                            menuMaxHeight: 200,
                            alignment: Alignment.center,
                            value: groupSelect,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            underline: Container(
                              height: 1,
                              color: backgroundWhiteColor,
                            ),
                            items: groups.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: (value == groupSelect)
                                          ? notifyIconColor
                                          : backgroundWhiteColor),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                groupSelect = val!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: IconButton(
                      onPressed: () async {
                        groups = await showDialog(
                            context: context,
                            builder: (_) => const CreateStaff());
                        setState(() {});
                      },
                      icon: addIcon,
                      highlightColor: focusBlueColor,
                    ),
                  )
                ],
              ),
              isLoading? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0)),
              const Divider(),
              FutureBuilder(
                future: FirebaseMethods().searchSnapshot(groupSelect),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
              child: CircularProgressIndicator(),
            );
                  }
                  if (!snapshot.hasData) {
                    return const  Text("Không tìm thấy nhân viên");
                  }
                  List<DocumentSnapshot> documents = getDocuments(snapshot);
                  return Expanded(child: ListView.builder(itemCount: documents.length,itemBuilder: (context, index) => StaffCard(staff: documents[index])));
                },
                )

            ],
          ),
        ),
      ),
    );
  }
}
