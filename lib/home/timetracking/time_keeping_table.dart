import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
class TimeKeepingTable extends StatefulWidget {
  final String userId;
  const TimeKeepingTable({super.key, required this.userId});

  @override
  State<TimeKeepingTable> createState() => _TimeKeepingTableState();
}

class _TimeKeepingTableState extends State<TimeKeepingTable> {
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  List<int> dayList = [];
  bool isInMonth = false;
  int isCompleteStateDays = 0;
  int isLateStateDays = 0;
  int isClosingStateDays = 0;

  @override
  void initState() {
    super.initState();
    updateDayList();
  }

  nextMonth() {
    month++;
    if (month > 12) {
      year++;
      month = 1;
    }
    updateDayList();
    setState(() {});
  }

  prevMonth() {
    month--;
    if (month == 0) {
      month = 12;
      year--;
    }
    updateDayList();
    setState(() {});
  }

  updateDayList() {
    dayList.clear();
    isInMonth = false;
    /** DateTime.monday = 1, DateTime.tuesday = 2, ..., DateTime.sunday = 7
     * need a List have size 7 x 6 = 42
     *  
     * */
    DateTime date = DateTime(year, month, 1).subtract(const Duration(days: 1));
    int weekDay = date.weekday;
    int dayInt = date.day;
    while (weekDay >= 0) {
      dayList.insert(0, dayInt);
      dayInt--;
      weekDay--;
    }

    date = DateTime(year, month + 1, 1).subtract(const Duration(days: 1));
    int lastDay = date.day;
    for (int i = 1; i <= lastDay; i++) {
      dayList.add(i);
    }

    dayInt = 1;
    while (dayList.length <= 42) {
      dayList.add(dayInt);
      dayInt++;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 8;
    return  StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            CurrentUser user = CurrentUser.fromSnap(user: snapshot.data!);
            isClosingStateDays = 0;
            isCompleteStateDays = 0;
            isLateStateDays = 0;
            user.timekeeping.forEach(
              (key, value) {
                if (key.contains(
                    dayToString(time: DateTime(year, month, 1), type: 1))) {
                  (value == IS_COMPLETE)
                      ? isCompleteStateDays++
                      : (value == IS_LATE)
                          ? isLateStateDays++
                          : isClosingStateDays++;
                }
              },
            );
            return SingleChildScrollView(
              child: Column(
                children: [
                  const Divider(),

                  // user infor
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: focusBlueColor,
                        radius: 36,
                        child: CircleAvatar(
                          backgroundColor: defaultColor,
                          backgroundImage: NetworkImage(
                            user.photoURL,
                          ),
                          radius: 34,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.nameDetails,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text("Email: ${user.email}",
                              style: const TextStyle(
                                fontSize: 14,
                              )),
                          Text("Tài khoản: ${user.username}",
                              style: const TextStyle(
                                fontSize: 14,
                              )),
                          Text("Nhóm: ${user.group}",
                              style: const TextStyle(
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // choose month
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: prevMonth,
                          icon: const Icon(Icons.arrow_back_ios_new)),
                      CupertinoButton.filled(
                          child: Text(
                            "Tháng $month, $year",
                            style: const TextStyle(fontSize: 15),
                          ),
                          onPressed: () => showCupertinoModalPopup(
                                context: context,
                                builder: (_) => SizedBox(
                                  width: double.infinity,
                                  height: 250,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CupertinoPicker(
                                          itemExtent: 30,
                                          scrollController:
                                              FixedExtentScrollController(
                                                  initialItem: month - 1),
                                          looping: true,
                                          onSelectedItemChanged: (int value) {
                                            setState(() {
                                              month = value + 1;
                                              updateDayList();
                                            });
                                          },
                                          children: [
                                            for (int i = 1; i <= 12; i++)
                                              Text('Tháng $i')
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: CupertinoPicker(
                                          itemExtent: 30,
                                          scrollController:
                                              FixedExtentScrollController(
                                            initialItem: year - 11,
                                          ),
                                          looping: true,
                                          onSelectedItemChanged: (int value) {
                                            setState(() {
                                              year = 2000 + value;
                                              updateDayList();
                                            });
                                          },
                                          children: [
                                            for (int i = 2000; i <= 2050; i++)
                                              Text('$i')
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                      IconButton(
                          onPressed: nextMonth,
                          icon: const Icon(Icons.arrow_forward_ios)),
                    ],
                  ),
                  // time keeping table
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: GridView.builder(
                        itemCount: 49,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7),
                        itemBuilder: ((context, index) {
                          if (index < 7) {
                            return Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: backgroundWhiteColor,
                                  border: Border.all(color: defaultColor)),
                              child: Center(
                                  child: (index != 6)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Thứ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: blackColor),
                                            ),
                                            Text(
                                              "${index + 2}",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: blueDrawerColor),
                                            )
                                          ],
                                        )
                                      : const Text(
                                          "Chủ nhật",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: errorRedColor),
                                        )),
                            );
                          }
                          if (dayList[index - 6] == 1) {
                            isInMonth = !isInMonth;
                          }
                          int? state = user.timekeeping[dayToString(
                              time: DateTime(year, month, dayList[index - 6]))];
                          return (!isInMonth)
                              ? Container(
                                  padding: const EdgeInsets.all(6),
                                  height: 40,
                                  width: width,
                                  decoration: BoxDecoration(
                                      color: backgroundWhiteColor,
                                      border: Border.all(color: defaultColor)),
                                  child: Text(
                                    "${dayList[index - 6]}",
                                    style: const TextStyle(color: defaultColor),
                                  ),
                                )
                              : Container(
                                  height: 40,
                                  width: width,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: backgroundWhiteColor,
                                      border: Border.all(
                                        color: defaultColor,
                                      )),
                                  child: Center(
                                      child: Column(
                                    children: [
                                      Text(
                                        "${dayList[index - 6]}",
                                        style:
                                            const TextStyle(color: blackColor),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      state == null
                                          ? Container()
                                          : evaluateIcon(state: state, size: 20)
                                    ],
                                  )),
                                );
                        }),
                      ),
                    ),
                  ),
                  // state explication

                  Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("$isCompleteStateDays : "),
                              evaluate(state: IS_COMPLETE, size: 17),
                            ],
                          ),
                          Row(
                            children: [
                              Text("$isLateStateDays : "),
                              evaluate(state: IS_LATE, size: 17),
                            ],
                          ),
                          Row(
                            children: [
                              Text("$isClosingStateDays : "),
                              evaluate(state: IS_CLOSING, size: 16),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          },
    );
  }
}
