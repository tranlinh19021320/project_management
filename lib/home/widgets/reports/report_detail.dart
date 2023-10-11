import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/comments/comments_list.dart';
import 'package:project_management/home/widgets/utils/invite_member.dart';
import 'package:project_management/model/report.dart';
import 'package:project_management/model/user.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';

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
  TextEditingController comment = TextEditingController();
  FocusNode commentFocus = FocusNode();
  ScrollController descriptionScroll = ScrollController();
  PageController pageController = PageController();

  bool isOpenComment = true;
  bool isInvite = false;
  int nameReportState = IS_DEFAULT_STATE;

  List<Uint8List> imageList = [];
  int type = 0;

  Uint8List? imageComment;
  bool isLoading = false;
  String photoURL = '';
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

    CurrentUser currentUser = await FirebaseMethods()
        .getCurrentUserByUserId(userId: FirebaseAuth.instance.currentUser!.uid);
    photoURL = currentUser.photoURL;

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
    comment.dispose();
    commentFocus.dispose();
  }

  jumpToFirstPage() {
    pageController.jumpToPage(0);
    setState(() {});
  }

  createReport() async {
    if (nameReport.text != "") {
      if (type == 0) {
        showNotify(
          context: context,
          content: 'Hãy phân loại báo cáo',
          isError: true,
        );
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

  postComment() async {
    if (imageComment != null || comment.text != '') {
      showNotify(context: context, isLoading: true);
      String res = await FirebaseMethods().postComment(
          report: widget.report!,
          comment: comment.text,
          imageFile: imageComment);
      if (context.mounted) {
        Navigator.pop(context);
      }

      if (res == 'success') {
        imageComment = null;
        comment.text = '';

        setState(() {});
        if (context.mounted) {
          showSnackBar(context: context, content: "Đã đăng thành công");
        }
      } else {
        if (context.mounted) {
          showSnackBar(context: context, content: res, isError: true);
        }
      }
      commentFocus.unfocus();
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
          actions: isNew ? null : [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: textBoxButton(color: darkblueColor, text: "Mời", height: 20, width: 50, fontSize: 14, function: () {
                showCupertinoModalPopup(context: context, builder: (_) => InviteMember(report: widget.report!,));
              } ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isNew
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            getCircleImageFromUrl(widget.report!.ownPhotoURL, radius: 24),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.report!.ownName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                            color:
                                (isNew) ? defaultColor : backgroundWhiteColor),
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
                      fillColor: (isNew) ? backgroundWhiteColor : defaultColor),
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
                                      child: const Icon(Icons.cancel_rounded))
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
                          color: (isNew) ? defaultColor : backgroundWhiteColor),
                      contentPadding: const EdgeInsets.only(left: 8, top: 24),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      filled: true,
                      fillColor: (isNew) ? backgroundWhiteColor : defaultColor),
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
                    ? const LinearProgressIndicator(
                        color: correctGreenColor,
                      )
                    : (imageList.isEmpty)
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
                                                      const Duration(
                                                          seconds: 2)),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.done) {
                                                      return const Text('');
                                                    } else {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                            color: darkblueAppbarColor,
                                                            borderRadius:BorderRadius.circular(50)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(vertical: 4, horizontal:6),
                                                          child: Text(
                                                            "${index + 1}/${imageList.length}",
                                                            style:
                                                                const TextStyle( fontSize: 15),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }),
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
                isNew
                    ? Center(
                        child: textBoxButton(
                            color: notifyIconColor,
                            text: "Tạo mới",
                            fontSize: 16,
                            function: createReport),
                      )
                    // comments
                    : Column(
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () async {
                                setState(() {
                                  isOpenComment = !isOpenComment;
                                });
                              },
                              child: Container(
                                width: 110,
                                decoration: BoxDecoration(
                                    border: Border.all(color: focusBlueColor),
                                    borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Bình luận",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    AnimatedSwitcher(
                                      duration: const Duration(seconds: 2),
                                      transitionBuilder: ((child, animation) =>
                                          RotationTransition(
                                            turns: isOpenComment
                                                ? Tween<double>(
                                                        begin: 1, end: 0.5)
                                                    .animate(animation)
                                                : Tween<double>(
                                                        begin: 0.5, end: 1)
                                                    .animate(animation),
                                            child: ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            ),
                                          )),
                                      child:
                                          const Icon(Icons.arrow_drop_up_sharp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // last comments
                          const Divider(
                            color: correctGreenColor,
                          ),
                          isOpenComment ? CommentList(
                            report: widget.report!,
                          ) : Container()
                        ],
                      )
              ],
            ),
          ),
        ),
        // comment
        bottomNavigationBar: isNew ? null : bottomCommentPost(),
      ),
    );
  }

  Widget bottomCommentPost() {
    return SafeArea(
      child: Container(
        height:
            (imageComment == null) ? kToolbarHeight + 5 : kToolbarHeight + 200,
        decoration: BoxDecoration(
          color: darkblueAppbarColor,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          border: Border.all(color: focusBlueColor),
        ),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(
          left: 4,
          right: 4,
          bottom: 5,
          top: 5,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              (imageComment == null)
                  ? Container()
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 65),
                          child: Stack(
                            children: [
                              SizedBox(
                                  height: 180,
                                  width: 240,
                                  child: Image.memory(
                                    imageComment!,
                                    fit: BoxFit.cover,
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 210, top: 4),
                                child: InkWell(
                                  onTap: () {
                                    imageComment = null;
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    color: errorRedColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1.3,
                          color: focusBlueColor,
                        )
                      ],
                    ),
              Row(
                children: [
                   (isLoading)
                    ? const CircularProgressIndicator(
                        color: correctGreenColor,
                      )
                    : getCircleImageFromUrl(photoURL, radius: 20),
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextField(
                        controller: comment,
                        focusNode: commentFocus,
                        style: const TextStyle(color: blackColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8),
                          filled: true,
                          fillColor: backgroundWhiteColor,
                          hintText: "Comment",
                          hintStyle: const TextStyle(color: defaultColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: null,
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        imageComment =
                            await selectAImage(context: context, isSave: false);
                        setState(() {
                          isLoading = false;
                        });
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.add_a_photo,
                        color: correctGreenColor,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(right: 3, left: 8),
                    child: InkWell(
                        onTap: postComment,
                        child: const Icon(
                          Icons.send,
                          color: focusBlueColor,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
