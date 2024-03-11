import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/home/home_page.dart';
import 'package:wype_dashboard/models/employee_model.dart';
import 'package:wype_dashboard/models/location_model.dart';
import 'package:wype_dashboard/models/shift_model.dart';
import 'package:wype_dashboard/models/subscription_model.dart';
import '../constants.dart';
import '../models/booking.dart';
import '../models/company_model.dart';
import '../models/packages.dart';
import '../models/user.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to check if user document exists in Firestore
  Future<bool> _doesUserDocumentExist(String userId) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return snapshot.exists;
  }

  // Function to create user document in Firestore
  Future<void> _createUserDocument(
      String userId, Map<String, dynamic> userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(userData);
  }

  // Callback when verification is completed automatically
  Future<List<BookingModel>> getAllBookings() async {
    final CollectionReference bookingsCollection =
        FirebaseFirestore.instance.collection('bookings');
    try {
      QuerySnapshot querySnapshot = await bookingsCollection.get();
      List<BookingModel> bookings = [];

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        BookingModel booking = BookingModel.fromMap(doc.id, data);
        bookings.add(booking);
      });

      return bookings;
    } catch (e) {
      print('Error retrieving bookings: $e');
      return [];
    }
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    UserCredential authResult;

    authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    String userId = authResult.user!.uid;

    if (userId.isEmpty) {
      toast("User not found. Please Sign up");
    } else {
      HomePage().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
    }

    // Navigate to the next page or perform other actions as needed
  }

  Future<PromoCodes?> getPromoCodes() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // Retrieve user document from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('subscriptions').doc("promo_codes").get();

      // Check if the document exists
      if (userDoc.exists) {
        var docs = json.encode(userDoc.data());
        return PromoCodes.fromJson(json.decode(docs));
      }
    } else {
      return null;
    }
    return null;
  }

  Future<void> addServiceToPromoCode(ServiceModel newService) async {
    try {
      DocumentReference promoCodesDocRef = FirebaseFirestore.instance
          .collection('subscriptions')
          .doc('promo_codes');

      // Update the promo_codes document to add the new service to the codes array
      await promoCodesDocRef.update({
        'codes': FieldValue.arrayUnion([newService.toJson()]),
      });

      toast("Promo Code added");
    } catch (e) {}
  }

  List<Vehicle>? _parseVehicles(List<dynamic>? vehicleList) {
    if (vehicleList == null || vehicleList.isEmpty) {
      return [];
    }

    return vehicleList
        .map((vehicleData) => Vehicle(
              model: vehicleData['model'],
              company: vehicleData['company'],
              numberPlate: vehicleData['number_plate'],
            ))
        .toList();
  }

  Future<List<UserModel>> getUserDetails() async {
    QuerySnapshot userSnapshot = await _firestore.collection('users').get();

    List<UserModel> userList = [];

    for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
      if (userDoc.exists) {
        UserModel user = UserModel(
          id: userDoc['id'],
          name: userDoc['name'],
          contact: userDoc['contact'],
          gender: userDoc['gender'],
          points: userDoc['points'],
          wallet: userDoc['wallet'],
          lang: userDoc['lang'] ?? "en",
          vehicle: _parseVehicles(userDoc['vehicle']),
        );

        userList.add(user);
      }
    }

    return userList;
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          // If 'vehicles' field exists, update it with the new vehicle, else create a new list
          List<dynamic>? existingVehicles = userDoc['vehicle'];

          if (existingVehicles != null) {
            existingVehicles.add(vehicle.toJson());
          } else {
            existingVehicles = [vehicle.toJson()];
          }

          // Update user document in Firestore with the updated vehicles list
          await _firestore.collection('users').doc(user.uid).update({
            'vehicle': existingVehicles,
          });
        }
      }
    } catch (e) {
      toast("Error adding vehicle");
    }
  }

  Future<void> updateWallet(num amount) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).update({
            'wallet': amount,
          });
        }
      }
    } catch (e) {
      toast("Error updating wallet");
      // Handle error
    }
  }

  Future<void> deleteVehicle(List<Vehicle>? vehicle) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          // await _firestore.collection('users').doc(user.uid).update({
          //   'vehicle':
          //       userData?.vehicle?.map((vehicle) => vehicle.toJson()).toList(),
          // });
        }
      }
    } catch (e) {
      toast("Vehicle deleted");
      print(e.toString());
      // Handle error
    }
  }

  Timestamp add12HoursToTimestamp(Timestamp originalTimestamp) {
    DateTime originalDateTime = originalTimestamp.toDate();
    DateTime newDateTime = originalDateTime.add(Duration(hours: 24));
    Timestamp newTimestamp = Timestamp.fromDate(newDateTime);
    return newTimestamp;
  }

  createBookings(BookingModel booking) async {
    CollectionReference bookingsCollection = _firestore.collection('bookings');

    for (int i = 0; i < booking.washCount; i++) {
      if (i == 0) {
        bookingsCollection.add(booking.toJson());
      } else if (i > 0) {
        booking.washTimings = add12HoursToTimestamp(booking.washTimings);
        // if (userData != null && (userData?.id != null)) {
        //   await bookingsCollection.add(booking.toJson());
        // }
      } else {
        toast("Please try again later");
      }
    }
  }

  Future createLocation(LocationDetailModel data) async {
    CollectionReference bookingsCollection = _firestore.collection('location');
    if (data.name != "") {
      bookingsCollection.add(data.toJson());
    } else {
      toast("Please try again later");
    }
  }

  Future<bool> createEmployee(EmployeeModel data) async {
    CollectionReference employeeCollection = _firestore.collection('Employee');
    if (data.name != "") {
      employeeCollection.add(data.toJson()).then((value) {
       print( value.id.toString());
       employeeCollection.doc(value.id.toString()).update({"id":value.id.toString()});
      });
      return true;
    } else {
      toast("Please try again later");
      return false;
    }
  }

  Future<bool> createCompany(CompanyModel data) async {
    CollectionReference companyCollection = _firestore.collection('company');
    if (data.companyName != "") {
      companyCollection.add(data.toJson()).then((value) {
        print( value.id.toString());
        companyCollection.doc(value.id.toString()).update({"id":value.id.toString()});
      });
      return true;
    } else {
      toast("Please try again later");
      return false;
    }
  }

  Future<bool> createSubscription(SubscriptionModel data) async {
    CollectionReference companyCollection = _firestore.collection('subscription');
    if (data.name != "") {
      companyCollection.add(data.toJson()).then((value) {
        print( value.id.toString());
        companyCollection.doc(value.id.toString()).update({"id":value.id.toString()});
      });
      return true;
    } else {
      toast("Please try again later");
      return false;
    }
  }

  Future<bool> addShift(ShiftModel data) async {
    CollectionReference companyCollection = _firestore.collection('shift');
    if (data.id != "") {
      companyCollection.add(data.toJson());
      return true;
    } else {
      toast("Please try again later");
      return false;
    }
  }

  Future<List<ShiftModel>> getShiftData() async {
    QuerySnapshot userSnapshot = await _firestore.collection('shift').get();

    List<ShiftModel> shiftList = [];

    for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
      if (userDoc.exists) {

        ShiftModel locations = ShiftModel(
            id: userDoc['id'],
            startTime: userDoc['startTime'],
            endTime: userDoc['endTime'],
        );

        shiftList.add(locations);
      }
    }
    print("----------${shiftList}");
    return shiftList;
  }

  deleteLocation(String name) async {
    CollectionReference bookingsCollection = _firestore.collection('location');
    if (name != "") {
      await bookingsCollection
          .where("name",isEqualTo:name.toString())
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
        return querySnapshot;
      });
      toast("Location Deleted");
    } else {
      toast("Please try again later");
    }
  }

  Future<List<LocationDetailModel>> getLocationDetails() async {
    QuerySnapshot userSnapshot = await _firestore.collection('location').get();

    List<LocationDetailModel> locationList = [];

    for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
      if (userDoc.exists) {

        LocationDetailModel locations = LocationDetailModel(
            name: userDoc['name'],
            longitude: userDoc['longitude'],
            radius: userDoc['radius'],
            latitude: userDoc['latitude']
        );

        locationList.add(locations);
      }
    }
    print("----------${locationList}");
    return locationList;
  }

  Future<List<CompanyModel>> getCompanyList() async {
    QuerySnapshot userSnapshot = await _firestore.collection('company').get();

    List<CompanyModel> companyList = [];

    for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
      if (userDoc.exists) {

        CompanyModel locations = CompanyModel(
            id: userDoc['id'],
            companyName: userDoc['companyName'],
            percentage: userDoc['percentage'],
            revenue: userDoc['revenue']
        );

        companyList.add(locations);
      }
    }
    print("---companyList-------${companyList}");
    return companyList;
  }

  Future<List<SubscriptionModel>> getSubscriptionList() async {
    QuerySnapshot userSnapshot = await _firestore.collection('subscription').get();

    List<SubscriptionModel> companyList = [];

    for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
      if (userDoc.exists) {

        SubscriptionModel locations = SubscriptionModel(
            id: userDoc['id'],
            name: userDoc['name'],
            cost: userDoc['cost'],
            noOfWash: userDoc['noOfWash'],
            addService: userDoc['addService'],
            removeService: userDoc['removeService'],
            notes: userDoc['notes']
        );

        companyList.add(locations);
      }
    }
    print("---subscription List-------${companyList}");
    return companyList;
  }

  deleteCompany(String id) async {
    CollectionReference bookingsCollection = _firestore.collection('company');
    if (id != "") {
      await bookingsCollection
          .where("id",isEqualTo:id.toString())
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
        return querySnapshot;
      });
      toast("Company Deleted");
    } else {
      toast("Please try again later");
    }
  }

  deleteSubscription(String id) async {
    CollectionReference bookingsCollection = _firestore.collection('subscription');
    if (id != "") {
      await bookingsCollection
          .where("id",isEqualTo:id.toString())
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
        return querySnapshot;
      });
      toast("subscription Deleted");
    } else {
      toast("Please try again later");
    }
  }

  Future<List<EmployeeModel>> getEmployee() async {
    QuerySnapshot userSnapshot = await _firestore.collection('Employee').get();

    List<EmployeeModel> employeeList = [];

    for (QueryDocumentSnapshot userDoc in userSnapshot.docs) {
      if (userDoc.exists) {

        EmployeeModel locations = EmployeeModel(
            name: userDoc['name']??"",
            phone: userDoc['phone']??"",
            email: userDoc['email']??"",
            company: userDoc['company']??"",
            password: userDoc['password']??"",
            salary: userDoc['salary']??"",
            // locations: userDoc['locations'] ?? Locations(),
        );

        employeeList.add(locations);
      }
    }
    print("-employeeList---------${employeeList[0].phone}");
    return employeeList;
  }
}

Future<void> getVehicles() async {
  carBrands = [];
  carModels = {};
  try {
    final CollectionReference vehicleCollection =
        FirebaseFirestore.instance.collection('vehicles');
    DocumentSnapshot vehicleListDoc =
        await vehicleCollection.doc('vehicle_list').get();

    // Extract car brands and models from the "vehicle_list" document
    Map<String, dynamic>? data = vehicleListDoc.data() as Map<String, dynamic>?;

    if (data != null) {
      data.forEach((brand, models) {
        carBrands.add(brand);
        carModels[brand] = List<String>.from(models);
      });
    }
  } catch (e) {}


}

void getPackages() async {
  try {
    DocumentSnapshot<Map<String, dynamic>> packagesSnapshot =
    await FirebaseFirestore.instance
        .collection('subscriptions')
        .doc('package')
        .get();

    if (!packagesSnapshot.exists) {}

    List<Package> packages = packagesSnapshot
        .data()!['packages']
        .map<Package>((package) => Package.fromJson(package))
        .toList();

    subscriptionPackage = packages;
  } catch (e) {}
}
