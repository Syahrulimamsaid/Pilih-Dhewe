import 'package:Pilih_Dhewe/Home_Event/Home.dart';
import 'package:Pilih_Dhewe/Login/ApiLogin.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class BottomWaveClipperTop extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.moveTo(size.width * 1.5, size.height * 1.2);

    // Curve 1
    path.quadraticBezierTo(size.width * 1.05, size.height * 0.55,
        size.width * 0.75, size.height * 0.7);

    // Curve 2
    path.quadraticBezierTo(size.width * 0.57, size.height * 0.8,
        size.width * 0.45, size.height * 0.6);

    // Curve 3
    path.quadraticBezierTo(size.width * 0.22, size.height * 0.25,
        size.width * 0.07, size.height * 0.6);

    // Curve 4
    path.quadraticBezierTo(size.width * 0.02, size.height * 0.7,
        size.width * -0.1, size.height * 0.6);

    path.quadraticBezierTo(size.width * -0.2, size.height * 0.7,
        size.width * -0.3, size.height * 1);

    path.moveTo(size.width * 0, size.height * 1.2);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BottomWaveClipperBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.moveTo(size.width * 0.25, size.height * 1);

    //Curve 1
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.87,
        size.width * 0.175, size.height * 0.75);

    // Curve 2
    path.quadraticBezierTo(size.width * 0.06, size.height * 0.63,
        size.width * 0.085, size.height * 0.45);

    // // Curve 3
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.28, size.width * 0,
        size.height * 0.2);

    // // Curve 4
    // path.quadraticBezierTo(size.width * 0.02, size.height * 0.7,
    //     size.width * -0.1, size.height * 0.6);

    path.quadraticBezierTo(size.width * -0.2, size.height * 0.25,
        size.width * -0.3, size.height * 1);

    path.moveTo(size.width * 0, size.height * 1);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class LoginPage extends StatefulWidget {
  final String? Theme;
  const LoginPage({super.key, this.Theme});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  PostUser? postUser = null;

  double UkurLink(BuildContext context) =>
      MediaQuery.of(context).size.width * 1.3;

  bool statusPw = true;
  String ErrorUsername = '';
  String ErrorPassword = '';

  void login() async {
    if (username.text.isEmpty && password.text.isEmpty) {
      setState(() {
        ErrorPassword = 'Field harus diisi.';
        ErrorUsername = 'Field harus diisi.';
      });
    } else if (username.text.isEmpty && password.text.isNotEmpty) {
      setState(() {
        ErrorPassword = '';
        ErrorUsername = 'Field harus diisi.';
      });
    } else if (password.text.isEmpty && username.text.isNotEmpty) {
      setState(() {
        ErrorPassword = 'Field harus diisi.';
        ErrorUsername = '';
      });
    } else if (username.text.isNotEmpty && password.text.isNotEmpty) {
      try {
        postUser = await PostUser.connectToAPI(username.text, password.text);

        if (postUser != null) {
          final SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setString('GetToken', postUser!.SetToken);
          setState(() {
            ErrorPassword = '';
            ErrorUsername = '';
            AnimateStatus = false;
          });

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomePage(
              ID: postUser!.id,
              Name: postUser!.name,
              Gender: postUser!.gender,
              Role: postUser!.role,
              Number_Card: postUser!.number_card,
              GetToken: postUser!.SetToken,
              Kelas: postUser!.kelas.namakelas,
              GambarProfil: postUser!.gambar,
              IdKelas: postUser!.kelas.id,
              Theme: widget.Theme,
            );
          }));
        } else {
          setState(() {
            AnimateStatus = false; // Toggle loading spinner
          });
        }
      } catch (e) {
        setState(() {
          ErrorPassword = '';
          ErrorUsername = '';
          AnimateStatus = false;
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  title: "Gagal",
                  desc: e.toString(),
                  btnOkOnPress: () {},
                  animType: AnimType.topSlide)
              .show();
        });
      }
    } else {
      setState(() {
        // LoginError = 'Username or password is incorrect.';
      });
    }
  }

  AnimationController? controller;
  Animation<double>? animation;
  bool AnimateStatus = false;

  void StartAnimate() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(controller!)
      ..addListener(() {
        if (AnimateStatus) {
          setState(() {});
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (AnimateStatus == true) {
            controller!.reset();
            controller!.forward();
          } else {
            controller!.stop();
          }
        }
      });

    if (AnimateStatus == true) {
      controller!.forward();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    (controller != null) ? controller!.dispose() : "";
    super.dispose();
  }

  ThemeMode systemMode = ThemeMode.system;

  void TemaApp(ThemeMode themeMode) {
    setState(() {
      systemMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          textTheme: TextTheme(
        bodyText1: TextStyle(
            fontFamily: "Poppins",
            fontSize: 30,
            color: Color.fromARGB(255, 0, 31, 104),
            fontWeight: FontWeight.w700),
      )),
      darkTheme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
        bodyText1: TextStyle(
            fontFamily: "Poppins",
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w700),
      )),
      home: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.width * 0.65,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Transform(
                    transform: Matrix4.identity()..scale(1.0, -1.0),
                    child: ClipPath(
                      clipper: BottomWaveClipperTop(),
                      child: Opacity(
                        opacity: 1,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                Color.fromARGB(255, 0, 76, 255),
                                Color.fromARGB(255, 12, 87, 255),
                                Color.fromARGB(255, 47, 131, 255),
                              ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft)),
                          width: 1000,
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 190, 0, 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Container(
                              child: Text(
                            "Login",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 30,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                //Color.fromARGB(255, 0, 31, 104),
                                fontWeight: FontWeight.w700),
                          )),
                          Container(
                              margin: EdgeInsets.only(top: 5, bottom: 20),
                              child: Text(
                                "Masukkan Username dan Password dengan benar.",
                                style: TextStyle(
                                    fontFamily: "Calibri",
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w700),
                              )),
                          Container(
                            margin: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  child: Material(
                                    elevation: 3,
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: Icon(
                                                Icons.person,
                                                size: 27,
                                                color: Color.fromARGB(
                                                    255, 60, 50, 248),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 4,
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                left: 20,
                                              ),
                                              child: TextField(
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                controller: username,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 0, 57, 104),
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: "Username",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 7, right: 30),
                                    child: Text(
                                      ErrorUsername,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontFamily: "Calibri",
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                            child: Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.09,
                                  child: Material(
                                    elevation: 3,
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: Icon(
                                                Icons.key,
                                                size: 27,
                                                color: Color.fromARGB(
                                                    255, 60, 50, 248),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 4,
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                left: 20,
                                              ),
                                              child: TextField(
                                                obscureText: statusPw,
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                controller: password,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 0, 57, 104),
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: "Password",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      statusPw = !statusPw;
                                                    });
                                                  },
                                                  child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.07,
                                                      child: Icon(
                                                        (statusPw != false)
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                        size: 27,
                                                        color: Color.fromARGB(
                                                            255, 60, 50, 248),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 7, right: 30),
                                    child: Text(
                                      ErrorPassword,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontFamily: "Calibri",
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: (AnimateStatus == false)
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.07,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Material(
                                borderRadius: BorderRadius.circular(30),
                                elevation: 4,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 0, 76, 255),
                                            Color.fromARGB(255, 12, 87, 255),
                                            Color.fromARGB(255, 47, 131, 255),
                                          ],
                                          begin: Alignment.centerRight,
                                          end: Alignment.centerLeft)),
                                  child: Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      splashColor: const Color.fromARGB(
                                          127, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: () {
                                        if (password.text.isNotEmpty &&
                                            username.text.isNotEmpty) {
                                          setState(() {
                                            ErrorPassword = "";
                                            ErrorUsername = "";
                                            AnimateStatus = !AnimateStatus;
                                            StartAnimate();
                                          });
                                        }

                                        login();
                                      },
                                      child: const Center(
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              fontSize: 18.5,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              child: Transform.rotate(
                                angle:
                                    (animation != null) ? animation!.value : 0,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  height:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Icon(
                                    Icons.settings,
                                    size: 50,
                                    color: Color.fromARGB(255, 0, 76, 255),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ClipPath(
                    clipper: BottomWaveClipperBottom(),
                    child: Opacity(
                      opacity: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              Color.fromARGB(255, 0, 76, 255),
                              Color.fromARGB(255, 12, 87, 255),
                              Color.fromARGB(255, 47, 131, 255),
                            ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft)),
                        width: 1000,
                        height: 200,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
