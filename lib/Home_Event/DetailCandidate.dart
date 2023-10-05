import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Image/DetailNetworkImage.dart';

class DetailCandidatePage extends StatefulWidget {
  final String NamaKadidat;
  final String KelasKadidat;
  final String GambarKadidat;
  final String VisiKadidat;
  final String MisiKadidat;
  final String VideoKadidat;

  const DetailCandidatePage(
      {required this.NamaKadidat,
      required this.KelasKadidat,
      required this.GambarKadidat,
      required this.VisiKadidat,
      required this.VideoKadidat,
      required this.MisiKadidat});

  @override
  State<DetailCandidatePage> createState() => _DetailCandidatePageState();
}

class _DetailCandidatePageState extends State<DetailCandidatePage> {
  String Misi = "";
  void CreateMisiNumber() {
    List<String> Text = widget.MisiKadidat.split("\n");

    for (int i = 0; i < Text.length; i++) {
      Misi += '${i + 1}. ${Text[i]}\n';
    }
    ;
  }

  
  void OpenVideo() async {
    if (await canLaunchUrl(Uri.parse(widget.VideoKadidat))) {
      await launchUrl(Uri.parse(widget.VideoKadidat));
    } else {
      throw "Tidak dapat Membuka Link";
    }
  }


  @override
  void initState() {
    super.initState();
    CreateMisiNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Color.fromARGB(255, 246, 249, 255),
      body: Stack(children: [
        Positioned(
          top: 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: Icon(
                          FontAwesomeIcons.arrowLeft,
                          color: Color.fromARGB(255, 1, 27, 48),
                          size: 27,
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
                        OpenVideo();
                      },
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: Icon(
                          FontAwesomeIcons.fileVideo,
                          color: Color.fromARGB(255, 1, 27, 48),
                          size: 27,
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
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailNetworkImagePage(
                              Gambar: widget.GambarKadidat)),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.width * 0.45,
                    child: Material(
                      elevation: 4,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(300),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(300),
                            image: DecorationImage(
                                image: NetworkImage(widget.GambarKadidat),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 10,
                            ),
                            child: Text(
                              widget.NamaKadidat,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color.fromARGB(255, 0, 57, 104),
                                  fontFamily: "Poppins",
                                  fontSize: 25),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              widget.KelasKadidat,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 0, 57, 104),
                                  fontFamily: "Poppins"),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color.fromARGB(255, 1, 39, 70),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.005,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.51,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Visi",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 57, 104),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 7),
                              child: Text(
                                widget.VisiKadidat,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 102, 102, 102),
                                    fontSize: 14,
                                    fontFamily: "Arial"),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Misi",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 57, 104),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                            Container(
                              child: Text(
                                Misi,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 102, 102, 102),
                                    fontSize: 14,
                                    fontFamily: "Arial"),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
