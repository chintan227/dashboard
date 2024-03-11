// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wype_dashboard/constants.dart';
import 'package:wype_dashboard/models/user.dart';

import '../services/firebase_services.dart';

class BonusPage extends StatefulWidget {
  const BonusPage({super.key});

  @override
  State<BonusPage> createState() => _BonusPageState();
}

class _BonusPageState extends State<BonusPage> {
  List<UserModel> userList = [];
  FirebaseService firebaseService = FirebaseService();
  bool isLoading = false;

  TextStyle titleStyle = GoogleFonts.readexPro(
      fontSize: 18, fontWeight: FontWeight.w500, color: darkGradient);

  TextStyle subTitleStyle = GoogleFonts.readexPro(
      fontSize: 18, fontWeight: FontWeight.w400, color: darkGradient);

  @override
  void initState() {
    super.initState();
    // getUsers();
  }

  getUsers() async {
    userList = await firebaseService.getUserDetails();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: darkGradient,
              ),
            )
          : FadeIn(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ),
    );
  }

  void _showDeleteDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(user.id!);
                userList.remove(user);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      // Perform any additional actions after deletion if needed
    } catch (e) {
      print('Error deleting user: $e');
      // Handle error, e.g., show a snackbar or an error dialog
    }
  }
}
