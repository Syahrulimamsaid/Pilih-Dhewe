import 'package:Pilih_Dhewe/ChangePassword/ApiPassword.dart';
import 'package:Pilih_Dhewe/ChangePassword/NewPassword.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

class UbahPasswordPage extends StatefulWidget {
  final String GetToken;
  const UbahPasswordPage({super.key, required this.GetToken});

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage>
    with TickerProviderStateMixin {
  TextEditingController passwordLama = TextEditingController();
  bool statusPw = true;
  String CekPw = "";
  CekPassword? cekPassword;

  void CekPasswordLama() async {
    if (passwordLama.text.isNotEmpty) {
      try {
        bool isPasswordCorrect =
            await CekPassword.cekPassword(widget.GetToken, passwordLama.text);
        setState(() {
          CekPw = "";
          AnimateStatus = false;
          passwordLama.text = "";
        });
        if (isPasswordCorrect == true) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PasswordBaruPage(GetToken: widget.GetToken);
          }));
        } else {
          setState(() {
            AnimateStatus = false;
            CekPw = "Password tidak sesuai.";
          });
        }
      } catch (e) {}
    } else {
      setState(() {
        CekPw = "Field harus diisi.";
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
    super.dispose();
    (controller != null) ? controller!.dispose() : "";
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
                  top: MediaQuery.of(context).size.height * 0.15),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 70, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            "Masukkan Password Lama",
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
                                    controller: passwordLama,
                                    obscureText: statusPw,
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
                                    statusPw = !statusPw;
                                  });
                                },
                                child: Icon(
                                    (statusPw == false)
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
                            CekPw,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 13,
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
                            width: MediaQuery.of(context).size.width * 0.3,
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
                                  if (passwordLama.text.isNotEmpty) {
                                    setState(() {
                                      AnimateStatus = true;
                                    });

                                    StartAnimate();
                                  }
                                  else
                                  {

                                  }

                                  CekPasswordLama();
                                },
                                child: Center(
                                    child: Text(
                                  "Cek",
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
                      "Ubah Password",
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
                      "Masukkan password lama untuk pengecekan akan kebenaran akun anda.",
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
