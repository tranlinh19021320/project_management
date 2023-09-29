import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/home/widgets/text_button.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';

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
    return (widget.content == 'loading')
        ? AlertDialog(
            backgroundColor: Colors.transparent,
            icon: LoadingAnimationWidget.inkDrop(
                color: darkblueAppbarColor, size: 32),
            title: const Center(
              child: Text(
                "Loading...",
                style: TextStyle(
                  fontSize: 18,
                  color: blueDrawerColor,
                ),
              ),
            ),
          )
        : AlertDialog(
            scrollable: true,
            backgroundColor: darkblueAppbarColor,
            iconPadding: const EdgeInsets.only(top: 6),
            icon: SizedBox(height: 24, width: 24, child: loudspeakerIcon),
            // backgroundColor: backgroundWhiteColor,
  
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.only(bottom: 12),
            titlePadding: const EdgeInsets.only(top: 8, bottom: 8),
            title: Center(
              child: Text(
                widget.content,
                style: TextStyle(
                    color:
                        widget.isError ? notifyIconColor : correctGreenColor, fontSize: 18),
              ),
            ),
            actions: [
              TextBoxButton(
                  color: notifyIconColor,
                  text: 'OK',
                  fontSize: 16,
                  width: 50,
                  height: 34,
                  funtion: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
  }
}
