import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final DocumentSnapshot doc;
  const NotificationCard({super.key, required this.doc});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Text(" type: ${widget.doc['type'] }");
  }
}