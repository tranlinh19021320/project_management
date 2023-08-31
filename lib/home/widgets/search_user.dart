import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';

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
            selectValue = widget.selectuserId;
            Map<String, CurrentUser> users = {};
            for (DocumentSnapshot doc in snapshot.data!.docs) {
              usersId.add(doc['userId']);
              users.addAll({doc['userId']: CurrentUser.fromSnap(user: doc)});
            }
            return Container(
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
                        child: (value == "")
                            ? Container(
                               height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: focusBlueColor
                                ),
                
                
                              ),
                              child: const Center(
                                child: Text(
                                    'Trống',
                                    style: TextStyle(color: defaultColor),
                                  ),
                              ),
                            )
                            : Container(
                              height: 50,
                              decoration: !(value == selectValue) ? BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: focusBlueColor
                                ),
                
                
                              ) : BoxDecoration(
                                border: Border.all(
                                  color: focusBlueColor,
                                  
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: focusBlueColor
                              ),
                    
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                dense: true,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(users[value]!.photoURL),
                                  radius: 20,
                                ),
                                
                                title: Text(users[value]!.nameDetails, style: TextStyle(fontSize: 16),),
                                subtitle: Text(users[value]!.group),
                
                                trailing: (users[value]!.group == manager) ? resizedIcon(keyImage, 18) : resizedIcon(staffImage, 18),
                              ),
                            ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectValue = val!;
                        
                      });
                    
                      widget.onSelectValue(selectValue);
                    },
                  ),
                ),
              
            );
          });
  }
}
