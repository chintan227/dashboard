import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/models/booking.dart';

import '../constants.dart';
import '../services/firebase_services.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  List<BookingModel> bookingList = [];
  FirebaseService firebaseService = FirebaseService();
  bool isLoading = true;

  TextStyle titleStyle = GoogleFonts.readexPro(
      fontSize: 18, fontWeight: FontWeight.w500, color: darkGradient);

  TextStyle subTitleStyle = GoogleFonts.readexPro(
      fontSize: 18, fontWeight: FontWeight.w400, color: darkGradient);

  @override
  void initState() {
    super.initState();
    getBookings();
  }

  getBookings() async {
    bookingList = await firebaseService.getAllBookings();
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
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "Bookings",
                          style: GoogleFonts.readexPro(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: darkGradient),
                        ),
                      ),
                      30.height,
                      Expanded(
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Text(
                                'Index',
                                style: titleStyle,
                              ),
                            ),
                            DataColumn(label: Text('ID', style: titleStyle)),
                            DataColumn(
                                label:
                                    Text('Booking Status', style: titleStyle)),
                            DataColumn(
                                label: Text('Service Type', style: titleStyle)),
                            DataColumn(
                                label: Text('User ID', style: titleStyle)),
                            DataColumn(
                                label: Text('Address', style: titleStyle)),
                            DataColumn(
                                label: Text('Vehicle', style: titleStyle)),
                            DataColumn(
                                label: Text('Wash Count', style: titleStyle)),
                            DataColumn(
                                label: Text('Wash Timings', style: titleStyle)),
                            DataColumn(
                                label: Text('Add Service', style: titleStyle)),
                            DataColumn(
                                label:
                                    Text('Remove Service', style: titleStyle)),
                            DataColumn(
                                label: Text('Comments', style: titleStyle)),
                            DataColumn(
                                label: Text('Actions', style: titleStyle)),
                          ],
                          rows: List<DataRow>.generate(
                            bookingList.length,
                            (index) {
                              BookingModel booking = bookingList[index];
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      (index + 1).toString(),
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      booking.id ?? "N/A",
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      booking.bookingStatus.isEmpty
                                          ? "N/A"
                                          : booking.bookingStatus,
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      booking.serviceType.isEmpty
                                          ? "N/A"
                                          : booking.serviceType,
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      booking.userId.isEmpty
                                          ? "N/A"
                                          : booking.userId,
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      booking.address.isEmpty
                                          ? "N/A"
                                          : booking.address,
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      // Assuming you have a property in Vehicle called 'type'
                                      "${booking.vehicle.company ?? "N/A"} - ${booking.vehicle.model ?? "N/A"}",
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      booking.washCount.toString(),
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      "${booking.washTimings.toDate().day} ${DateFormat('MMMM').format(booking.washTimings.toDate()).substring(0, 3)} ${DateFormat("hh:mm a").format(booking.washTimings.toDate())}",
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      booking.addService.isEmpty
                                          ? "N/A"
                                          : booking.addService.join(', '),
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      booking.removeService.isEmpty
                                          ? "N/A"
                                          : booking.removeService.join(', '),
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      (booking.comments?.isEmpty ?? true)
                                          ? "N/A"
                                          : booking.comments.toString(),
                                      style: subTitleStyle,
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _showDeleteDialog(context, booking);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _showDeleteDialog(BuildContext context, BookingModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Booking',
            style: titleStyle,
          ),
          content: Text(
            'Are you sure you want to delete this booking?',
            style: subTitleStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: subTitleStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(user.id!);
                bookingList.remove(user);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: subTitleStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .delete();
      // Perform any additional actions after deletion if needed
    } catch (e) {
      print('Error deleting user: $e');
      // Handle error, e.g., show a snackbar or an error dialog
    }
  }
}
