import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_management/home/widgets/button.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/icons.dart';

showNotify(
    {required BuildContext context,
    String content = '',
    bool isLoading = false,
    bool isError = false}) {
  return isLoading
      ? showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => AlertDialog(
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
              ))
      : showDialog(
          context: context,
          builder: (_) => AlertDialog(
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
                    content,
                    style: TextStyle(
                        color: isError ? notifyIconColor : correctGreenColor,
                        fontSize: 18),
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
              ));
}
