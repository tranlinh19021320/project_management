import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/home/widgets/missions/mission.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';
import 'package:provider/provider.dart';

class MissionCard extends StatefulWidget {
  final Mission mission;
  const MissionCard({
    super.key,
    required this.mission,
  });

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  late bool isManager;
  late int state;
  @override
  void initState() {
    super.initState();
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;
    state = stateOfMission(
      percent: widget.mission.percent,
      startDate: widget.mission.startDate,
      endDate: widget.mission.endDate);
  }
  String progress() {
    String progress = "Tiến độ: ";
    switch (state) {
      case IS_SUBMIT: 
      progress += '${widget.mission.percent * 100}% (Mới)';
      case IS_COMPLETE:
      progress += '100% (Hoàn thành)';
      case IS_DOING:
      progress += '${widget.mission.percent * 100}% (Đang thực hiện)';
      case IS_LATE:
      progress += '${widget.mission.percent * 100}% (Chậm tiến độ - ${DateTime.now().difference(widget.mission.endDate).inDays + 1} ngày)';
    }
    return progress;
  }
  @override
  Widget build(BuildContext context) {
    return card(
        color: colorStateOfMission(
            percent: widget.mission.percent,
            startDate: widget.mission.startDate,
            endDate: widget.mission.endDate),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MissionHomeScreen(
                  mission: widget.mission,
                ))),
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
                  fontSize: 16,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 4,
            ),
            (!isManager)
                ? Text(
                    'Dự án: ${widget.mission.nameProject}',
                    style: const TextStyle(fontSize: 14),
                  )
                : Container(
                    constraints:
                        const BoxConstraints(maxWidth: 200, maxHeight: 30),
                    child: userCard(
                        userId: widget.mission.staffId,
                        size: 28,
                        fontsize: 14,
                        type: 2),
                  ),
            Text(progress(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
            
            
            
          ],
        ),
        subtitle:Text(
              "${DateFormat('dd/MM/yyy').format(
                widget.mission.startDate,
              )} - ${DateFormat('dd/MM/yyy').format(
                widget.mission.endDate,
              )} (${widget.mission.endDate.difference(widget.mission.startDate).inDays + 1} ngày) ",
              style: const TextStyle(fontSize: 13),
            ),
        trailing: const SizedBox(
          width: 30,
        ));
  }
}
