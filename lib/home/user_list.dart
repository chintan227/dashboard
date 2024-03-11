import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/constants.dart';
import 'package:wype_dashboard/models/user.dart';

import '../services/firebase_services.dart';

class UserList extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  final TextStyle titleStyle = GoogleFonts.readexPro(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: darkGradient,
  );

  final TextStyle subTitleStyle = GoogleFonts.readexPro(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: darkGradient,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: darkGradient,
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No users found.',
                style: titleStyle,
              ),
            );
          }

          List<UserModel> userList = snapshot.data!.docs.map((doc) {
            return UserModel.fromJson(doc.data());
          }).toList();

          return FadeIn(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.height,
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Users",
                    style: GoogleFonts.readexPro(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: darkGradient,
                    ),
                  ),
                ),
                30.height,
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              'Index',
                              style: titleStyle,
                            ),
                          ),
                          DataColumn(label: Text('ID', style: titleStyle)),
                          DataColumn(label: Text('Name', style: titleStyle)),
                          DataColumn(
                            label: Text('Contact', style: titleStyle),
                          ),
                          DataColumn(
                            label: Text('Gender', style: titleStyle),
                          ),
                          DataColumn(
                            label: Text('Points', style: titleStyle),
                          ),
                          DataColumn(
                            label: Text('Wallet', style: titleStyle),
                          ),
                          DataColumn(
                            label: Text('Actions', style: titleStyle),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                          userList.length,
                          (index) {
                            UserModel user = userList[index];
                            return DataRow(
                              cells: [
                                DataCell(Text(
                                  (index + 1).toString(),
                                  style: subTitleStyle,
                                )),
                                DataCell(Text(
                                  user.id ?? "N/A",
                                  style: subTitleStyle,
                                )),
                                DataCell(Text(
                                  user.name ?? "N/A",
                                  style: subTitleStyle,
                                )),
                                DataCell(Text(
                                  user.contact ?? "N/A",
                                  style: subTitleStyle,
                                )),
                                DataCell(Text(
                                  user.gender ?? "N/A",
                                  style: subTitleStyle,
                                )),
                                DataCell(Text(
                                  user.points.toString(),
                                  style: subTitleStyle,
                                )),
                                DataCell(Text(
                                  user.wallet.toString() + " QAR",
                                  style: subTitleStyle,
                                )),
                                DataCell(
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _showDeleteDialog(context, user);
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete User',
            style: titleStyle,
          ),
          content: Text(
            'Are you sure you want to delete this user?',
            style: subTitleStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: subTitleStyle),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(user.id!);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: subTitleStyle),
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
