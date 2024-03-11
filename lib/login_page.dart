import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/services/firebase_services.dart';

import 'common/primary_button.dart';
import 'constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();

  FirebaseService firebaseService = FirebaseService();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          height: height(context),
          width: width(context),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    height: width(context) * 0.1,
                    width: width(context) * 0.1,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fitWidth),
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ]),
                  ),
                  // Image(
                  //   image: AssetImage('assets/images/logo.png'),
                  //   fit: BoxFit.contain,
                  //   width: width(context) * 0.5,
                  // ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: VerticalDivider(
                  color: Colors.grey,
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: GoogleFonts.readexPro(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: darkGradient),
                  ),
                  30.height,
                  SizedBox(
                    width: width(context) * 0.3,
                    child: AppTextField(
                      cursorColor: Colors.grey,
                      controller: emailCont,
                      onChanged: (val) => setState(() {}),
                      textStyle: GoogleFonts.readexPro(),
                      textFieldType: TextFieldType.EMAIL,
                      decoration: inputDecoration(context, labelText: "Email"),
                    ),
                  ),
                  20.height,
                  SizedBox(
                    width: width(context) * 0.3,
                    child: AppTextField(
                      cursorColor: Colors.grey,
                      controller: passCont,
                      onChanged: (val) => setState(() {}),
                      textStyle: GoogleFonts.readexPro(),
                      textFieldType: TextFieldType.PASSWORD,
                      isPassword: true,
                      decoration:
                          inputDecoration(context, labelText: "Password"),
                    ),
                  ),
                  50.height,
                  PrimaryButton(
                      text: isLoading ? loaderText : "Continue",
                      onTap: () async {
                        if (emailCont.text.trim() == "admin@wype.com") {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            await firebaseService.login(
                                context, emailCont.text, passCont.text);
                          } catch (e) {
                            toast("Invalid Credentials");
                          }
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          toast("Invalid Credentials");
                        }
                      })
                ],
              ))
            ],
          ),
        ));
  }
}
