import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wype_dashboard/services/firebase_services.dart';

import 'constants.dart';
import 'home/home_page.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBJ3bce-RZgcvK853HIP_SqtUZ6kPYB5OA",
        authDomain: "wypeadmin.firebaseapp.com",
        projectId: "wypeadmin",
        storageBucket: "wypeadmin.appspot.com",
        messagingSenderId: "228853359778",
        appId: "1:228853359778:web:0156d2922a31f237c7e3fb",
        measurementId: "G-W23JV4HRNG"),
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wype Admin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    route();
  }

  route() async {
    Future.delayed(const Duration(seconds: 2), () {
      final FirebaseAuth fbAuth = FirebaseAuth.instance;
      if (fbAuth.currentUser != null) {
        const HomePage()
            .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
      } else {
        const LoginPage()
            .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox(
        height: height(context),
        width: width(context),
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
        ),
      ),
    );
  }
}
