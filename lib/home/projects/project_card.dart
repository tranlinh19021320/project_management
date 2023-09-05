import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/home/projects/project.dart';
import 'package:project_management/model/project.dart';
import 'package:project_management/utils/colors.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {

  String percent() {
    return (widget.project.missions == 0 ||
            widget.project.completedMissions == 0)
        ? '0%'
        : NumberFormat('##.00%').format(
            (widget.project.completedMissions.toDouble() /
                widget.project.missions.toDouble()));
  }

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
                        : AnimatedTextKit(repeatForever: true,
                        
                        pause: const Duration(milliseconds: 0),
                         animatedTexts: [
                            ColorizeAnimatedText('New    ',
                                textStyle: const TextStyle(fontSize: 14),
                                colors: [
                                  Colors.yellow,
                                  Colors.red,
                                  Colors.green,
                                  Colors.black,
                                  Colors.blue,
                                  Colors.purple,
                                  Colors.white,
                                ]),
                                
                          ]),
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
                  "Nhiệm vụ: ${widget.project.completedMissions}/${widget.project.missions}  (${percent()})",
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
