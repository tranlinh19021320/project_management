import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';

class SearchUser extends StatefulWidget {
  final String companyId;
  final String groupSelect;
  final String selectuserId;
  final ValueChanged<String> onSelectValue;

  const SearchUser(
      {super.key,
      required this.companyId,
      required this.groupSelect,
      required this.onSelectValue,
      required this.selectuserId});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  String selectValue = "";
  @override
  void initState() {
    super.initState();
    selectValue = widget.selectuserId;
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
          stream:
              FirebaseMethods().searchSnapshot(groupSelect: widget.groupSelect),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingAnimationWidget.hexagonDots(
                  color: darkblueAppbarColor, size: 20);
            }
            List<String> usersId = [''];
            Map<String, CurrentUser> users = {};
            for (DocumentSnapshot doc in snapshot.data!.docs) {
              usersId.add(doc['userId']);
              users.addAll({doc['userId']: CurrentUser.fromSnap(user: doc)});
            }
            return SizedBox(
              height: 50,
              
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    itemHeight: kMinInteractiveDimension,
                    padding: EdgeInsets.zero,
                    menuMaxHeight: 200,
                    // alignment: Alignment.center,
                    value: selectValue,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                    isExpanded: true,
                    // isDense: true,
                    
                    
                    items: usersId.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                               height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: focusBlueColor
                                ),

                                color: (value == selectValue && value != "") ? focusBlueColor : Colors.transparent,
                
                              ),
                    
                              child:(value == "") ? const Center(
                                child: Text(
                                    'Trống',
                                    style: TextStyle(color: defaultColor),
                                  ),
                              ) : user1Card(user: users[value]!),
                            ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectValue = val!;
                        widget.onSelectValue(selectValue);
                      });
                    
                      
                    },
                  ),
                ),
              
            );
          });
  }
}
