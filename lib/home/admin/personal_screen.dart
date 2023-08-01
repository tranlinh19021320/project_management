import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import 'drawer_bar.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({
    super.key,
  });

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(backgroundImage), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: darkblueAppbarColor,
          title: const Text("Nhân sự"),
        ),
        drawer: const DrawerBar(),
        body: const Center(child: Text('...')),
      ),
    );
  }
}
