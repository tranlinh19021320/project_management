import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/utils/utils.dart';

class NotifyDialog extends StatefulWidget {
  final String content;
  final bool isError;
  const NotifyDialog({super.key, required this.content, this.isError = false});

  @override
  State<NotifyDialog> createState() => _NotifyDialogState();
}

class _NotifyDialogState extends State<NotifyDialog> {
  @override
  Widget build(BuildContext context) {
    return (widget.content == 'loading') ? AlertDialog(
      backgroundColor: Colors.transparent,
      icon: LoadingAnimationWidget.inkDrop(color: darkblueAppbarColor, size: 32),
      title: const Center(child: Text("Loading...", style: TextStyle(fontSize: 18, color: blueDrawerColor,), ), ),
    ) : AlertDialog(
      scrollable: true,
      backgroundColor: darkblueAppbarColor,
      iconPadding:const  EdgeInsets.only(bottom: 0),
      icon:  loudspeakerIcon,
      // backgroundColor: backgroundWhiteColor,
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 12),
      title: Center(
        child: Text(
                widget.content,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: widget.isError ? errorRedColor : correctGreenColor),
              ),
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
