// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/common/primary_button.dart';
import 'package:wype_dashboard/constants.dart';
import 'package:wype_dashboard/models/employee_model.dart';
import 'package:wype_dashboard/models/shift_model.dart';
import 'package:wype_dashboard/services/firebase_services.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  List<EmployeeModel> userList = [];
  List<ShiftModel> shiftList = [];
  FirebaseService firebaseService = FirebaseService();
  bool isLoading = false;
  bool isEdit = false;
  int selectIndex = 0;

  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String date = "";
  String startTime = "6:00";
  String endTime = "1:30";

  var timingList = [
    '6:00',
    '6:30',
    '7:00',
    '7:30',
    '8:00',
    '8:30',
    '9:00',
    '9:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
  ];
  var timingList2 = [
    '1:00',
    '1:30',
    '2:00',
    '2:30',
    '3:00',
    '3:30',
    '4:00',
    '4:30',
    '5:00',
    '5:30',
    '6:00',
    '6:30',
    '7:00',
    '7:30',
    '8:00',
    '8:30',
  ];

  final CollectionReference packagesCollection =
      FirebaseFirestore.instance.collection('Employee');

  TextStyle titleStyle = GoogleFonts.readexPro(
      fontSize: 20, fontWeight: FontWeight.bold, color: darkGradient);

  TextStyle subTitleStyle = GoogleFonts.readexPro(
      fontSize: 18, fontWeight: FontWeight.w400, color: darkGradient);

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  getUsers() async {
    userList = await firebaseService.getEmployee();
    shiftList = await firebaseService.getShiftData();
    print("---shift--->$shiftList");
    date = formatter.format(selectedDate);
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
              child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Add New Shift",
                                style: GoogleFonts.readexPro(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: darkGradient,
                                ),
                              ),
                              Row(children: [
                                Text("Start Time : "),
                                DropdownButton(
                                  value: startTime.toString(),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: timingList.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      startTime = newValue!;
                                      print("---Start--->$startTime");
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Text("End Time : "),
                                DropdownButton(
                                  value: endTime.toString(),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: timingList2.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    endTime = newValue!;
                                    print("---end--->$endTime");
                                    setState(() {});
                                  },
                                ),
                              ]),
                              Row(
                                children: [
                                  TextButton(
                                    child: Text("Reset"),
                                    onPressed: () {
                                      startTime = "6:00";
                                      endTime = "1:00";
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(
                                    child: Text("Save"),
                                    onPressed: () async {
                                     if(isEdit){
                                       isLoading = true;
                                       setState(() {});
                                       print("-----$selectIndex");
                                        ShiftModel data = ShiftModel(
                                            id: (selectIndex).toString(),
                                            startTime: startTime,
                                            endTime: endTime);
                                       print("--Data---${data.id}");
                                       await FirebaseFirestore.instance
                                            .collection('shift')
                                            .where('id', isEqualTo: selectIndex.toString()) // Replace with your condition
                                            .get().then((querySnapshot) {
                                         print("-querySnapshot-------->>>>>${querySnapshot.docs}");

                                          querySnapshot.docs.forEach((documentSnapshot) async {
                                            print("--------->>>>>${documentSnapshot.data()}");
                                            print("--------->>>>>${documentSnapshot.id}");
                                            await FirebaseFirestore.instance
                                                .collection('shift')
                                                .doc(documentSnapshot.id)
                                                .update(data.toJson());
                                          });
                                          return querySnapshot;
                                        });
                                       shiftList.removeAt(selectIndex-1);
                                       shiftList.add(data);
                                        selectIndex = 0;
                                        isEdit = false;
                                        isLoading = false;
                                        setState(() {});
                                      }else if(shiftList.length>=3){
                                       toast("Add only 3 shift.....");
                                     }else {
                                        ShiftModel data = ShiftModel(
                                            id: (shiftList.length + 1).toString(),
                                            startTime: startTime,
                                            endTime: endTime);
                                        await firebaseService
                                            .addShift(data)
                                            .then((value) {
                                          if (value == true) {
                                            toast("Shift Created....");
                                            shiftList.add(ShiftModel(
                                                startTime: startTime,
                                                endTime: endTime));
                                            setState(() {});
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "All Shift List",
                                style: GoogleFonts.readexPro(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: darkGradient,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: shiftList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.black)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text("${index + 1}.  ${shiftList[index].startTime} AM  To  ${shiftList[index].endTime} PM"),
                                            Spacer(),
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              onPressed: () {
                                                isEdit = true;
                                                startTime = shiftList[index].startTime;
                                                endTime = shiftList[index].endTime;
                                                selectIndex = shiftList[index].id.toInt();
                                                setState(() {});
                                                // _showDeleteDialog(context, user);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 2,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: PrimaryButton(
                        text: "Select Date",
                        onTap: () => _selectDate(context),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "All Bikers",
                          style: GoogleFonts.readexPro(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: darkGradient,
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          date.toString(),
                          style: GoogleFonts.readexPro(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: iconColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          print(userList[index]);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white54,
                                      border: Border.all(
                                          color: Colors.black54, width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(userList[index].name.toString(),
                                            style: titleStyle),
                                        TextButton(
                                            onPressed: () {
                                              AlertDialog dialong = AlertDialog(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text("Select One Shift :"),
                                              actions: [ SizedBox(
                                                child: Container(
                                                  height:250,
                                                  width: 300,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: shiftList.length,
                                                    itemBuilder: (context, index) {
                                                      return InkWell(
                                                        onTap: () {},
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: TextButton(
                                                            onPressed: () {
                                                                Navigator.pop(context);
                                                            },
                                                            child:Text("${index + 1}.  ${shiftList[index].startTime} AM  To  ${shiftList[index].endTime} PM")),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )],);
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return dialong;
                                                },
                                              );
                                            },
                                            child: Text(
                                              "Select Shift",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 20,
                                  height: 2,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("8:15", style: subTitleStyle),
                                Text("9:15", style: subTitleStyle),
                                Text("10:15", style: subTitleStyle),
                                Text("11:15", style: subTitleStyle),
                                Text("12:15", style: subTitleStyle),
                              ],
                            ),
                          );
                        },
                        itemCount: userList.length,
                      ),
                    )
                  ],
                ),
              ),
            )),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        date = formatter.format(picked);
        print(date); //
      });
    }
  }
}
