// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/common/primary_button.dart';
import 'package:wype_dashboard/constants.dart';
import 'package:wype_dashboard/models/employee_model.dart';
import 'package:wype_dashboard/models/packages.dart';
import '../models/location_model.dart';
import '../services/firebase_services.dart';

class NewEmployeeCreate extends StatefulWidget {
  const NewEmployeeCreate({super.key});

  @override
  State<NewEmployeeCreate> createState() => _NewEmployeeCreateState();
}

class _NewEmployeeCreateState extends State<NewEmployeeCreate> {
  List<LocationDetailModel> locationList = [];
  List<ValueItem> valueList = [];
  List selectedLocations = [];
  FirebaseService firebaseService = FirebaseService();
  bool isLoading = true;
  bool isCreate = false;

  TextStyle titleStyle = GoogleFonts.readexPro(fontSize: 18, fontWeight: FontWeight.w500, color: darkGradient);

  TextStyle subTitleStyle = GoogleFonts.readexPro(fontSize: 18, fontWeight: FontWeight.w400, color: darkGradient);

  final MultiSelectController _controller = MultiSelectController();

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController basicSalary = TextEditingController();
  TextEditingController company = TextEditingController();

  String selectedService = 'Wype wash';
  var serviceList = [
    'Wype wash',
    'Silver wash',
  ];

  final CollectionReference packagesCollection = FirebaseFirestore.instance.collection('Employee');

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  getUsers() async {
    locationList = await firebaseService.getLocationDetails();
    for(int i =0;i< locationList.length;i++){
      valueList.add(ValueItem(label: "${locationList[i].name}", value: i));
    }
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
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        isCreate ? Container(): Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: (){
                          isCreate = true;
                          setState(() {});
                        },
                        child: Container(
                          height: 45,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: darkGradient,
                          ),
                          child: Center(
                            child: Text(
                              "Create New",
                              style: GoogleFonts.readexPro(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                        isCreate ? Column(
                          children: [
                            Center(
                              child: Text(
                                "Add New Employee",
                                style: GoogleFonts.readexPro(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: darkGradient,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            buildCommonRow("Name", name),
                            buildCommonRow("Phone No", phone),
                            buildCommonRow("Email Id", email),
                            buildCommonRow("Password", password),
                            buildCommonRow("Basic Salary", basicSalary),
                            buildCommonRow("Company", company),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      "Priority Service",
                                      style: GoogleFonts.readexPro(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: darkGradient,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 300,
                                    height: 45,
                                    child:  MultiSelectDropDown(
                                      controller: _controller,
                                      onOptionSelected: (List<ValueItem> selectedOptions) {
                                        selectedService = selectedOptions[0].label.toString();
                                        setState(() {});
                                      },
                                      options: const <ValueItem>[
                                        ValueItem(label: 'Wype wash', value: 1),
                                        ValueItem(label: 'Silver wash', value: 2),
                                      ],
                                      selectionType: SelectionType.single,
                                      // showClearIcon: false,
                                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                                      optionTextStyle: const TextStyle(fontSize: 16),
                                      selectedOptionIcon: const Icon(Icons.check_circle),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      "Manager Details ",
                                      style: GoogleFonts.readexPro(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: darkGradient,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 300,
                                    height: 45,
                                    child: MultiSelectDropDown(
                                      onOptionSelected: (List<ValueItem> selectedOptions) {
                                        selectedLocations.clear();
                                        for(int i =0;i< selectedOptions.length;i++){
                                          selectedLocations.add(selectedOptions[i].label);
                                        }
                                        print("-selectedLocations----->$selectedLocations");
                                      },
                                      options: valueList,
                                      selectionType: SelectionType.multi,
                                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                                      dropdownHeight: 300,
                                      maxItems: 4,
                                      optionTextStyle: const TextStyle(fontSize: 16),
                                      selectedOptionIcon: const Icon(Icons.check_circle),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Center(child: PrimaryButton(text: "Create Employee", onTap:() {
                              Locations location = Locations();
                              for(int i = 0;i<= selectedLocations.length;i++){
                                print("--length---->${selectedLocations.length}");
                                if(selectedLocations.length == 1){
                                  location.location1 = selectedLocations[0] ??"";
                                }
                                if(selectedLocations.length == 2){
                                  location.location1 = selectedLocations[0] ??"";
                                  location.location2 = selectedLocations[1]??"";
                                }
                                if(selectedLocations.length == 3){
                                  location.location1 = selectedLocations[0] ??"";
                                  location.location2 = selectedLocations[1]??"";
                                  location.location3 = selectedLocations[2]??"";
                                }
                                if(selectedLocations.length == 4){
                                  location.location1 = selectedLocations[0] ??"";
                                  location.location2 = selectedLocations[1]??"";
                                  location.location3 = selectedLocations[2]??"";
                                  location.location4 = selectedLocations[3]??"";
                                }
                              }
                              firebaseService.createEmployee(EmployeeModel(
                                  name: name.text.toString(),
                                  company: company.text.toString(),
                                  password: password.text.toString(),
                                  email: email.text.toString(),
                                  phone: phone.text.toString(),
                                  salary: basicSalary.text.toString(),
                                  priorityService: selectedService.toString(),
                                  locations: location)).then((value) {
                                if(value == false){
                                }else{
                                  toast("Employee Added....");
                                  company.clear();
                                  name.clear();
                                  password.clear();
                                  email.clear();
                                  phone.clear();
                                  basicSalary.clear();
                                  selectedService = "";
                                  selectedLocations.clear();
                                  selectedLocations.clear();
                                  isCreate = false;
                                  setState(() {});
                                }
                              });
                            },),)
                          ],
                        ):
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance.collection('Employee').snapshots(),
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
                                  'No Employee found.',
                                  style: titleStyle,
                                ),
                              );
                            }

                            List<EmployeeModel> employeeModel = snapshot.data!.docs.map((doc) {
                              return EmployeeModel.fromJson(doc.data());
                            }).toList();

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DataTable(
                                columns: [
                                  DataColumn(
                                      label: Text(
                                        'Index',
                                        style: titleStyle,
                                      )),
                                  DataColumn(label: Text('Name', style: titleStyle)),
                                  DataColumn(label: Text('Phone', style: titleStyle)),
                                  DataColumn(label: Text('Email', style: titleStyle)),
                                  DataColumn(label: Text('Company', style: titleStyle)),
                                  DataColumn(label: Text('Service', style: titleStyle)),
                                  DataColumn(label: Text('Salary', style: titleStyle)),
                                  DataColumn(label: Text('Action', style: titleStyle)),
                                ],
                                rows: List<DataRow>.generate(
                                  employeeModel.length, (index) {
                                    print("-----11111------>${ employeeModel[index].name}");
                                  EmployeeModel employee = employeeModel[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(
                                        (index + 1).toString(),
                                        style: subTitleStyle,
                                      )),

                                      DataCell(Text(
                                        employee.name ?? "N/A",
                                        style: subTitleStyle,
                                      )),
                                      DataCell(Text(
                                        employee.phone ?? "N/A",
                                        style: subTitleStyle,
                                      )),
                                      DataCell(Text(
                                        employee.email ?? "N/A",
                                        style: subTitleStyle,
                                      )),
                                      DataCell(Text(
                                        employee.company ?? "N/A",
                                        style: subTitleStyle,
                                      )),
                                      DataCell(Text(
                                        employee.priorityService ?? "N/A",
                                        style: subTitleStyle,
                                      )),
                                      DataCell(Text(
                                        employee.salary ?? "N/A",
                                        style: subTitleStyle,
                                      )),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                _showEditPackageDialog(context,employee);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                // _showDeleteDialog(context, location.name.toString(),location);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _showEditPackageDialog(BuildContext context,EmployeeModel employeeModel) {
    String name = employeeModel.name.toString();
    String phone = employeeModel.phone.toString();
    String email = employeeModel.email.toString();
    String password = employeeModel.password.toString();
    String salary = employeeModel.salary.toString();
    String service = employeeModel.priorityService.toString();
    String company = employeeModel.company.toString();
    // String about = package.about;
    Locations ? location = employeeModel.locations;

    print(location!.toJson());
    // List<String> services = package.services;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Employee',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextField(
                          onChanged: (value) {
                            name = value.toString();
                          },
                          decoration: InputDecoration(labelText: 'Name'),
                          controller: TextEditingController(text: name),
                        ),
                      ),
                      SizedBox(width: 15.0),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          onChanged: (value) {
                            phone = value.toString();
                          },
                          decoration: InputDecoration(labelText: 'Phone'),
                          controller: TextEditingController(text: phone),
                        ),
                      ),
                      SizedBox(width: 15.0),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          onChanged: (value) {
                            salary = value.toString();
                          },
                          decoration: InputDecoration(labelText: 'Salary'),
                          controller: TextEditingController(text: salary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextField(
                          onChanged: (value) {
                            email = value.toString();
                          },
                          decoration: InputDecoration(labelText: 'Email'),
                          controller: TextEditingController(text: email),
                        ),
                      ),
                      SizedBox(width: 15.0),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          onChanged: (value) {
                            password = value.toString();
                          },
                          decoration: InputDecoration(labelText: 'Password'),
                          controller: TextEditingController(text: password),
                        ),
                      ),
                      SizedBox(width: 15.0),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          onChanged: (value) {
                            company = value.toString();
                          },
                          decoration: InputDecoration(labelText: 'Company'),
                          controller: TextEditingController(text: company),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextField(
                          onChanged: (value) {
                            service = value.toString();
                          },
                          decoration: InputDecoration(labelText: 'Service'),
                          controller: TextEditingController(text: service),
                        ),
                      ),
                      SizedBox(width: 15.0),
                       Column(
                children: location.toJson().entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${e.key} : ${e.value}",style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),),
                      ),
                )
                    .toList(),
              ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 8.0),
                      TextButton(
                        onPressed: () {
                          EmployeeModel updatedEmployee = EmployeeModel(
                            name: name,
                            locations: location,
                            priorityService: service,
                            salary: salary,
                            id: employeeModel.id.toString(),
                            phone: phone,
                            email:email,
                            password: password,
                            company: company
                          );

                          _editPackageInFirestore(updatedEmployee,employeeModel.id.toString());
                          Navigator.of(context).pop();
                        },
                        child: Text('Update'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _editPackageInFirestore(EmployeeModel updatedPackage,String id) {
    print("==id===>$id");
    print("=====>$updatedPackage");
    packagesCollection.doc(id).update(updatedPackage.toJson());
    setState(() {});
    print("----------------------DOne---------------");
  }

  buildCommonRow(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              title.toString(),
              style: GoogleFonts.readexPro(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: darkGradient,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 300,
              height: 45,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: title,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.5), width: 10),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
