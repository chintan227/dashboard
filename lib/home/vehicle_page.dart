import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({super.key});

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  TextStyle titleStyle = GoogleFonts.readexPro(
      fontSize: 18, fontWeight: FontWeight.w500, color: darkGradient);

  TextStyle subTitleStyle = GoogleFonts.readexPro(
      fontSize: 18, fontWeight: FontWeight.w400, color: darkGradient);

  final CollectionReference vehiclesCollection =
      FirebaseFirestore.instance.collection('vehicles');
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.height,
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Text(
                  "Vehicles",
                  style: GoogleFonts.readexPro(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: darkGradient),
                ),
                10.width,
                IconButton(
                    onPressed: () => _showAddVehicleDialog(context),
                    icon: Icon(
                      FontAwesomeIcons.circlePlus,
                      color: darkGradient,
                    ))
              ],
            ),
          ),
          30.height,
          SizedBox(
            height: height(context) * 0.88,
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('vehicles')
                  .doc('vehicle_list')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<Vehicle> vehicles = [];
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;

                data.forEach((companyName, models) {
                  List<String> modelList = (models as List).cast<String>();
                  vehicles.add(
                      Vehicle(companyName: companyName, models: modelList));
                });

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 8.0, // Spacing between rows
                    childAspectRatio: 3,
                  ),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    return _buildVehicleContainer(vehicles[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleContainer(Vehicle vehicle) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Company Name: ${vehicle.companyName}',
              style: titleStyle,
            ),
            SizedBox(height: 8.0),
            Text(
              'Models:',
              style: titleStyle,
            ),
            SizedBox(height: 8.0),
            SizedBox(
              height: height(context) * 0.1,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: vehicle.models.map((model) {
                  return Text(
                    '- $model',
                    style: subTitleStyle,
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.pencil,
                    size: 20,
                  ),
                  onPressed: () {
                    _showEditVehicleDialog(context, vehicle);
                  },
                ),
                10.width,
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteVehicleDialog(context, vehicle);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddVehicleDialog(BuildContext context) {
    String companyName = '';
    String models = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Vehicle'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  companyName = value;
                },
                decoration: InputDecoration(labelText: 'Company Name'),
              ),
              TextField(
                onChanged: (value) {
                  models = value;
                },
                decoration:
                    InputDecoration(labelText: 'Models (comma-separated)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                List<String> modelList =
                    models.split(',').map((e) => e.trim()).toList();
                Vehicle newVehicle =
                    Vehicle(companyName: companyName, models: modelList);
                _addVehicleToFirestore(newVehicle);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditVehicleDialog(BuildContext context, Vehicle vehicle) {
    String companyName = vehicle.companyName;
    String models = vehicle.models.join(', ');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Vehicle'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  companyName = value;
                },
                decoration: InputDecoration(labelText: 'Company Name'),
                controller: TextEditingController(text: companyName),
              ),
              TextField(
                onChanged: (value) {
                  models = value;
                },
                decoration:
                    InputDecoration(labelText: 'Models (comma-separated)'),
                controller: TextEditingController(text: models),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                List<String> modelList =
                    models.split(',').map((e) => e.trim()).toList();
                Vehicle updatedVehicle =
                    Vehicle(companyName: companyName, models: modelList);
                _editVehicleInFirestore(vehicle, updatedVehicle);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteVehicleDialog(BuildContext context, Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Vehicle'),
          content: Text('Are you sure you want to delete this vehicle?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteVehicleInFirestore(vehicle);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _addVehicleToFirestore(Vehicle newVehicle) {
    vehiclesCollection.doc('vehicle_list').update({
      newVehicle.companyName: FieldValue.arrayUnion(newVehicle.models),
    });
  }

  void _editVehicleInFirestore(Vehicle oldVehicle, Vehicle updatedVehicle) {
    vehiclesCollection.doc('vehicle_list').update({
      oldVehicle.companyName: FieldValue.arrayRemove(oldVehicle.models),
      updatedVehicle.companyName: FieldValue.arrayUnion(updatedVehicle.models),
    });
  }

  void _deleteVehicleInFirestore(Vehicle vehicle) {
    vehiclesCollection.doc('vehicle_list').update({
      vehicle.companyName: FieldValue.delete(),
    });
  }
}

class Vehicle {
  final String companyName;
  final List<String> models;

  Vehicle({required this.companyName, required this.models});

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      companyName: map['companyName'] ?? '',
      models: List<String>.from(map['models'] ?? []),
    );
  }
}
