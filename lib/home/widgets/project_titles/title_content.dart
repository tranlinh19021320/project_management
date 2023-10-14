import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/model/title.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';

class TitleContent extends StatefulWidget {
  final Project? project;
  final TitleProject? title;
  const TitleContent({super.key, this.project, this.title});

  @override
  State<TitleContent> createState() => _TitleContentState();
}

class _TitleContentState extends State<TitleContent> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      controller.text = widget.title!.title;
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    focusNode.dispose();
    scrollController.dispose();
  }

  createTitle() async {
    if (controller.text != '') {
      showNotify(context: context, isLoading: true);
      String res = await FirebaseMethods()
          .createTitle(project: widget.project!, titleContent: controller.text);
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (res == 'success') {
        if (context.mounted) {
          Navigator.pop(context);
          showNotify(context: context, content: "Tạo tiêu đề thành công");
        }
      } else {
        if (context.mounted) {
          showNotify(context: context, content: res, isError: true);
        }
      }
    }
  }

  updateTitle() async {
    if (controller.text != '') {
      showNotify(context: context, isLoading: true);
      String res = await FirebaseMethods()
          .updateTitleContent(titleProject: widget.title!, titleContent: controller.text);
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (res == 'success') {
        if (context.mounted) {
          Navigator.pop(context);
          showNotify(context: context, content: "Chỉnh sửa tiêu đề thành công");
        }
      } else {
        if (context.mounted) {
          showNotify(context: context, content: res, isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      titlePadding: const EdgeInsets.all(4),
      title: const Center(
          child: Text(
        "Tiêu đề",
        style:
            TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),
      )),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Nhập tiêu đề",
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          keyboardType: TextInputType.multiline,
          scrollController: scrollController,
          minLines: 1,
          maxLines: 10,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        textBoxButton(
          color: buttonGreenColor,
          text: 'OK',
          width: 50,
          height: 30,
          function: (widget.project != null) ? createTitle : updateTitle
        ),
        textBoxButton(
          color: darkblueAppbarColor,
          text: 'Hủy',
          width: 50,
          height: 30,
          function: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
