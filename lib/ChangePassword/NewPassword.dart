import 'dart:math';

import 'package:Pilih_Dhewe/ChangePassword/ApiPassword.dart';
import 'package:Pilih_Dhewe/Login/ApiLogin.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login/Login.dart';

class PasswordBaruPage extends StatefulWidget {
  final String GetToken;
  const PasswordBaruPage({super.key, required this.GetToken});

  @override
  State<PasswordBaruPage> createState() => _PasswordBaruPageState();
}

class _PasswordBaruPageState extends State<PasswordBaruPage>
    with TickerProviderStateMixin {
  TextEditingController passwordBaru = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool statusPwBaru = true;
  bool statusConfirmPw = true;
  String CekPwBaru = "";
  String CekConfirmPw = "";

  UbahPassword? ubahPassword;

  void _UbahPassword() async {
    try {
      ubahPassword = await UbahPassword.ubahPassword(
          widget.GetToken, passwordBaru.text, confirmPassword.text);
      setState(() {
        AnimateStatus = false;
      });
      AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              title: "Berhasil",
              desc: "Ubah password berhasil.",
              btnOkOnPress: () {},
              btnOkColor: Colors.blue)
          .show();
      logout();
    } catch (e) {
      setState(() {
        AnimateStatus = false;
      });
      AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              title: "Gagal",
              desc: e.toString(),
              btnOkOnPress: () {},
              btnOkColor: Colors.blue)
          .show();
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
  void dispose() {
    super.dispose();
    (controller != null) ? controller!.dispose() : "";
  }

  @override
  void initState() {
    super.initState();
  }

  void logout() {
    PostUser.logout(widget.GetToken).then((_) async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.remove('number_card');
      await sharedPreferences.remove('password');
      await sharedPreferences.remove('GetToken');

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return LoginPage();
      }), ((Route<dynamic> route) => false));
    }).catchError((error) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: "Gagal Logout",
        desc: error,
        btnOkOnPress: () {},
      ).show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.2),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 70, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Masukkan Password Baru",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 31, 104),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.08,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1.5,
                                  color: Color.fromARGB(255, 0, 31, 104))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    controller: passwordBaru,
                                    obscureText: statusPwBaru,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    statusPwBaru = !statusPwBaru;
                                  });
                                },
                                child: Icon(
                                    (statusPwBaru == false)
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color.fromARGB(
                                        255, 139, 139, 139)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            CekPwBaru,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontFamily: "Calibri",
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 40, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            "Masukkan Confirm Password Baru",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 31, 104),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.08,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1.5,
                                  color: Color.fromARGB(255, 0, 31, 104))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    controller: confirmPassword,
                                    obscureText: statusConfirmPw,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    statusConfirmPw = !statusConfirmPw;
                                  });
                                },
                                child: Icon(
                                    (statusConfirmPw == false)
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color.fromARGB(
                                        255, 139, 139, 139)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            CekConfirmPw,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 10,
                                fontFamily: "Calibri",
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: (AnimateStatus == false)
                        ? Container(
                            margin: EdgeInsets.only(top: 40),
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    width: 1.5,
                                    color: Color.fromARGB(255, 0, 31, 104))),
                            child: Material(
                              borderRadius: BorderRadius.circular(100),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100),
                                splashColor: Color.fromARGB(255, 0, 31, 104),
                                onTap: () {
                                  if (passwordBaru.text.isEmpty &&
                                      confirmPassword.text.isEmpty) {
                                    setState(() {
                                      CekConfirmPw = "Field harus diisi.";
                                      CekPwBaru = "Field harus diisi.";
                                    });
                                  } else if (passwordBaru.text.isEmpty &&
                                      confirmPassword.text.isNotEmpty) {
                                    setState(() {
                                      CekConfirmPw = "";
                                      CekPwBaru = "Field harus diisi.";
                                    });
                                  } else if (passwordBaru.text.isNotEmpty &&
                                      confirmPassword.text.isEmpty) {
                                    setState(() {
                                      CekConfirmPw = "Field harus diisi.";
                                      CekPwBaru = "";
                                    });
                                  } else if (passwordBaru.text.isNotEmpty &&
                                      confirmPassword.text.isNotEmpty &&
                                      confirmPassword.text ==
                                          passwordBaru.text) {
                                    setState(() {
                                      CekConfirmPw = "";
                                      CekPwBaru = "";
                                    });
                                    AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.question,
                                        animType: AnimType.topSlide,
                                        title: "Ubah Password",
                                        desc: "Yakin akan ubah password?",
                                        btnOkOnPress: () {
                                          setState(() {
                                            AnimateStatus = true;
                                            StartAnimate();
                                            _UbahPassword();
                                          });
                                        },
                                        btnCancelOnPress: () {
                                          
                                        }).show();
                                  } else {
                                    setState(() {
                                      CekConfirmPw =
                                          "Confirm Password tidak sesuai.";
                                    });
                                  }
                                },
                                child: Center(
                                    child: Text(
                                  "Ubah Password",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 31, 104),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 40),
                            child: Transform.rotate(
                              angle: (animation != null) ? animation!.value : 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.width * 0.15,
                                child: Icon(
                                  Icons.settings,
                                  size: 50,
                                  color: Color.fromARGB(255, 0, 31, 104),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          margin: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Icon(
                                  FontAwesomeIcons.arrowLeft,
                                  size: 27,
                                  color: Color.fromARGB(255, 0, 31, 104),
                                ),
                              ),
                              Text(
                                "Back",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 0, 31, 104),
                                ),
                              )
                            ],
                          )),
                    )),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "Password Baru",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 0, 31, 104),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 20, top: 5,right: 20),
                    child: Text(
                      "Buat password baru dengan 8 karakter dan menggunakan kombinasi huruf, angka dan simbol agar dapat meningkatkan keamanan akun anda.",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 139, 139, 139),
                          fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
