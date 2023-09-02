import 'package:flutter/material.dart';
import 'package:project_management/model/mission.dart';

class MissionCard extends StatefulWidget {
  final Mission mission;
  const MissionCard({super.key, required this.mission});

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.mission.nameMission);
  }
}