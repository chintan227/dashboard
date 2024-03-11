import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/common/primary_button.dart';
import 'package:wype_dashboard/constants.dart';
import 'package:wype_dashboard/models/company_model.dart';
import 'package:wype_dashboard/models/location_model.dart';
import 'package:wype_dashboard/services/firebase_services.dart';

class CompanyCreate extends StatefulWidget {
  const CompanyCreate({super.key});

  @override
  State<CompanyCreate> createState() => _CompanyCreateState();
}

class _CompanyCreateState extends State<CompanyCreate> {
  List<CompanyModel> companyList = [];
  FirebaseService firebaseService = FirebaseService();
  bool isLoading = true;
  bool isCreate = false;

  TextStyle titleStyle = GoogleFonts.readexPro(fontSize: 18, fontWeight: FontWeight.w500, color: darkGradient);

  TextStyle subTitleStyle = GoogleFonts.readexPro(fontSize: 18, fontWeight: FontWeight.w400, color: darkGradient);

  TextEditingController name = TextEditingController();
  TextEditingController percentage = TextEditingController();
  TextEditingController revenue = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    companyList = await firebaseService.getCompanyList();
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
                          Center(
                            child: Text("Create New Company",style: GoogleFonts.readexPro(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: darkGradient,
                              decoration: TextDecoration.underline,
                            ),),
                          ),
                          const SizedBox(height: 30,),

                          buildCommonRow('Company Name',name),
                          buildCommonRow('Percentage  ',percentage),
                          buildCommonRow('Total revenue ',revenue),

                          PrimaryButton(text: "Create", onTap:  () {
                            firebaseService.createCompany(CompanyModel(
                                id: name.text.toString(),
                                companyName: name.text.toString(),
                                percentage: percentage.text.toString(),
                                revenue: revenue.text.toString(),
                               )).then((value) {
                              if(value == false){

                              }else{
                                companyList.add(CompanyModel(companyName: name.text.toString(), percentage: percentage.text.toString(), revenue: revenue.text.toString()));
                                toast("Employee Added....");
                                name.clear();
                                percentage.clear();
                                revenue.clear();
                                isCreate = false;
                                setState(() {});
                              }

                              // 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
                            });
                          },),
                          companyList.isEmpty ? SizedBox():
                          DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                    'Index',
                                    style: titleStyle,
                                  )),
                              DataColumn(label: Text('Company Name', style: titleStyle)),
                              DataColumn(label: Text('Percentage', style: titleStyle)),
                              DataColumn(label: Text('Revenue', style: titleStyle)),
                              DataColumn(label: Text('Actions', style: titleStyle)),
                            ],
                            rows: List<DataRow>.generate(
                              companyList.length,
                                  (index) {
                                CompanyModel company = companyList[index];
                                return DataRow(
                                  cells: [
                                    DataCell(Text(
                                      (index + 1).toString(),
                                      style: subTitleStyle,
                                    )),
                                    DataCell(Text(
                                      company.companyName ?? "N/A",
                                      style: subTitleStyle,
                                    )),
                                    DataCell(Text(
                                      company.percentage ?? "N/A",
                                      style: subTitleStyle,
                                    )),
                                    DataCell(Text(
                                      company.revenue ?? "N/A",
                                      style: subTitleStyle,
                                    )),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteDialog(context, company.id.toString(),company);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id,CompanyModel company) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Location'),
          content: const Text('Are you sure you want to delete this Location?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                firebaseService.deleteCompany(id.toString());
                companyList.remove(company);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  buildCommonRow(String title,TextEditingController controller) {
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
                              const SizedBox(width: 20,),
                              SizedBox(
                                  width: 300,
                                  height: 45,
                                  child: TextField(
                                    controller: controller,
                                    decoration: InputDecoration(
                                      hintText: title,
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black,width: 10),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
    );
  }
}
