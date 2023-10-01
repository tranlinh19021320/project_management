import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/page_list.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/icons.dart';

class TextBoxButton extends StatefulWidget {
  final Color color;
  final String text;
  final double fontSize;
  final double width;
  final double height;
  final double padding;
  final double radius;
  final VoidCallback? funtion;
  const TextBoxButton(
      {super.key,
      this.padding = 8,
      this.radius = 12,
      required this.color,
      required this.text,
      required this.fontSize,
      required this.width,
      required this.height,
      required this.funtion});

  @override
  State<TextBoxButton> createState() => _TextBoxButtonState();
}

class _TextBoxButtonState extends State<TextBoxButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.funtion,
      child: Container(
        padding: EdgeInsets.all(widget.padding),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius)),
          color: widget.color,
        ),
        width: widget.width,
        height: widget.height,
        child: Center(
            child: Text(
          widget.text,
          style: TextStyle(fontSize: widget.fontSize),
        )),
      ),
    );
  }
}

ListTile menuListTile({
  required BuildContext context,
  required int selectPage,
  bool? isNotify,
  required int pageValue,
}) {

  return ListTile(
    tileColor: (selectPage == pageValue) ? focusBlueColor : Colors.transparent,
    shape: RoundedRectangleBorder(
        side: const BorderSide(color: focusBlueColor),
        borderRadius: BorderRadius.circular(12)),
    leading: leadingIcon(page: pageValue),
    trailing: (selectPage == pageValue)
        ? rightArrowPageIcon
        : (isNotify != null)
            ? getNumberNotifications(
                isBottom: false,
                size: 28,
                fontSize: 13,
                isNotify: isNotify,
              )
            : null,
    title: Text(
      namePage(page: pageValue),
      style: const TextStyle(fontSize: 16),
    ),
    onTap: () async {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => screen(page: pageValue)));
      if (isNotify != null) {
        String res = "";
        if (isNotify) {
          res = await FirebaseMethods().refreshNotifyNumber();
        } else {
          res = await FirebaseMethods().refreshReportNumber();
        }

        if (res != 'success') {
          if (context.mounted) {
            showSnackBar(context: context, content: res, isError: true);
          }
        }
      }
    },
  );
}
