import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/provider/user_provider.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/utils.dart';
import 'package:provider/provider.dart';

class StaffCard extends StatefulWidget {
  final DocumentSnapshot staff;
  final List<String> groups;
  const StaffCard({super.key, required this.staff, required this.groups});

  @override
  State<StaffCard> createState() => _StaffCardState();
}

class _StaffCardState extends State<StaffCard> {
  bool isDeleted = false;
  bool isChangeGroup = false;
  late String groupSelect;
  late String userGroup;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    userGroup = widget.staff['group'];
    groupSelect = userGroup;
  }

  deleteUser() async {
    var comfirm = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              scrollable: true,
              backgroundColor: darkblueAppbarColor,
              iconPadding: const EdgeInsets.only(bottom: 8),
              icon: loudspeakerIcon,
              title: Column(
                children: [
                  Text(
                      "Bạn chắc muốn xóa tài khoản ${widget.staff['username']} ?",
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Tài khoản sẽ bị xóa vĩnh viễn!",
                    style: TextStyle(color: errorRedColor, fontSize: 12),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.only(bottom: 14),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: focusBlueColor,
                    ),
                    width: 64,
                    height: 36,
                    child: const Center(
                        child: Text(
                      "Ok",
                    )),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: textErrorRedColor,
                    ),
                    width: 64,
                    height: 36,
                    child: const Center(
                        child: Text(
                      "Hủy",
                    )),
                  ),
                ),
              ],
            ));
    if (comfirm) {
      String res = "";
      UserProvider user = Provider.of<UserProvider>(context, listen: false);
      try {
        FirebaseMethods().deleteUser(user.getCurrentUser.userId, widget.staff['userId'],
            widget.staff['email'], widget.staff['password']);
        res = "success";
      } catch (e) {
        res = e.toString();
      }
      if (res == 'success') {
        setState(() {
          isDeleted = true;
        });
        if (context.mounted) {
          showDialog(
              context: context,
              builder: (_) => const NotifyDialog(
                  content: "Xóa thành công!", isError: false));
        }
      } else {
        if (context.mounted) {
          showDialog(
              context: context,
              builder: (_) => NotifyDialog(content: res, isError: false));
        }
      }
    }
  }

  String details() {
    return '''
Họ và tên: ${widget.staff['nameDetails']}
Tài khoản: ${widget.staff['username']}
Email: ${widget.staff['email']}
password: ${widget.staff['password']}
Nhóm: $userGroup''';
  }

  updateGroup() async {
    setState(() {
      isLoading = true;
    });
    userGroup = groupSelect;
    String res = await FirebaseMethods()
        .changeUserGroup(widget.staff['userId'], userGroup);
    setState(() {
      isLoading = false;
      isChangeGroup = false;
    });
    if (res == 'success') {
      if (context.mounted) {
        showSnackBar(context, "Thay đổi thành công!", false);
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, res, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isDeleted || context.watch<UserProvider>().getCurrentUser.userId == widget.staff['userId'])
        ? Container()
        : Container(
            decoration:
                BoxDecoration(border: Border.all(color: focusBlueColor)),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: backgroundWhiteColor)),
                  padding: const EdgeInsets.all(0),
                  child: PreferredSize(
                    preferredSize: const Size.fromHeight(30),
                    child: AppBar(
                      toolbarHeight: 20,
                      backgroundColor: (userGroup == 'Manager')
                          ? buttonGreenColor
                          : darkblueAppbarColor,
                      leadingWidth: 18,
                      leading: userGroup == 'Manager'
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
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
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
                              style: const TextStyle(fontSize: 13),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Row(
                                children: [
                                  const Text(
                                    'Nhóm:  ',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  (isChangeGroup)
                                      ? Row(
                                          children: [
                                            DropdownButton(
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
                                              items: widget.groups
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                        color: (value ==
                                                                groupSelect)
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
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            InkWell(
                                              onTap:
                                                  updateGroup, // comfirm change group
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  color: focusBlueColor,
                                                ),
                                                width: 28,
                                                height: 28,
                                                child: const Center(
                                                    child: Text(
                                                  "Ok",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isChangeGroup = false;
                                                  groupSelect = userGroup;
                                                });
                                              }, // comfirm change group
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                color: Colors.transparent,
                                                width: 28,
                                                height: 28,
                                                child: const Center(
                                                    child: Icon(
                                                  Icons.cancel_outlined,
                                                  color: defaultColor,
                                                  size: 20,
                                                )),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              userGroup,
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            (userGroup == "Manager")
                                                ? Container()
                                                : InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        isChangeGroup = true;
                                                      });
                                                    },
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        width: 20,
                                                        height: 20,
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          child: Icon(
                                                            Icons.change_circle,
                                                            color:
                                                                buttonGreenColor,
                                                            size: 20,
                                                          ),
                                                        )),
                                                  ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            (userGroup == "Manager")
                                ? Container()
                                : InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.all(0),
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2)),
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
                      ),
                    ),
                    (userGroup != 'Manager')
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: details()));
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                    color: defaultColor,
                                    size: 17,
                                  )),
                              IconButton(
                                  onPressed: deleteUser,
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: textErrorRedColor,
                                    size: 24,
                                  )),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          );
  }
}
