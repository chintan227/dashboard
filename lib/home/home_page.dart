import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/constants.dart';
import 'package:wype_dashboard/home/dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  Widget selectedWidet = Dashboard();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          Container(
            height: height(context),
            width: width(context) * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: darkGradient),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: width(context) * 0.08,
                  width: width(context) * 0.08,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.fitWidth),
                      shape: BoxShape.circle,
                      color: Colors.white),
                ),
                40.height,
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: drawerLists.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            selectedIndex = index;
                            selectedWidet = drawerLists[index].child;
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 35),
                            margin: EdgeInsets.only(bottom: 15),
                            color: selectedIndex == index
                                ? Colors.white
                                : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  drawerLists[index].icon,
                                  color: selectedIndex == index
                                      ? darkGradient
                                      : Colors.white,
                                ),
                                10.width,
                                Text(
                                  drawerLists[index].text,
                                  style: GoogleFonts.readexPro(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: selectedIndex == index
                                        ? darkGradient
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
                // Image(
                //   image: AssetImage('assets/images/logo.png'),
                //   fit: BoxFit.contain,
                //   width:  width(context) * 0.09,
                // ),
              ],
            ),
          ),
          Expanded(child: selectedWidet)
        ],
      ),
    );
  }
}
