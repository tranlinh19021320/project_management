import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/text_button.dart';
import 'package:project_management/model/report.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/notify_dialog.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/paths.dart';

class ReportDetail extends StatefulWidget {
  final Report? report;
  const ReportDetail({super.key, this.report});

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  late bool isNew = (widget.report == null);
  TextEditingController nameReport = TextEditingController();
  FocusNode nameFocus = FocusNode();
  TextEditingController description = TextEditingController();
  FocusNode descriptionFocus = FocusNode();
  ScrollController descriptionScroll = ScrollController();
  PageController pageController = PageController();

  int nameReportState = IS_DEFAULT_STATE;

  List<Uint8List> imageList = [];
  int type = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    nameFocus.addListener(() {
      if (nameFocus.hasFocus || nameReport.text != '') {
        setState(() {
          nameReportState = IS_DEFAULT_STATE;
        });
      } else if (nameReport.text == '') {
        setState(() {
          nameReportState = IS_ERROR_STATE;
        });
      }
    });
    if (!isNew) {
      nameReport.text = widget.report!.nameReport;
      type = widget.report!.type;
      description.text = widget.report!.description;
      init();
    }
    
  }

  init() async {
    setState(() {
      isLoading = true;
    });

    imageList = await getImageList(photoURL: widget.report!.photoURL);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameReport.dispose();
    nameFocus.dispose();
    description.dispose();
    descriptionFocus.dispose();
    descriptionScroll.dispose();
    pageController.dispose();
  }

  jumpToFirstPage() {
    pageController.jumpToPage(0);
    setState(() {});
  }

  createReport() async {
    if (nameReport.text != "") {
      if (type == 0) {
        showNotify(context: context, content: 'Hãy phân loại báo cáo',
                  isError: true,);
        
      } else {
        showNotify(context: context, isLoading: true);
        String res = await FirebaseMethods().createReport(
            nameReport: nameReport.text,
            type: type,
            description: description.text,
            imageList: imageList);
        if (context.mounted) {
          Navigator.pop(context);
        }
        if (res == 'success') {
          if (context.mounted) {
            Navigator.pop(context);
            showSnackBar(context: context, content: "Tạo thành công");
          }
        } else {
          if (context.mounted) {
            showSnackBar(context: context, content: res, isError: true);
          }
        }
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
          title: const Text("Report"),
          backgroundColor: darkblueAppbarColor,
          centerTitle: true,
        ),
        body: Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 8, right: 8, bottom: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      // text field for name report
                      TextField(
                        controller: nameReport,
                        focusNode: nameFocus,
                        style: const TextStyle(color: blackColor),
                        decoration: InputDecoration(
                            label: Text(
                              "Tiêu đề",
                              style: TextStyle(
                                  color: (isNew)
                                      ? defaultColor
                                      : backgroundWhiteColor),
                            ),
                            contentPadding: const EdgeInsets.only(left: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            helperText: (nameReportState == IS_DEFAULT_STATE)
                                ? null
                                : "Chưa có tiêu đề",
                            helperStyle: const TextStyle(color: errorRedColor),
                            filled: true,
                            fillColor:
                                (isNew) ? backgroundWhiteColor : defaultColor),
                        readOnly: (!isNew),
                      ),
                      const SizedBox(
                        height: 14,
                      ),

                      // type report
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              "Phân loại: ",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          (type == 0 && isNew)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Checkbox(
                                              value: (type == UPDATE_REPORT),
                                              shape: const CircleBorder(),
                                              visualDensity:
                                                  VisualDensity.comfortable,
                                              splashRadius: 0,
                                              onChanged: (value) {
                                                if (value == null || !value) {
                                                  type = 0;
                                                } else {
                                                  type = UPDATE_REPORT;
                                                }
                                                setState(() {});
                                              }),
                                        ),
                                        typeReport(type: UPDATE_REPORT),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Checkbox(
                                              value: (type == BUG_REPORT),
                                              shape: const CircleBorder(),
                                              onChanged: (value) {
                                                if (value == null || !value) {
                                                  type = 0;
                                                } else {
                                                  type = BUG_REPORT;
                                                }
                                                setState(() {});
                                              }),
                                        ),
                                        typeReport(type: BUG_REPORT),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Checkbox(
                                              value: (type == PRIVATE_REPORT),
                                              shape: const CircleBorder(),
                                              onChanged: (value) {
                                                if (value == null || !value) {
                                                  type = 0;
                                                } else {
                                                  type = PRIVATE_REPORT;
                                                }
                                                setState(() {});
                                              }),
                                        ),
                                        typeReport(type: PRIVATE_REPORT),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    typeReport(type: type),
                                    (!isNew)
                                        ? const SizedBox()
                                        : InkWell(
                                            onTap: () {
                                              setState(() {
                                                type = 0;
                                              });
                                            },
                                            child: const Icon(
                                                Icons.cancel_rounded))
                                  ],
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // report description
                      TextField(
                        controller: description,
                        focusNode: descriptionFocus,
                        style: const TextStyle(color: blackColor),
                        decoration: InputDecoration(
                            labelText: "Mô tả",
                            labelStyle: TextStyle(
                                color: (isNew)
                                    ? defaultColor
                                    : backgroundWhiteColor),
                            contentPadding:
                                const EdgeInsets.only(left: 8, top: 24),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            filled: true,
                            fillColor:
                                (isNew) ? backgroundWhiteColor : defaultColor),
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: null,
                        scrollController: descriptionScroll,
                        readOnly: (!isNew),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      // add photo button
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              "Hình ảnh:   ",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          (!isNew)
                              ? const SizedBox()
                              : InkWell(
                                  onTap: () async {
                                    List<Uint8List>? imageAddList =
                                        await pickImages(context);
                                    if (imageAddList != null) {
                                      imageList.addAll(imageAddList);
                                    }
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.add_photo_alternate,
                                    size: 28,
                                    color: correctGreenColor,
                                  )),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // image show
                      (isLoading)
            ? const LinearProgressIndicator()
            : 
                      (imageList.isEmpty)
                          ? const Center(
                            child: Text('Không có hình ảnh minh họa'),
                          )
                          : Container(
                              width: double.infinity,
                              height: 240,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: focusBlueColor, width: 2)),
                              child: PageView.builder(
                                  itemCount: imageList.length,
                                  controller: pageController,
                                  itemBuilder: (context, index) {
                                    return Stack(children: [
                                      SizedBox(
                                          width: double.infinity,
                                          child: Image.memory(
                                            imageList[index],
                                            fit: BoxFit.cover,
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${index + 1}/${imageList.length}",
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            (!isNew)
                                                ? const SizedBox(
                                                    width: 2,
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      imageList.removeAt(index);
                                                      jumpToFirstPage();
                                                    },
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      size: 24,
                                                    ))
                                          ],
                                        ),
                                      ),
                                      (index == 0)
                                          ? Container()
                                          : const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
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
                      const SizedBox(
                        height: 20,
                      ),

                      // create button
                      Center(
                        child: TextBoxButton(
                            color: notifyIconColor,
                            text: "Tạo mới",
                            fontSize: 16,
                            width: 100,
                            height: 40,
                            funtion: createReport),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
