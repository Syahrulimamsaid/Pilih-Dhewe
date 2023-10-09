import 'dart:async';
import 'package:Pilih_Dhewe/Home_Event/Home.dart';
import 'package:Pilih_Dhewe/Login/Login.dart';
import 'package:Pilih_Dhewe/Profil/ApiProfil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  late String finalUsername;
  late String finalPassword;
  late String finalGetToken;
  String finalTheme = "";

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      GoLoginOrHome();
    });
  }

  Future GoLoginOrHome() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var dataGetToken = sharedPreferences.getString('GetToken');
    var dataUsername = sharedPreferences.getString('Number_Card');
    var dataPassword = sharedPreferences.getString('Password');
    var dataTheme = sharedPreferences.getString("Theme");
    if (dataGetToken != null) {
      finalGetToken = dataGetToken!;
      finalTheme = (finalTheme != null) ? dataTheme! : "Terang";

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              GetToken: finalGetToken,
              Theme: finalTheme,
            ),
          ));
    } else {
      // finalTheme = (finalTheme != null) ? dataTheme! : "Terang";

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(
                  Theme: finalTheme,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 76, 255),
      body: Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 0, 76, 255),
            Color.fromARGB(255, 12, 87, 255),
            Color.fromARGB(255, 47, 131, 255),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.width * 0.5,
              child: const Image(
                image: AssetImage("assets/images/Pilih_Dhewe.png"),
                fit: BoxFit.contain,
              ),
            ),
          )),
    );
  }
}
