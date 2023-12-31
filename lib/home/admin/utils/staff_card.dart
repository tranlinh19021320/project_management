import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/timetracking/time_keeping_table.dart';
import 'package:project_management/home/widgets/utils/group_dropdown_button.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';

class StaffCard extends StatefulWidget {
  final CurrentUser staff;
  const StaffCard({
    super.key,
    required this.staff,
  });

  @override
  State<StaffCard> createState() => _StaffCardState();
}

class _StaffCardState extends State<StaffCard> {
  late String managerId;
  late String companyId;
  bool isChangeGroup = false;
  late String userGroup;
  // bool isLoading = false;
  bool isLoadingGroup = false;

  @override
  void initState() {
    super.initState();
    managerId = FirebaseAuth.instance.currentUser!.uid;
    companyId = widget.staff.companyId;
    userGroup = widget.staff.group;
  }

  deleteUser() async {
    var comfirm = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              scrollable: true,
              backgroundColor: darkblueAppbarColor,
              title: Column(
                children: [
                  Text("Bạn chắc muốn xóa tài khoản ${widget.staff.username} ?",
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
                textBoxButton(
                    color: focusBlueColor,
                    text: "Ok",
                    fontSize: 14,
                    width: 50,
                    height: 36,
                    function: () => Navigator.of(context).pop(true)),
                textBoxButton(
                    color: textErrorRedColor,
                    text: "Hủy",
                    fontSize: 14,
                    width: 50,
                    height: 36,
                    function: () => Navigator.of(context).pop(false)),
              ],
            ));
    if (comfirm != null && comfirm) {
      FirebaseMethods().deleteUser(deleteUserId: widget.staff.userId);
      if (context.mounted) {
        showNotify(context: context, content: "Xóa thành công!",);
      }
    }
  }

  String details() {
    return '''
Họ và tên: ${widget.staff.nameDetails}
Tài khoản: ${widget.staff.userId}
Email: ${widget.staff.email}
password: ${widget.staff.password}
Nhóm: $userGroup''';
  }

  updateGroup() async {
    setState(() {
      isLoadingGroup = true;
    });
    String res = await FirebaseMethods()
        .changeUserGroup(userId: widget.staff.userId, group: userGroup);
    setState(() {
      isLoadingGroup = false;
      isChangeGroup = false;
    });
    if (res == 'success') {
      if (context.mounted) {
        showSnackBar(
          context: context,
          content: "Thay đổi thành công!",
        );
      }
    } else {
      if (context.mounted) {
        showSnackBar(context: context, content: res, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (managerId == widget.staff.userId)
        ? Container()
        : Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: focusBlueColor),
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: backgroundWhiteColor),
                          borderRadius: BorderRadius.circular(3)),
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
                                  child: resizedIcon(keyImagePath, size: 18),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: resizedIcon(staffImagePath, size: 18),
                                ),
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                                child: Text(
                              widget.staff.nameDetails,
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
                            leading: getCircleImageFromUrl(widget.staff.photoURL, radius: 22),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tài khoản: ${widget.staff.username}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "Email: ${widget.staff.email}",
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
                                      isLoadingGroup
                                          ? LoadingAnimationWidget.waveDots(
                                              color: backgroundWhiteColor,
                                              size: 20)
                                          : (isChangeGroup)
                                              ? Row(
                                                  children: [
                                                    GroupDropdownButton(
                                                        companyId: companyId,
                                                        groupSelect: userGroup,
                                                        isWordAtHead: '',
                                                        onSelectValue:
                                                            (String value) {
                                                          if (context.mounted) {
                                                            setState(() {
                                                              userGroup = value;
                                                            });
                                                          }
                                                        }),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    textBoxButton(
                                                        color: focusBlueColor,
                                                        text: "Ok",
                                                        fontSize: 11,
                                                        function: updateGroup),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          isChangeGroup = false;
                                                          userGroup = widget
                                                              .staff.group;
                                                        });
                                                      }, // comfirm change group
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        color:
                                                            Colors.transparent,
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
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    (userGroup == "Manager")
                                                        ? Container()
                                                        : InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                isChangeGroup =
                                                                    true;
                                                              });
                                                            },
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                width: 20,
                                                                height: 20,
                                                                child:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .change_circle,
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
                                    : textBoxButton(
                                        color: darkblueColor,
                                        text: "Bảng chấm công",
                                        fontSize: 12,
                                        width: 100,
                                        padding: 2,
                                        function: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (_) => Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  backgroundImage),
                                                              fit: BoxFit.fill),
                                                        ),
                                                        child: Scaffold(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            appBar: AppBar(
                                                              title: const Text(
                                                                  "Bảng chấm công"),
                                                              centerTitle: true,
                                                              backgroundColor:
                                                                  darkblueAppbarColor,
                                                            ),
                                                            body: TimeKeepingTable(
                                                                userId: widget
                                                                    .staff
                                                                    .userId)),
                                                      )));
                                        })
                              ],
                            ),
                          ),
                        ),
                        (userGroup != 'Manager')
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: deleteUser,
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: textErrorRedColor,
                                        size: 24,
                                      )),
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
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
