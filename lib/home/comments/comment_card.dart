import 'package:flutter/material.dart';
import 'package:project_management/model/comment.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';

class CommentCard extends StatefulWidget {
  final CommentReport comment;
  const CommentCard({
    super.key,
    required this.comment,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 6,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          // isThreeLine: true,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.comment.photoURL),
            radius: 16,
          ),
          title: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: darkblueAppbarColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: focusBlueColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                widget.comment.ownName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              (widget.comment.comment == '')
                  ? Container()
                  : Text(widget.comment.comment),
              (widget.comment.photoComment == '')
                  ? Container()
                  : Image.network(
                      widget.comment.photoComment,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    )
            ]),
          ),
          subtitle: Text(timeDateWithNow(date: widget.comment.createDate)),
        ),
      ],
    );
  }
}
