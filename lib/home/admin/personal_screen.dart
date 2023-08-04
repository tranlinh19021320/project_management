import 'package:flutter/material.dart';
import 'package:project_management/home/unit_card/create_staff.dart';

import '../../utils/utils.dart';
import 'drawer_bar.dart';

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

  String roleSelect = 'manager';
  int isResult = IS_DEFAULT_STATE;

  @override
  void initState() {
    super.initState();
    searchFocus = FocusNode();
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
                        onEditingComplete: () => searchFocus.unfocus(),
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
                          style:
                              TextStyle(fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: DropdownButton(
                            
                            alignment: Alignment.center,
                            value: roleSelect,
                            style: const TextStyle(
                              fontSize: 13,
                            ),
                            underline: Container(
                              height: 1,
                              color: backgroundWhiteColor,
                            ),
                            items: <String>[
                              'Tất cả',
                              'manager',
                              'devs',
                              'tester',
                              '1',
                              '2'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      color: (value == roleSelect)
                                          ? focusBlueColor
                                          : backgroundWhiteColor),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                roleSelect = val!;
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
                      onPressed: () {
                        showDialog(context: context, builder: (_) => const  CreateStaff());
                      },
                      icon: addIcon,
                      highlightColor: focusBlueColor,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
