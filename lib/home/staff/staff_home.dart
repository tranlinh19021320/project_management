import 'package:flutter/material.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key,});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("prpject"),
      ),
      
      body: Center(child: Text('...')),
    );
  }
}