import 'dart:ui';
import 'package:Pilih_Dhewe/ChangePassword/Check.dart';
import 'package:Pilih_Dhewe/ChangeProfil/PersonalData.dart';
import 'package:Pilih_Dhewe/Home_Event/EventDiikuti.dart';
import 'package:Pilih_Dhewe/Home_Event/Home.dart';
import 'package:Pilih_Dhewe/AboutApp/AboutApp.dart';
import 'package:Pilih_Dhewe/Profil/ApiProfil.dart';
import 'package:Pilih_Dhewe/Settings/Settings.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilPage extends StatefulWidget {
  final String GetToken;
  final String? GambarProfil;
  final String? Theme;

  const ProfilPage({this.GambarProfil, required this.GetToken, this.Theme});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  void initState() {
    super.initState();
    GetDataMe();
  }

  DataMe? dataMe;
  String Gambar = "";
  String Name = "";
  String Gender = "";
  String Kelas = "";
  String CandidateOf = "";

  void GetDataMe() async {
    try {
      dataMe = await DataMe.GetMe(widget.GetToken);
      if (dataMe != null) {
        setState(() {
          Gambar = dataMe!.gambar;
          Name = dataMe!.name;
          Gender = dataMe!.gender;
          Kelas = dataMe!.kelas.namakelas;
          CandidateOf = dataMe!.candidateOf.length.toString();
        });
      }
    } catch (e) {}
  }

  void MenujuPilihDhewe() async {
    String url = "https://pilihdhewe.my.id";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Tidak dapat Membuka Link";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Positioned(
              left: -MediaQuery.of(context).size.width * 8 / 7 / 5,
              top: -MediaQuery.of(context).size.width * 8 / 7 / 4,
              child: Container(
                width: MediaQuery.of(context).size.width * 1.5,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(Gambar), fit: BoxFit.cover)),
              ),
            ),
            Positioned.fill(
              child: Container(
                width: MediaQuery.of(context).size.width * 1.5,
                height: MediaQuery.of(context).size.height * 0.1,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Color.fromARGB(68, 0, 76, 255),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage(
                                              GetToken: widget.GetToken)),
                                      (route) => false);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  child: Icon(
                                    FontAwesomeIcons.arrowLeft,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UbahProfilPage(
                                              GetToken: widget.GetToken)));
                                },
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  child: Icon(
                                    FontAwesomeIcons.penToSquare,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.width * 0.18,
                          margin: EdgeInsets.fromLTRB(10,
                              MediaQuery.of(context).size.height * 0.1, 10, 10),
                          child: Center(
                            child: Text(
                              Name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 0, 57, 104),
                                  fontFamily: "Poppins",
                                  fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.width * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 4,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        Gender,
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 57, 104),
                                            fontFamily: "Poppins",
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Jenis Kelamin",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 139, 139, 139),
                                            fontFamily: "Poppins",
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  color:
                                      const Color.fromARGB(255, 192, 192, 192),
                                  width: 3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          Kelas,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 0, 57, 104),
                                              fontFamily: "Poppins",
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "Kelas",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 139, 139, 139),
                                              fontFamily: "Poppins",
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  )),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  color:
                                      const Color.fromARGB(255, 192, 192, 192),
                                  width: 3,
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                ),
                              ),
                              Flexible(
                                  flex: 4,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          CandidateOf.toString(),
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 0, 57, 104),
                                            fontFamily: "Poppins",
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "Event Diikuti",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 139, 139, 139),
                                              fontFamily: "Poppins",
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.02,
                          color: Color.fromARGB(255, 246, 249, 255),
                        ),
                        InkWell(
                            splashColor:
                                const Color.fromARGB(255, 155, 155, 155),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => UbahPasswordPage(
                                            GetToken: widget.GetToken,
                                          ))));
                            },
                            child:
                                BuildMenu(Icons.lock_outline, "Ubah Password")),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => EventDiikutiPage(
                                            GetToken: widget.GetToken,
                                          ))));
                            },
                            child: BuildMenu(
                                Icons.poll_outlined, "Event Diikuti")),
                        InkWell(
                            onTap: () {
                              MenujuPilihDhewe();
                            },
                            child: BuildMenu(Icons.workspace_premium_outlined,
                                "Hasil Pilihan")),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => SettingsPage())));
                            },
                            child: BuildMenu(Symbols.settings, "Settings")),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => AboutAppPage())));
                            },
                            child: BuildMenu(
                                Icons.info_outlined, "Tentang Aplikasi")),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.063,
              left: MediaQuery.of(context).size.width * 4 / 3 / 4.1,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                child: Material(
                  elevation: 4,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage((dataMe != null)
                                ? dataMe!.gambar
                                : widget.GambarProfil.toString()),
                            fit: BoxFit.cover),
                        border: Border.all(
                            color: Color.fromARGB(255, 1, 27, 48), width: 1.5),
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Container BuildMenu(IconData IconMenu, String TextMenu) {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 25),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Color.fromARGB(255, 215, 237, 255)),
            child: Icon(
              IconMenu,
              color: Color.fromARGB(255, 22, 92, 255),
              size: 25,
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(TextMenu,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 0, 57, 104),
                  )))
        ],
      ),
    );
  }
}
