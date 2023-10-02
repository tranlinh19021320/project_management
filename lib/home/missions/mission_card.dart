import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/home/missions/mission.dart';
import 'package:project_management/model/mission.dart';
import 'package:project_management/provider/group_provider.dart';
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
  @override
  void initState() {
    super.initState();
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;
  }

  @override
  Widget build(BuildContext context) {
    return card(
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
                        const BoxConstraints(maxWidth: 200, maxHeight: 45),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: darkblueColor,
                      border: Border.all(),
                    ),
                    child: userCard(
                        userId: widget.mission.staffId, size: 28, fontsize: 14),
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
        trailing: const SizedBox(
          width: 30,
        ));
  }
}
