// ignore_for_file: prefer_const_constructors

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/common/primary_button.dart';
import 'package:wype_dashboard/constants.dart';
import 'package:wype_dashboard/models/subscription_model.dart';
import 'package:wype_dashboard/services/firebase_services.dart';
import '../models/packages.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final CollectionReference packagesCollection = FirebaseFirestore.instance.collection('subscriptions');
  FirebaseService firebaseService = FirebaseService();
  List<SubscriptionModel> subscriptionList = [];
  bool isLoading = true;

  TextEditingController name = TextEditingController();
  TextEditingController cost = TextEditingController();
  TextEditingController wash = TextEditingController();
  TextEditingController addService = TextEditingController();
  TextEditingController removeService = TextEditingController();
  TextEditingController note = TextEditingController();

  TextStyle titleStyle = GoogleFonts.readexPro(fontSize: 18, fontWeight: FontWeight.w500, color: darkGradient);

  TextStyle subTitleStyle = GoogleFonts.readexPro(fontSize: 18, fontWeight: FontWeight.w400, color: darkGradient);

  @override
  void initState() {
    super.initState();
    getSubscription();
  }

  getSubscription() async {
    subscriptionList = await firebaseService.getSubscriptionList();
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  isLoading
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
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("Create New Subscripton",style: GoogleFonts.readexPro(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: darkGradient,
                        decoration: TextDecoration.underline,
                      ),),
                    ),
                    const SizedBox(height: 30,),
                    buildRow("Subscription Name",name),
                    buildRow("Cost",cost),
                    buildRow("No Of Wash",wash),
                    buildRow("Add Service",addService),
                    buildRow("Remove Service",removeService),
                    buildRow("Special Note",note),
                    SizedBox(height: 16.0),
                    PrimaryButton(text: "Create", onTap:  () {
                      firebaseService.createSubscription(SubscriptionModel(
                        name: name.text.toString(),
                        cost: cost.text.toString(),
                        noOfWash: wash.text.toString(),
                        addService: addService.text.toString(),
                        removeService: removeService.text.toString(),
                        notes: note.text.toString(),
                      )).then((value) {
                        if(value == false){
                        }else{
                          subscriptionList.add(
                              SubscriptionModel(
                                name: name.text.toString(),
                                cost: cost.text.toString(),
                                noOfWash: wash.text.toString(),
                                addService: addService.text.toString(),
                                removeService: removeService.text.toString(),
                                notes: note.text.toString(),
                              )
                          );
                          toast("Employee Added....");
                          name.clear();
                          cost.clear();
                          wash.clear();
                          addService.clear();
                          removeService.clear();
                          note.clear();
                          setState(() {});
                        }
                      });
                    },),

                    subscriptionList.isEmpty ? SizedBox():
                    DataTable(
                      columns: [
                        DataColumn(
                            label: Text(
                              'Index',
                              style: titleStyle,
                            )),
                        DataColumn(label: Text('Subscription Name', style: titleStyle)),
                        DataColumn(label: Text('Cost', style: titleStyle)),
                        DataColumn(label: Text('No Of Wash', style: titleStyle)),
                        DataColumn(label: Text('Add Service', style: titleStyle)),
                        DataColumn(label: Text('Remove Service', style: titleStyle)),
                        DataColumn(label: Text('Special Note', style: titleStyle)),
                        DataColumn(label: Text('Service', style: titleStyle)),
                      ],
                      rows: List<DataRow>.generate(
                        subscriptionList.length,
                            (index) {
                          SubscriptionModel subscription = subscriptionList[index];
                          print("--$index--->${subscription.id}");
                          return DataRow(
                            cells: [
                              DataCell(Text(
                                (index + 1).toString(),
                                style: subTitleStyle,
                              )),
                              DataCell(Text(
                                subscription.name ?? "N/A",
                                style: subTitleStyle,
                              )),
                              DataCell(Text(
                                subscription.cost ?? "N/A",
                                style: subTitleStyle,
                              )),
                              DataCell(Text(
                                subscription.noOfWash ?? "N/A",
                                style: subTitleStyle,
                              )),
                              DataCell(Text(
                                subscription.addService ?? "N/A",
                                style: subTitleStyle,
                              )),
                              DataCell(Text(
                                subscription.removeService ?? "N/A",
                                style: subTitleStyle,
                              )),
                              DataCell(Text(
                                subscription.notes ?? "N/A",
                                style: subTitleStyle,
                              )),


                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteDialog(context, subscription.id.toString(),subscription);
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                )
              )),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id,SubscriptionModel model) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Subscription'),
          content: const Text('Are you sure you want to delete this Subscription ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                firebaseService.deleteSubscription(id.toString());
                subscriptionList.remove(model);
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

  buildRow(String name,TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
                              children: [
                                 SizedBox( width: 190,
                                   child: Text(
                                    name.toString(),
                                     style: GoogleFonts.readexPro(
                                       fontSize: 18,
                                       fontWeight: FontWeight.bold,
                                       color: darkGradient,
                                     ),
                                ),
                                 ),
                                SizedBox(
                                    width: 300,
                                    height: 45,
                                    child: TextField(
                                      controller: controller,
                                      decoration: InputDecoration(
                                        hintText: name,
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

  void _editPackageInFirestore(Package oldPackage, Package updatedPackage) {
    packagesCollection.doc('package').update({
      'packages': FieldValue.arrayRemove([oldPackage.toJson()]),
      'packages': FieldValue.arrayUnion([updatedPackage.toJson()]),
    });
  }

  void _showEditPackageDialog(BuildContext context, Package package) {
    String name = package.name;
    String about = package.about;
    Map<String, dynamic> pricing = package.pricing;
    List<String> services = package.services;
    List<ServiceModel> addServices = package.addServices ?? [];
    List<ServiceModel>? removeServices = package.removeServices;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Package',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: InputDecoration(labelText: 'Name'),
                    controller: TextEditingController(text: name),
                  ),
                  TextField(
                    onChanged: (value) {
                      about = value;
                    },
                    decoration: InputDecoration(labelText: 'About'),
                    controller: TextEditingController(text: about),
                  ),
                  TextField(
                    onChanged: (value) {
                      // Handle pricing
                    },
                    decoration: InputDecoration(labelText: 'Pricing'),
                    controller: TextEditingController(text: pricing.toString()),
                  ),
                  TextField(
                    onChanged: (value) {
                      services = value.split(',').map((e) => e.trim()).toList();
                    },
                    decoration: InputDecoration(
                        labelText: 'Services (comma-separated)'),
                    controller:
                        TextEditingController(text: services.join(', ')),
                  ),
                  TextField(
                    onChanged: (value) {
                      addServices = value
                          .split(',')
                          .map((e) => e.trim())
                          .cast<ServiceModel>()
                          .toList();
                    },
                    decoration: InputDecoration(
                        labelText: 'Add Services (comma-separated)'),
                    controller:
                        TextEditingController(text: addServices.join(', ')),
                  ),
                  SizedBox(height: 16.0),
                  _buildServiceList(
                    title: 'Remove Services:',
                    services: removeServices,
                    backgroundColor: Colors.red,
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
                          // Update the package in Firestore
                          Package updatedPackage = Package(
                            name: name,
                            about: about,
                            pricing: pricing,
                            services: services,
                            addServices: addServices,
                            removeServices: removeServices,
                          );
                          _editPackageInFirestore(package, updatedPackage);
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

  Widget _buildServiceList({
    required String title,
    required List<ServiceModel>? services,
    required Color backgroundColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          children: services?.map((service) {
                return Chip(
                  label: Text(
                    '${service.name} - ${service.subtitle} - \$${service.price}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  backgroundColor: backgroundColor,
                  labelStyle: TextStyle(color: Colors.white),
                );
              }).toList() ??
              [],
        ),
      ],
    );
  }

  void _showDeletePackageDialog(BuildContext context, Package package) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Package'),
          content: Text('Are you sure you want to delete this package?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deletePackageInFirestore(package);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _addServiceToPackage(ServiceModel newService) {
    packagesCollection.doc('package').update({
      'packages': FieldValue.arrayUnion([newService.toJson()]),
    });
  }

  void _deletePackageInFirestore(Package package) {
    packagesCollection.doc('package').update({
      'packages': FieldValue.arrayRemove([package.toJson()]),
    });
  }
}

extension WidgetExtensions on double {
  SizedBox get heightBox => SizedBox(height: this);
  SizedBox get widthBox => SizedBox(width: this);
}

double height(BuildContext context) => MediaQuery.of(context).size.height;
double width(BuildContext context) => MediaQuery.of(context).size.width;
