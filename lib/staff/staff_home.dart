import 'package:flutter/material.dart';

class StaffHomeScreen extends StatefulWidget {
  final String userId;
  const StaffHomeScreen({super.key, r, required this.userId});

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