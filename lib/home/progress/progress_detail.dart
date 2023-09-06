import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/numeric_range_formatter.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/progress.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';
import 'package:provider/provider.dart';

class ProgressDetailScreen extends StatefulWidget {
  final Progress? progress;
  final Mission? mission;
  const ProgressDetailScreen({super.key, this.progress, this.mission});

  @override
  State<ProgressDetailScreen> createState() => _ProgressDetailScreenState();
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  TextEditingController description = TextEditingController();
  TextEditingController percent = TextEditingController();
  FocusNode percentFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  ScrollController descriptionScroll = ScrollController();

  late bool isManager;
  late String missionId;
  double min = 0;
  double max = 100;
  late int state;
  String date = dayToString(time: DateTime.now());
  @override
  void initState() {
    super.initState();
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;
    percentFocus.addListener(() {
      if (percentFocus.hasFocus && state != IS_CLOSING) {
        setState(() {
          percent.text = '';
        });
      }
    });
    //state
    if (isManager) {
      if (widget.progress!.isCompleted) {
        state = IS_CLOSING;
      } else {
        state = IS_OPENING;
      }
    } else {
      if (widget.progress == null) {
        state = IS_SUBMIT;
      } else {
        state = IS_DOING;
      }
    }

    if (widget.progress != null) {
      description.text = widget.progress!.description;
      missionId = widget.progress!.missionId;
      date = widget.progress!.date;
      percent.text = (widget.progress!.percent * 100).toStringAsFixed(0);
      if (widget.progress!.isCompleted) {
      state = IS_CLOSING;
    }
    }
    if (widget.mission != null) {
      min = widget.mission!.percent * 100;
      percent.text = min.toInt().toString();
      missionId = widget.mission!.missionId;
    }

   
    
  }

  updateProgress() async {
    showDialog(
        context: context,
        builder: (_) => const NotifyDialog(content: 'loading'));
    final num = double.tryParse(percent.text);
    double number = 0;
    if (num != null) {
      number = num / 100;
    }

    String res = await FirebaseMethods().updateMissionProgress(
        missionId: missionId,
        description: description.text,
        percent: number,
        date: date);

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (res == 'success') {
      if (context.mounted) {
        Navigator.pop(context);
        showSnackBar(
          context: context,
          content: "Đã nộp thành công!",
        );
      }
    } else {
      if (context.mounted) {
        showSnackBar(context: context, content: res, isError: true);
      }
    }
  }

  changeStateProgress()async {
    showDialog(
        context: context,
        builder: (_) => const NotifyDialog(content: 'loading'));
    String res = await FirebaseMethods().changeStateProgress(progress: widget.progress!);
    if (context.mounted) {
      Navigator.pop(context);
    }
    if (res == 'success') {
      if (context.mounted) {
        showSnackBar(
          context: context,
          content: (state == IS_OPENING) ? "Đã phê duyệt!" : "Đã mở lại!",
        );
      }
      setState(() {
        (state == IS_OPENING) ? state = IS_CLOSING : state = IS_OPENING;
      });
    } else {
      if (context.mounted) {
        showSnackBar(context: context, content: res, isError: true);
      }
    }

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
          centerTitle: true,
          title: (widget.progress == null)
              ? const Text('Tạo submit')
              : Text((isToDay(day: widget.progress!.date))
                  ? "Hôm nay"
                  : widget.progress!.date),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: [
                  const Divider(),
                  const SizedBox(
                    height: 6,
                  ),
                  // description textfield
                  TextField(
                    controller: description,
                    focusNode: descriptionFocus,
                    style: const TextStyle(color: blackColor),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      helperText: "",
                      fillColor:(state == IS_CLOSING) ? defaultColor : backgroundWhiteColor,
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: null,
                    scrollController: descriptionScroll,
                    readOnly: (state == IS_CLOSING),
                    onTapOutside: (event) => descriptionFocus.unfocus(),
                  ),

                  const SizedBox(
                    height: 8,
                  ),
                  (isManager)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Tiến độ: "),
                            circularPercentIndicator(
                              percent: widget.progress!.percent,
                              radius: 40,
                              lineWidth: 20,
                              fontSize: 13
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Text("Đánh giá tiến độ: ${min.toInt()}< "),
                            SizedBox(
                              width: 50,
                              height: 30,
                              child: TextField(
                                controller: percent,
                                focusNode: percentFocus,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: blackColor),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 4, right: 4, top: 0, bottom: 0),
                                    filled: true,
                                    fillColor:(state == IS_CLOSING) ? defaultColor : backgroundWhiteColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    )),
                                inputFormatters: [
                                  NumericRangeFormatter(min: min, max: max),
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                readOnly: (state == IS_CLOSING),
                              ),
                            ),
                            Text(" <${max.toInt()}"),
                          ],
                        ),
                  const SizedBox(
                    height: 18,
                  ),

                  Center(
                    child: InkWell(
                      onTap: (state == IS_SUBMIT || state == IS_DOING)
                          ? updateProgress
                          :(isManager) ? changeStateProgress :() {
                            
                          },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: (state == IS_SUBMIT)
                              ? darkgreenColor
                              : (state == IS_DOING)
                                  ? blueDrawerColor
                                  : (state == IS_OPENING)
                                      ? correctGreenColor
                                      : darkblueAppbarColor,
                          boxShadow: const [
                            BoxShadow(
                              color: defaultIconColor,
                              offset: Offset(1, 2),
                            ),
                            BoxShadow(
                              color: backgroundWhiteColor,
                              offset: Offset(2, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          (state == IS_SUBMIT)
                              ? 'Xác nhận'
                              : (state == IS_DOING)
                                  ? 'Lưu lại'
                                  : (state == IS_OPENING)
                                      ? 'Phê duyệt'
                                      :(isManager) ? 'Mở lại' : "Đã phê duyệt",
                        ),
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
