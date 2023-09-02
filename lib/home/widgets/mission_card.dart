import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/admin/utils/mission_detail.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';

class MissionCard extends StatefulWidget {
  final Project project;
  final Mission mission;
  const MissionCard({super.key, required this.mission, required this.project});

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        border: Border.all(color: focusBlueColor),
        color: darkblueAppbarColor,
      ),
      padding: const EdgeInsets.all(4),
      width: MediaQuery.of(context).size.width * 0.95,
      child: ListTile(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MissionDetailScreen(project: widget.project, mission: widget.mission,))),
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        isThreeLine: true,
        leading: SizedBox(
            height: 50,
            width: 50,
            child: circularPercentIndicator(
                percent: widget.mission.percent, radius: 16, fontSize: 7)),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.mission.nameMission,
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text('Phu trach: '),
                Expanded(
                  child: Container(
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: focusBlueColor,
                    ),
                    child: userCard(userId: widget.mission.staffId, size: 28)),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Thời gian:  ${DateFormat('dd/MM/yyy').format(
                widget.mission.startDate,
              )} - ${DateFormat('dd/MM/yyy').format(
                widget.mission.endDate,
              )} ",
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
        subtitle: Text(
          "Chỉnh sửa lúc: ${DateFormat('HH:mm EEEE, dd/MM/yyy', 'vi').format(
            widget.mission.createDate,
          )}",
          style: const TextStyle(fontSize: 11),
        ),
        trailing: const Icon(
          Icons.arrow_forward_sharp,
          size: 30,
        ),
      ),
    );
  }
}
