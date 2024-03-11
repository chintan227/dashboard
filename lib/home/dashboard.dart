import 'package:flutter/material.dart';
import 'package:wype_dashboard/constants.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
    );
  }
}
