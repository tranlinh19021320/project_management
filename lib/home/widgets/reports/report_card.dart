import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/firebase/firebase_methods.dart';
import 'package:project_management/home/widgets/reports/report_detail.dart';
import 'package:project_management/model/report.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';

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

  changeIsReadState() async {
    String res = '';
    if (isOwner && !widget.report.ownRead) {
      res = await FirebaseMethods().changeIsReadReportState(
          report: widget.report, isManager: !isOwner, isRead: true);
    } else if (!isOwner && !widget.report.managerRead) {
      res = await FirebaseMethods().changeIsReadReportState(
          report: widget.report, isManager: !isOwner, isRead: true);
      print(res);
    }

    if (res != 'success' && res != '') {
      if (context.mounted) {
        showNotify(context: context, content: res, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return card(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ReportDetail(
                    report: widget.report,
                  )));
          changeIsReadState();
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (isOwner)
                ? Container()
                : Text(
                    widget.report.ownName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
            Row(
              children: [
                (widget.report.type == UPDATE_REPORT)
                    ? const Icon(
                        Icons.update,
                        color: focusBlueColor,
                        size: 18,
                      )
                    : (widget.report.type == BUG_REPORT)
                        ? const Icon(
                            Icons.error,
                            color: errorRedColor,
                            size: 18,
                          )
                        : const Icon(
                            Icons.more,
                            color: notifyIconColor,
                            size: 18,
                          ),
                const SizedBox(
                  width: 4,
                ),
                Text(widget.report.nameReport),
              ],
            ),
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
                  "Mô tả: ${description()}",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 4,),
            Text(
              'Cập nhật ${timeDateWithNow(date: widget.report.createDate)}',
              style: const TextStyle(fontSize: 10, color: notifyIconColor),
            )
          ],
        ),
        leading: isOwner
            ? null
            : getCircleImageFromUrl(widget.report.ownPhotoURL, radius: 17),
        trailing: (isOwner && !widget.report.ownRead)
            ? newTextAnimation()
            : (!isOwner && !widget.report.managerRead)
                ? newTextAnimation()
                : null);
  }
}
