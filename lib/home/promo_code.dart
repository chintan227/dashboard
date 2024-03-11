import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/models/packages.dart';

import '../constants.dart';
import '../services/firebase_services.dart';

class PromoCodePage extends StatefulWidget {
  const PromoCodePage({super.key});

  @override
  State<PromoCodePage> createState() => _PromoCodePageState();
}

class _PromoCodePageState extends State<PromoCodePage> {
  PromoCodes? promoCodes;
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
    promoCodes = await firebaseService.getPromoCodes();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          Text(
                            "Promo Codes",
                            style: GoogleFonts.readexPro(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: darkGradient),
                          ),
                          10.width,
                          IconButton(
                              onPressed: () => _showAddServiceDialog(context),
                              icon: Icon(
                                FontAwesomeIcons.circlePlus,
                                color: darkGradient,
                              ))
                        ],
                      ),
                    ),
                    30.height,
                    SizedBox(
                      height: height(context) * 0.8,
                      width: width(context),
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8.0,
                          childAspectRatio: 3 / 1,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: promoCodes?.promoCodes?.length,
                        itemBuilder: (BuildContext context, int index) {
                          ServiceModel service = promoCodes!.promoCodes![index];

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border:
                                  Border.all(color: darkGradient, width: 1.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Name: ${service.name}',
                                  style: titleStyle,
                                ),
                                Text(
                                  'Subtitle: ${service.subtitle}',
                                  style: titleStyle,
                                ),
                                Text(
                                  'Price: ${service.price}',
                                  style: titleStyle,
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _showAddServiceDialog(context,
                                            existingService: service);
                                      },
                                      child: Text(
                                        'Edit',
                                        style: subTitleStyle,
                                      ),
                                    ),
                                    20.width,
                                    ElevatedButton(
                                      onPressed: () {
                                        _showDeleteDialog(context, service);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: subTitleStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showAddServiceDialog(BuildContext context,
      {ServiceModel? existingService}) {
    String? name = existingService?.name;
    String? subtitle = existingService?.subtitle;
    int? price = existingService?.price;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            width: width(context) * 0.4,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(existingService != null ? 'Edit Service' : 'Add Service',
                    style: titleStyle),
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
                    subtitle = value;
                  },
                  decoration: InputDecoration(labelText: 'Subtitle'),
                  controller: TextEditingController(text: subtitle),
                ),
                TextField(
                  onChanged: (value) {
                    price = int.tryParse(value);
                  },
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  controller: TextEditingController(text: price?.toString()),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel', style: subTitleStyle),
                    ),
                    TextButton(
                      onPressed: () {
                        if (name != null || subtitle != null || price != null) {
                          ServiceModel updatedService = ServiceModel(
                              name: name, subtitle: subtitle, price: price);

                          if (existingService != null) {
                            // Edit operation

                            _editServiceInFirestore(
                                existingService, updatedService);
                          } else {
                            // Add operation
                            _addServiceToFirestore(updatedService);
                          }

                          Navigator.of(context).pop();
                        } else {
                          // Show an error message or handle invalid input
                        }
                      },
                      child: Text(existingService != null ? 'Update' : 'Add',
                          style: subTitleStyle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editServiceInFirestore(
      ServiceModel existingService, ServiceModel updatedService) {
    final DocumentReference promoCodesDocRef = FirebaseFirestore.instance
        .collection('subscriptions')
        .doc('promo_codes');

    promoCodesDocRef.get().then((promoCodesSnapshot) {
      if (promoCodesSnapshot.exists) {
        List<dynamic> codes = promoCodesSnapshot.get('codes') ?? [];

        int serviceIndex = -1;

        for (int i = 0; i < codes.length; i++) {
          if (_areServicesEqual(codes[i], existingService.toJson())) {
            serviceIndex = i;
            break;
          }
        }

        if (serviceIndex != -1) {
          codes[serviceIndex] = updatedService.toJson();
          setState(() {});
          promoCodesDocRef.update({'codes': codes}).then((_) {
            getBookings();
            toast("Code updated");
          });
        }
      }
    });
  }

  bool _areServicesEqual(
      Map<String, dynamic> service1, Map<String, dynamic> service2) {
    return service1['name'] == service2['name'] &&
        service1['subtitle'] == service2['subtitle'] &&
        service1['price'] == service2['price'];
  }

  void _addServiceToFirestore(ServiceModel newService) {
    final DocumentReference promoCodesDocRef = FirebaseFirestore.instance
        .collection('subscriptions')
        .doc('promo_codes');

    promoCodesDocRef.get().then((promoCodesSnapshot) {
      if (promoCodesSnapshot.exists) {
        List<dynamic> codes = promoCodesSnapshot.get('codes') ?? [];

        // Add the new service to the codes array
        codes.add(newService.toJson());
        promoCodesDocRef.update({'codes': codes});
        promoCodes?.promoCodes?.add(newService);
        toast("Code added");

        setState(() {});
      }
    });
  }

  void _showDeleteDialog(BuildContext context, ServiceModel service) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Confirmation',
            style: titleStyle,
          ),
          content: Text(
            'Do you want to delete ${service.name}?',
            style: subTitleStyle,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _deleteService(service);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: subTitleStyle),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: subTitleStyle),
            ),
          ],
        );
      },
    );
  }

  void _deleteService(ServiceModel service) {
    final DocumentReference promoCodesDocRef = FirebaseFirestore.instance
        .collection('subscriptions')
        .doc('promo_codes');

    promoCodesDocRef.get().then((promoCodesSnapshot) {
      if (promoCodesSnapshot.exists) {
        List<dynamic> codes = promoCodesSnapshot.get('codes') ?? [];

        int serviceIndex = -1;
        for (int i = 0; i < codes.length; i++) {
          if (codes[i]['name'] == service.name) {
            serviceIndex = i;
            break;
          }
        }

        if (serviceIndex != -1) {
          codes.removeAt(serviceIndex);
          promoCodes?.promoCodes?.remove(service);
          setState(() {});
          toast("Code deleted");
          promoCodesDocRef.update({'codes': codes});
        }
      }
    });
  }
}
