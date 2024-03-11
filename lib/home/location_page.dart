import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/common/primary_button.dart';
import 'package:wype_dashboard/constants.dart';
import 'package:wype_dashboard/models/location_model.dart';
import 'package:wype_dashboard/services/firebase_services.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  List<LocationDetailModel> locationList = [];
  FirebaseService firebaseService = FirebaseService();
  bool isLoading = true;

  TextStyle titleStyle = GoogleFonts.readexPro(fontSize: 18, fontWeight: FontWeight.w500, color: darkGradient);

  TextStyle subTitleStyle = GoogleFonts.readexPro(fontSize: 18, fontWeight: FontWeight.w400, color: darkGradient);

  TextEditingController name = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController radius = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    locationList = await firebaseService.getLocationDetails();
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
                            child: Text("Add New Location",style: GoogleFonts.readexPro(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: darkGradient,
                              decoration: TextDecoration.underline,
                            ),),
                          ),
                          const SizedBox(height: 30,),

                          buildCommonRow('Location Name',name),
                          buildCommonRow('Latitude ',latitude),
                          buildCommonRow('Longitude ',longitude),
                          buildCommonRow('Radius ',radius),

                          PrimaryButton(text: "Create",
                            onTap:  () {
                            if(name.text.isEmpty || latitude.text.isEmpty || longitude.text.isEmpty || radius.text.isEmpty){
                              toast("Please fill all details....");
                            }else{
                              firebaseService.createLocation(LocationDetailModel(
                                  name: name.text.toString(),
                                  latitude: latitude.text.toString(),
                                  radius: radius.text.toString(),
                                  longitude: longitude.text.toString())).then((value) {
                                locationList.add(LocationDetailModel(
                                    name: name.text.toString(),
                                    latitude: latitude.text.toString(),
                                    radius: radius.text.toString(),
                                    longitude: longitude.text.toString()));
                                setState(() {  });
                                name.clear();
                                latitude.clear();
                                longitude.clear();
                                radius.clear();
                              });
                              toast("Location Added....");
                            }
                            },),
                          locationList.isEmpty ? Container():
                          DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                    'Index',
                                    style: titleStyle,
                                  )),
                              DataColumn(label: Text('Name', style: titleStyle)),
                              DataColumn(label: Text('Latitude', style: titleStyle)),
                              DataColumn(label: Text('Longitude', style: titleStyle)),
                              DataColumn(label: Text('Radius', style: titleStyle)),
                              DataColumn(label: Text('Actions', style: titleStyle)),
                            ],
                            rows: List<DataRow>.generate(
                              locationList.length,
                                  (index) {
                                LocationDetailModel location = locationList[index];
                                return DataRow(
                                  cells: [
                                    DataCell(Text(
                                      (index + 1).toString(),
                                      style: subTitleStyle,
                                    )),
                                    DataCell(Text(
                                      location.name ?? "N/A",
                                      style: subTitleStyle,
                                    )),
                                    DataCell(Text(
                                      location.latitude ?? "N/A",
                                      style: subTitleStyle,
                                    )),
                                    DataCell(Text(
                                      location.longitude ?? "N/A",
                                      style: subTitleStyle,
                                    )),
                                    DataCell(Text(
                                      location.radius ?? "N/A",
                                      style: subTitleStyle,
                                    )),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _showDeleteDialog(context, location.name.toString(),location);
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

  void _showDeleteDialog(BuildContext context, String name,LocationDetailModel location) {
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
                firebaseService.deleteLocation(name.toString());
                locationList.remove(location);
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
