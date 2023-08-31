import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/utils/colors.dart';
class GroupDropdownButton extends StatefulWidget {
  final String companyId;
  final String groupSelect;
  final String isWordAtHead;
  final ValueChanged<String> onSelectValue;

  const GroupDropdownButton({super.key, required this.companyId, required this.groupSelect, this.isWordAtHead = '', required this.onSelectValue});
  
  @override
  State<GroupDropdownButton> createState() => _GroupDropdownButtonState();
}

class _GroupDropdownButtonState extends State<GroupDropdownButton> {
  String selectValue = "Manager";
  @override
  void initState() {
    super.initState();
    selectValue = widget.groupSelect;
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('companies')
          .doc(widget.companyId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingAnimationWidget.hexagonDots(
              color: darkblueAppbarColor, size: 20);
        }
        List<String> groups = [];
        if (widget.isWordAtHead != "") groups.add(widget.isWordAtHead);
        for (var value in snapshot.data!['group']) {
          groups.add(value.toString());
        }
        return DropdownButton(
          menuMaxHeight: 200,
          alignment: Alignment.center,
          value: selectValue,
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
                    color: (value == selectValue)
                        ? notifyIconColor
                        : backgroundWhiteColor),
              ),
            );
          }).toList(),
          onChanged: (val) {
              setState(() {
                selectValue = val!;
                print(selectValue);
              });
            
              widget.onSelectValue(selectValue);
          },
        );
      });
  }
}