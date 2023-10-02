import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/home/progress/progress_detail.dart';
import 'package:project_management/model/progress.dart';
import 'package:project_management/provider/group_provider.dart';
import 'package:project_management/utils/functions.dart';
import 'package:project_management/utils/parameters.dart';
import 'package:project_management/utils/widgets.dart';
import 'package:provider/provider.dart';

class ProgressCard extends StatefulWidget {
  final Progress progress;
  const ProgressCard({super.key, required this.progress});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  late bool isManager;
  late bool isToday;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    GroupProvider groupProvider =
        Provider.of<GroupProvider>(context, listen: false);
    isManager = groupProvider.getIsManager;
    isToday = isToDay(dateString: widget.progress.date);
  }

  @override
  Widget build(BuildContext context) {
    return card(
      color: isToday ? darkblueAppbarColor : darkblueColor,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ProgressDetailScreen(
                  progress: widget.progress,
                ))),
        title: Text(
          '${isToday ? "(Hôm nay)" : ""} ${widget.progress.date} ',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chỉnh sửa lúc: ${DateFormat('HH:mm EEEE, dd/MM/yyy', 'vi').format(
                widget.progress.createDate,
              )}",
              style: const TextStyle(fontSize: 11),
            ),
            (widget.progress.state != IS_DOING)
                ? const Text(
                    'Đã kiểm duyệt',
                    style: TextStyle(color: correctGreenColor, fontSize: 13),
                  )
                : const Text(
                    'Đang chờ phê duyệt',
                    style: TextStyle(fontSize: 13),
                  ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 30,
        ));
  }
}
