import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/home/reports/report_detail.dart';
import 'package:project_management/model/report.dart';
import 'package:project_management/utils/colors.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';

class ReportCard extends StatefulWidget {
  final Report report;
  const ReportCard({super.key, required this.report});

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  late bool isOwner =
      (widget.report.ownId == FirebaseAuth.instance.currentUser!.uid);
  String description() {
    String description = widget.report.description;
    int maxlength = 40;
    if (description.length > maxlength) {
      description = description.substring(0, maxlength);
      description = "$description...";
    }
    description = description.replaceAll('\n', ", ");
    return description;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: focusBlueColor),
            borderRadius: BorderRadius.circular(12),
            color: darkblueAppbarColor,
          ),
          padding: const EdgeInsets.only(left: 8, right: 14),
          width: MediaQuery.of(context).size.width * 0.98,
          child: ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ReportDetail(
                      report: widget.report,
                    ))),
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            // isThreeLine: true,
            title: Row(
              children: [
                (widget.report.type == UPDATE_REPORT)
                    ?const Icon(
                        Icons.update,
                        color: focusBlueColor,
                        size: 18,
                      )
                    : (widget.report.type == BUG_REPORT)
                        ?const Icon(
                            Icons.error,
                            color: errorRedColor,
                            size: 18,
                          )
                        : const Icon(
                            Icons.more,
                            color: notifyIconColor,
                            size: 18,
                          ),
                        const SizedBox(width: 4,),
                Text(widget.report.nameReport),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      "Mô tả: ${description()}", style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                Text(
                  'Cập nhật ${timeDateWithNow(date: widget.report.createDate)}',
                  style: const TextStyle(fontSize: 10, color: notifyIconColor),
                )
              ],
            ),
            leading: isOwner ? null : CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.report.ownPhotoURL, ),
            ),
            trailing: (isOwner && !widget.report.ownRead) ?
             newTextAnimation()
             : (!isOwner && !widget.report.managerRead) ? 
             newTextAnimation()
             : null,
          ),
        ),
      ],
    );
  }
}
