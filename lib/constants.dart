// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/home/bonus_create.dart';
import 'package:wype_dashboard/home/calender.dart';
import 'package:wype_dashboard/home/company_create.dart';
import 'package:wype_dashboard/home/dashboard.dart';
import 'package:wype_dashboard/home/jobs.dart';
import 'package:wype_dashboard/home/location_page.dart';
import 'package:wype_dashboard/home/new_employee_create.dart';
import 'package:wype_dashboard/home/package_page.dart';
import 'package:wype_dashboard/home/promo_code.dart';
import 'package:wype_dashboard/home/user_list.dart';
import 'package:wype_dashboard/home/vehicle_page.dart';
import 'package:wype_dashboard/models/drawer_items.dart';

import 'models/packages.dart';

const Color backgroundColor = Colors.white;
Color greyBg = Colors.grey.shade200;
Color iconColor = Colors.blue.shade800;
var lightGradient = HexColor("54B2CF");
var darkGradient = HexColor("0D1634");

const loaderText = "• • •";

height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

InputDecoration inputDecoration(BuildContext context,
    {Widget? prefixIcon, String? labelText, double? borderRadius}) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 12, bottom: 15, top: 15, right: 10),
    counterText: "",
    labelText: labelText,
    labelStyle: GoogleFonts.readexPro(color: Colors.grey.shade400),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: darkGradient, width: 0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: GoogleFonts.readexPro(color: Colors.red, fontSize: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: darkGradient, width: 1.0),
    ),
    filled: true,
    fillColor: context.cardColor,
  );
}

PromoCodes? promoCodeModel;
List<Package>? subscriptionPackage;

// List of car brands
List<String> carBrands = [];

// Map to store car models for each brand
Map<String, List<String>> carModels = {};

List<DrawerItems> drawerLists = [
  DrawerItems(icon: FontAwesomeIcons.homeAlt, text: "Dashboard", child: Dashboard()),
  DrawerItems(icon: FontAwesomeIcons.briefcase, text: "Jobs", child: JobsPage()),
  DrawerItems(icon: FontAwesomeIcons.user, text: "Users", child: UserList()),
  DrawerItems(icon: FontAwesomeIcons.userPlus, text: "Employee ", child: NewEmployeeCreate()),
  DrawerItems(icon: FontAwesomeIcons.calendar, text: "Calender ", child: CalenderPage()),
  DrawerItems(icon: FontAwesomeIcons.car, text: "Vehicles", child: VehiclePage()),
  DrawerItems(icon: FontAwesomeIcons.award, text: "Bonus", child: BonusPage()),
  DrawerItems(icon: FontAwesomeIcons.house, text: "Company", child: CompanyCreate()),
  DrawerItems(icon: FontAwesomeIcons.locationDot, text: "Location", child: LocationPage()),
  DrawerItems(icon: FontAwesomeIcons.moneyBill, text: "subscription", child: SubscriptionPage()),
];
