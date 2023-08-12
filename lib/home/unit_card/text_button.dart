import 'package:flutter/material.dart';

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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius)),
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
