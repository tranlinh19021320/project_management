import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/home/widgets/projects/project.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    return card(
      color: dateInTime(startDate: widget.project.startDate, endDate: widget.project.endDate) ? darkblueAppbarColor : darkblueColor,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProjectHomeScreen(project: widget.project))),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.project.nameProject,
              textAlign: TextAlign.center,
              softWrap: true,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Nhiệm vụ: ${widget.project.missions}",
              style: const TextStyle(fontSize: 15, color: backgroundWhiteColor),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "Thời gian:  ${DateFormat('dd/MM/yyy').format(
                widget.project.startDate,
              )} - ${DateFormat('dd/MM/yyy').format(
                widget.project.endDate,
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
            widget.project.createDate,
          )}",
          style: const TextStyle(fontSize: 11),
        ),
        trailing: (widget.project.missions != 0) ? null : newTextAnimation());
  }
}
