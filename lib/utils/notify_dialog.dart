import 'package:flutter/material.dart';
import 'package:project_management/utils/utils.dart';

class NotifyDialog extends StatefulWidget {
  final String content;
  final bool isError;
  const NotifyDialog({super.key, required this.content, required this.isError});

  @override
  State<NotifyDialog> createState() => _NotifyDialogState();
}

class _NotifyDialogState extends State<NotifyDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shadowColor: !widget.isError ? correctGreenColor : errorRedColor,
      icon: const Icon(Icons.notification_important_sharp, color: notifyIconColor,),
            // backgroundColor: backgroundWhiteColor,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 12),
      title: Center(
        child: Text(widget.content, style: TextStyle(fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: widget.isError ? errorRedColor : correctGreenColor),),
      ),
      actions: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
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
      ],
      
    );
  }
}