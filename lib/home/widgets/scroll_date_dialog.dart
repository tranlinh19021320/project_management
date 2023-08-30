import 'package:flutter/material.dart';
import 'package:project_management/home/widgets/text_button.dart';
import 'package:project_management/utils/utils.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class ScrollDateDialog extends StatefulWidget {
  final DateTime dateTime;
  final String title;
  const ScrollDateDialog({
    super.key,
    required this.title,
    required this.dateTime,
  });

  @override
  State<ScrollDateDialog> createState() => _ScrollDateDialogState();
}

class _ScrollDateDialogState extends State<ScrollDateDialog> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.dateTime;
  }

  cancel() {
    Navigator.pop(context, widget.dateTime);
  }

  submit() {
    Navigator.pop(context, selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: darkblueAppbarColor,
      title: Center(child: Text(widget.title)),
      content: SizedBox(
        height: 200,
        width: 200,
        child: ScrollDatePicker(
            selectedDate: selectedDate,
            minimumDate: DateTime.now(),
            maximumDate: DateTime(DateTime.now().year + 5),
            locale: const Locale('vi'),
            onDateTimeChanged: (DateTime value) {
              setState(() {
                selectedDate = value;
              });
            }),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextBoxButton(
            color: focusBlueColor,
            text: "Ok",
            fontSize: 13,
            width: 40,
            height: 40,
            funtion: submit)
      ],
    );
  }
}
