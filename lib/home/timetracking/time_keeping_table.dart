import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';

class TimeKeepingTable extends StatefulWidget {
  final String userId;
  const TimeKeepingTable({super.key, required this.userId});

  @override
  State<TimeKeepingTable> createState() => _TimeKeepingTableState();
}

class _TimeKeepingTableState extends State<TimeKeepingTable> {
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  @override
  void initState() {
    super.initState();
  }

  nextMonth() {
    month ++;
    if (month > 12) {
      year ++;
      month =1;
    }
    setState(() {
      
    });
  }

  prevMonth() {
    month --;
    if (month == 0) {
      month = 12;
      year --;
    }
    setState(() {
      
    });
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
          title: const Text("Bảng chấm công"),
          centerTitle: true,
          backgroundColor: darkblueAppbarColor,
        ),
        body: StreamBuilder(
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
                  const SizedBox(height: 12,),
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
                            builder: (_) =>  SizedBox(
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


                  // state explication
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      const SizedBox(width: 30,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          evaluate(state: IS_COMPLETE),
                          evaluate(state: IS_LATE),
                          evaluate(state: IS_CLOSING),
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
