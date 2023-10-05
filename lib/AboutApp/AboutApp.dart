import 'package:Pilih_Dhewe/Image/DetailAssetsImage.dart';
import 'package:Pilih_Dhewe/Image/DetailNetworkImage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'DevelopmentTeamPage.dart';

class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key});

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Copyright ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: "Calibri"),
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.copyright,
                          size: 15,
                        ),
                        Text(
                          " 2023",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: "Calibri"),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Text(
                      " PBL Development and Pilih Dhewe Teams.",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: "Calibri"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.4,
                      child: Material(
                        elevation: 4,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(300),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailAssetsImagePage(
                                  Gambar: "assets/images/PilihDheweIcon.png");
                            }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(300),
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/PilihDheweIcon.png"),
                                    fit: BoxFit.contain)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                      child: Text(
                        "Pilih Dhewe",
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 1, 27, 48),
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Versi 1.0.1",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 15, 15),
                      child: Text(
                        "Pilih Dhewe merupakan Proyek Aplikasi Voting yang kami ciptakan untuk mengembangkan solusi modern untuk melakukan pemungutan suara. Dengan memanfaatkan SDK Flutter dan bersama dengan fitur canggih lainnya, aplikasi ini bertujuan untuk menjawab tantangan dalam sistem pemungutan suara tradisional. Memanfaatkan teknologi mutakhir, kami bertujuan untuk memastikan integritas suara dan meningkatkan partisipasi dalam proses demokrasi.",
                        style: TextStyle(
                          color: Color.fromARGB(255, 61, 61, 61),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Material(
                        elevation: 3,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 230, 242, 253),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: const Color.fromARGB(255, 0, 76, 255),
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                setState(() {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: ((context) {
                                    return DevelopmentTeamPage();
                                  })));
                                });
                              },
                              child: Center(
                                child: Text(
                                  "Development Team",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 45, 144, 224),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 1,
              top: 1,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: Color.fromARGB(255, 1, 27, 48),
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
