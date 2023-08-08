import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/utils.dart';

class StaffCard extends StatefulWidget {
  final DocumentSnapshot staff;
  const StaffCard({super.key, required this.staff});

  @override
  State<StaffCard> createState() => _StaffCardState();
}

class _StaffCardState extends State<StaffCard> {

  deleteUser() {
    
    String res = "";
    try {
    FirebaseMethods().deleteUser(widget.staff['userId'], widget.staff['email'], widget.staff['password']);
    res = "success";
    } catch(e) {
      res = e.toString();
    }
    if (res == 'success') {
    showDialog(context: context, builder: (_) =>const  NotifyDialog(content: "Xóa thành công!", isError: false));
  } else {
    showDialog(context: context, builder: (_) => NotifyDialog(content: res, isError: false));
  }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: focusBlueColor)),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration:
                BoxDecoration(border: Border.all(color: backgroundWhiteColor)),
            padding: const EdgeInsets.all(0),
            child: PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: AppBar(
                toolbarHeight: 20,
                
                backgroundColor:(widget.staff['group'] == 'Manager') ? buttonGreenColor : darkblueAppbarColor,
                leadingWidth: 18,
                leading: widget.staff['group'] == 'Manager'
                    ? Padding(
                        padding: const EdgeInsets.all(0),
                        child: resizedIcon(keyImage, 18),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(0),
                        child: resizedIcon(staffImage, 18),
                      ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                      child: Text(
                    widget.staff['nameDetails'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16),
                  )),
                ),
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: backgroundWhiteColor,
              backgroundImage: NetworkImage(
                widget.staff['photoURL'],
              ),
              radius: 22,
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tài khoản: ${widget.staff['username']}",
                  style: const TextStyle(fontSize: 13),
                ),
                Text(
                  "Email: ${widget.staff['email']}",
                  style:const  TextStyle(fontSize: 13),
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Row(
                    
                    children: [
                      Text(
                        'Nhóm: ${widget.staff['group']}',
                        style:const  TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 8,),
                      (widget.staff['group'] == "Manager")? Container() : InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          width: 20,
                          height: 20,
                          child: const Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Icon(Icons.change_circle, color: buttonGreenColor, size: 20,),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                (widget.staff['group'] == "Manager")
                    ? Container()
                    : InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            color: focusBlueColor,
                          ),
                          width: 100,
                          height: 20,
                          child: const Center(
                              child: Text(
                            "Bảng chấm công",
                            style: TextStyle(fontSize: 12),
                          )),
                        ),
                      ),
              ],
            ),
            trailing: (widget.staff['group'] != 'Manager') ? IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete_forever,
                  color: errorRedColor,
                )) : null,
          )
        ],
      ),
    );
  }
}
