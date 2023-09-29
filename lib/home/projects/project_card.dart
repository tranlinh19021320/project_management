import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/home/projects/project.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: focusBlueColor),
              borderRadius: BorderRadius.circular(12),
              color: darkblueAppbarColor),
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width * 0.95,
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProjectHomeScreen(project: widget.project)));
            },
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (widget.project.missions != 0)
                        ? Container()
                        : newTextAnimation(),
                    const SizedBox(width: 4,),
                    Center(
                        child: Text(
                      widget.project.nameProject,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontStyle: FontStyle.italic),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Nhiệm vụ: ${widget.project.missions}",
                  style: const TextStyle(
                      fontSize: 15, color: backgroundWhiteColor),
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
            trailing: const Icon(
              Icons.arrow_forward_sharp,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
