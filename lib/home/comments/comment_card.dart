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
    return 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: getCircleImageFromUrl(url: widget.comment.photoURL, radius: 16)
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: darkblueAppbarColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: focusBlueColor)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              widget.comment.ownName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          (widget.comment.comment == '')
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    widget.comment.comment,
                                    
                                  ),
                                ),
                        ]),
                  ),
                  (widget.comment.photoComment == '')
                      ? Container()
                      : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.network(
                            widget.comment.photoComment,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                      ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(timeDateWithNow(date: widget.comment.createDate)),
                  ),
                ],
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          ),
        );
      
  }
}
