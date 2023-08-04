import 'package:flutter/material.dart';
import 'package:project_management/utils/utils.dart';

class CreateStaff extends StatefulWidget {
  const CreateStaff({super.key});

  @override
  State<CreateStaff> createState() => _CreateStaffState();
}

class _CreateStaffState extends State<CreateStaff> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: darkblueAppbarColor,
      title: const Center(child: Text("Tạo tài khoản nhân viên", style: TextStyle(fontSize: 16),)),
      content: const Column(children: [

      ]),
      
    );
  }
}