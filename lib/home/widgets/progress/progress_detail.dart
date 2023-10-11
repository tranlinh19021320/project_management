import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/progress.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';
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
  PageController pageController = PageController();

  late bool isManager;
  late String missionId;
  double min = 0;
  double max = 100;
  List<Uint8List> imageList = [];
  int state = IS_SUBMIT;
  String date = dayToString(time: DateTime.now());
  bool isAutoEvaluate = true;
  int pre_state = IS_COMPLETE;
  List photoURL = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;

    percentFocus.addListener(() {
      if (!percentFocus.hasFocus) {
        final num = double.tryParse(percent.text);
        double number = min;
        if (num != null) {
          number = num;
        }
        if (number < min) {
          number = min;
        } else if (number > max) {
          number = max;
        }

        percent.text = number.toStringAsFixed(0);
      }
    });

    if (widget.progress != null) {
      description.text = widget.progress!.description;
      missionId = widget.progress!.missionId;
      date = widget.progress!.date;
      percent.text = (widget.progress!.percent * 100).toStringAsFixed(0);
      if (widget.progress!.state != IS_DOING) {
        state = widget.progress!.state;
      }
      initImageList(widget.progress!);
    }
    if (widget.mission != null) {
      min = widget.mission!.percent * 100;
      percent.text = min.toInt().toString();
      missionId = widget.mission!.missionId;
    }
  }

  jumpToFirstPage() {
    pageController.jumpToPage(0);
    setState(() {});
  }

  updateProgress() async {
    showNotify(context: context, isLoading: true);
    final num = double.tryParse(percent.text);
    double number = 0;
    if (num != null) {
      number = num / 100;
    }

    String res = await FirebaseMethods().updateMissionProgress(
        missionId: missionId,
        description: description.text,
        percent: number,
        date: date,
        state: state,
        imageList: imageList);

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

  changeStateProgress() async {
    showNotify(context: context, isLoading: true);
    if (state != IS_DOING) {
      state = IS_DOING;
    } else if (isAutoEvaluate) {
      state = pre_state;
    } else {
      state = IS_CLOSING;
    }
    String res = await FirebaseMethods()
        .changeStateProgress(progress: widget.progress!, state: state);

    if (context.mounted) {
      Navigator.pop(context);
    }
    if (res == 'success') {
      if (context.mounted) {
        showSnackBar(
          context: context,
          content: (state != IS_DOING) ? "Đã phê duyệt!" : "Đã mở lại!",
        );
      }
    } else {
      if (context.mounted) {
        showSnackBar(context: context, content: res, isError: true);
      }
    }
  }
  initImageList(Progress progress) async {
    setState(() {
      isLoading = true;
    });
    photoURL.clear();
    progress.imageList.forEach((element) {
      photoURL.add(element);
    });
    imageList.clear();
    imageList = await getImageList(photoURL: photoURL);
    setState(() {
      isLoading = false;
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
          backgroundColor: darkblueAppbarColor,
          centerTitle: true,
          title: (widget.progress == null)
              ? const Text('Tạo submit')
              : Text((isToDay(dateString: widget.progress!.date))
                  ? "Hôm nay"
                  : widget.progress!.date),
        ),
        body: (widget.progress == null)
            ? Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 8, right: 8, bottom: 20),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            fillColor: backgroundWhiteColor,
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 3,
                          maxLines: null,
                          scrollController: descriptionScroll,
                          onTapOutside: (event) => descriptionFocus.unfocus(),
                        ),
                        // image List
                        const SizedBox(
                          height: 8,
                        ),
                        imageScreen(),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
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
                                    fillColor: backgroundWhiteColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    )),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                              ),
                            ),
                            Text(" <${max.toInt()}"),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),

                        Center(
                          child: textBoxButton(
                              color: correctGreenColor,
                              text: "Xác nhận",
                              width: 80,
                              height: 34,
                              fontSize: 14,
                              function: updateProgress),
                        ),
                      ]),
                ),
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('missions')
                    .doc(missionId)
                    .collection('progress')
                    .doc(widget.progress!.date)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.data!.exists) {
                    state = IS_SUBMIT;
                    print(state);
                  } else {
                    Progress? progress;
                    progress = Progress.fromSnap(doc: snapshot.requireData);

                    if (description.text == "") {
                      description.text = progress.description;
                    }
                    //state
                    state = progress.state;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 8, right: 8, bottom: 20),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                                fillColor: (state != IS_DOING)
                                    ? defaultColor
                                    : backgroundWhiteColor,
                              ),
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: null,
                              scrollController: descriptionScroll,
                              readOnly: (state != IS_DOING),
                              onTapOutside: (event) =>
                                  descriptionFocus.unfocus(),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            isLoading ?  const LinearProgressIndicator(color: focusBlueColor, minHeight: 0.4,):
                            imageScreen(),
                            const SizedBox(
                              height: 8,
                            ),
                            (isManager ||
                                    state == IS_CLOSING ||
                                    state == IS_COMPLETE ||
                                    state == IS_LATE)
                                ? Column(
                                    children: [
                                      const Text("Tiến độ: "),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      circularPercentIndicator(
                                          percent: widget.progress!.percent,
                                          radius: 40,
                                          lineWidth: 20,
                                          fontSize: 13),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      state != IS_DOING
                                          ? Row(
                                              children: [
                                                const Text("Trạng thái: "),
                                                evaluate(state: state),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Checkbox(
                                                        value: isAutoEvaluate,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isAutoEvaluate =
                                                                value!;
                                                          });
                                                        }),
                                                    const Text(
                                                      "Đánh giá và tự động chấm công",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                                (!isAutoEvaluate)
                                                    ? Container()
                                                    : Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Checkbox(
                                                                  value: pre_state ==
                                                                      IS_COMPLETE,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      value!
                                                                          ? pre_state =
                                                                              IS_COMPLETE
                                                                          : pre_state =
                                                                              IS_LATE;
                                                                    });
                                                                  }),
                                                              evaluate(
                                                                  state:
                                                                      IS_COMPLETE),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Checkbox(
                                                                  value:
                                                                      pre_state ==
                                                                          IS_LATE,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      value!
                                                                          ? pre_state =
                                                                              IS_LATE
                                                                          : pre_state =
                                                                              IS_COMPLETE;
                                                                    });
                                                                  }),
                                                              evaluate(
                                                                  state:
                                                                      IS_LATE),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                              ],
                                            )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text(
                                          "Đánh giá tiến độ: ${min.toInt()}< "),
                                      SizedBox(
                                        width: 50,
                                        height: 30,
                                        child: TextField(
                                          controller: percent,
                                          focusNode: percentFocus,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: blackColor),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 4,
                                                      right: 4,
                                                      top: 0,
                                                      bottom: 0),
                                              filled: true,
                                              fillColor: (state == IS_CLOSING)
                                                  ? defaultColor
                                                  : backgroundWhiteColor,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              )),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
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
                              child: GestureDetector(
                                onTap: isManager
                                    ? changeStateProgress
                                    : updateProgress,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isManager
                                        ? (state == IS_DOING)
                                            ? correctGreenColor
                                            : blueDrawerColor
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
                                    isManager
                                        ? state == IS_DOING
                                            ? "Phê duyệt"
                                            : "Mở lại"
                                        : state == IS_SUBMIT
                                            ? "Tạo mới"
                                            : state == IS_DOING
                                                ? "Lưu lại"
                                                : "Đã phê duyệt",
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ),
                  );
                }),
      ),
    );
  }

  Widget imageScreen() {
    return Column(
      children: [
        Row(
          children: [
            const Text("Hình ảnh minh họa:"),
            const SizedBox(
              width: 10,
            ),
            (state == IS_SUBMIT || state == IS_DOING)
                ? InkWell(
                    onTap: () async {
                      List<Uint8List>? imageAddList = await pickImages(context);
                      if (imageAddList != null) {
                        imageList.addAll(imageAddList);
                      }
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.add_photo_alternate,
                      size: 30,
                    ))
                : Container(),
          ],
        ),
        (imageList.isEmpty)
            ? const Center(
                child: Text('Không có hình ảnh minh họa'),
              )
            : Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                    border: Border.all(color: focusBlueColor, width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: PageView.builder(
                    itemCount: imageList.length,
                    controller: pageController,
                    itemBuilder: (context, index) {
                      return Stack(children: [
                        SizedBox(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                imageList[index],
                                fit: BoxFit.cover,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              (imageList.length == 1)
                                  ? const Text('')
                                  : FutureBuilder(
                                      future: Future.delayed(
                                          const Duration(seconds: 2)),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return const Text('');
                                        } else {
                                          return Container(
                                            decoration: BoxDecoration(
                                                color: darkblueAppbarColor,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 6),
                                              child: Text(
                                                "${index + 1}/${imageList.length}",
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                              const SizedBox(
                                width: 8,
                              ),
                              (state == IS_DOING || state == IS_SUBMIT) ?
                                  InkWell(
                                      onTap: () {
                                        imageList.removeAt(index);
                                        jumpToFirstPage();
                                      },
                                      child: const Icon(
                                        Icons.cancel,
                                        size: 24,
                                      )) : const SizedBox(width: 2,)
                            ],
                          ),
                        ),
                        (index == 0)
                            ? Container()
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Center(
                                        child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 30,
                                      color: defaultColor,
                                    )),
                                  )
                                ],
                              ),
                        (index == imageList.length - 1)
                            ? Container()
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Center(
                                        child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 30,
                                      color: defaultColor,
                                    )),
                                  )
                                ],
                              )
                      ]);
                    }),
              ),
      ],
    );
  }
}
