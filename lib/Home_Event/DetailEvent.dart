import 'package:Pilih_Dhewe/Home_Event/ApiHome_Event.dart';
import 'package:Pilih_Dhewe/Home_Event/DetailCandidate.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailEventPage extends StatefulWidget {
  final String Title;
  final String Duration;
  final String Status;
  final String Participant;
  final Color warnaStatus;
  final List<Candidates> KadidatDetail;
  final int User_id;
  final int Event_id;
  final String GetToken;
  final String Description;
  final int ParticipantData;

  const DetailEventPage(
      {required this.Title,
      required this.Duration,
      required this.Status,
      required this.Participant,
      required this.warnaStatus,
      required this.KadidatDetail,
      required this.User_id,
      required this.Event_id,
      required this.ParticipantData,
      required this.Description,
      required this.GetToken});

  @override
  State<DetailEventPage> createState() => _DetailEventPageState();
}

class _DetailEventPageState extends State<DetailEventPage> {
  bool Status = false;
  Color WarnaButton = Colors.blue;
  String Pilihan = "";

  Vote? vote = null;
  IsVoted? Isvoted;

  GetEvent? getEvent;
  @override
  void initState() {
    super.initState();
    setState(() {
      Votes();
    });
  }

  Future<void> Votes() async {
    try {
      Isvoted = await IsVoted.cekVoted(widget.Event_id, widget.GetToken);

      if (Isvoted == null) {
        // Pilihan = "Gagal Vote";
        Status = false;
      } else {
        // Pilihan = "Piihan Anda";
        Status = true;
      }
      setState(() {});
    } catch (e) {
      Pilihan = "Failed $e";
    }
  }

  void MenujuPilihDheweResult(int IDEvent) async {
    String url = "https://pilihdhewe.my.id/event/result/" + IDEvent.toString();
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Tidak dapat Membuka Link";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 47, 131, 255),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 0, 76, 255),
                  Color.fromARGB(255, 12, 87, 255),
                  Color.fromARGB(255, 47, 131, 255),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        // color: Colors.yellow,
                        margin: EdgeInsets.fromLTRB(15, 0, 10, 0),
                        child: Icon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                        // color: Colors.green,
                        child: Text(
                      "Detail Event ",
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 5,
              ),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 246, 249, 255),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.88,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: FutureBuilder(
                  future: Future.delayed(Duration(seconds: 4)),
                  builder: (context, snapshot) {
                    return (Status == false)
                        ? CustomScrollView(slivers: [
                            SliverToBoxAdapter(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                margin: EdgeInsets.fromLTRB(15, 0, 15, 40),
                                width: MediaQuery.of(context).size.width * 1,
                                child: Material(
                                  elevation: 4,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(40),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          height: (widget.Title.length >= 38)
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.22,
                                          child: Material(
                                            elevation: 5,
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 0, 76, 255),
                                                        Color.fromARGB(
                                                            255, 12, 87, 255),
                                                        Color.fromARGB(
                                                            255, 47, 131, 255),
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomRight),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Container(
                                                // color: Colors.red,
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 3, 10, 3),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    BuildItem(
                                                        iconData:
                                                            Icons.poll_rounded,
                                                        Widget: widget.Title,
                                                        warna: Colors.white,
                                                        Font: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w800),
                                                    BuildItem(
                                                        iconData: Icons
                                                            .person_pin_rounded,
                                                        Widget: widget
                                                                    .ParticipantData
                                                                .toString() +
                                                            " / " +
                                                            widget.Participant,
                                                        warna: Colors.white,
                                                        Font: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w800),
                                                    BuildItem(
                                                        iconData: Icons
                                                            .calendar_month_rounded,
                                                        Widget: widget.Duration,
                                                        warna: Colors.white,
                                                        Font: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w800),
                                                    BuildItem(
                                                        iconData: Icons
                                                            .question_mark_rounded,
                                                        Widget: widget.Status,
                                                        warna: (widget.Status ==
                                                                "Active")
                                                            ? Color.fromARGB(
                                                                255, 0, 255, 8)
                                                            : (widget.Status ==
                                                                    "End")
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        248,
                                                                        17,
                                                                        0)
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        212,
                                                                        212,
                                                                        212),
                                                        Font: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        LayoutBuilder(
                                            builder: (context, constraints) {
                                          return Container(
                                            padding:
                                                EdgeInsets.only(bottom: 25),
                                            margin: EdgeInsets.fromLTRB(
                                                15, 15, 15, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child:
                                                        Text("Description :")),
                                                Container(
                                                  child: Text(
                                                    widget.Description,
                                                    style: TextStyle(
                                                        fontFamily: "Arial",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 2, 24, 43),
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            width: constraints.maxWidth,
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                final candidate = widget.KadidatDetail[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DetailCandidatePage(
                                        NamaKadidat: candidate.user.name,
                                        KelasKadidat:
                                            candidate.user.kelas.namakelas,
                                        GambarKadidat: candidate.user.gambar,
                                        VisiKadidat: candidate.visi,
                                        VideoKadidat: candidate.video,
                                        MisiKadidat: candidate.misi,
                                      );
                                    }));
                                  },
                                  child: BuildVote(
                                    candidates: candidate,
                                  ),
                                );
                              }, childCount: widget.KadidatDetail.length),
                            ),
                          ])
                        : CustomScrollView(slivers: [
                            SliverToBoxAdapter(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                margin: EdgeInsets.fromLTRB(15, 0, 15, 40),
                                width: MediaQuery.of(context).size.width * 1,
                                child: Material(
                                  elevation: 4,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(40),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          height: (widget.Title.length >= 38)
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.22,
                                          child: Material(
                                            elevation: 5,
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 0, 76, 255),
                                                        Color.fromARGB(
                                                            255, 12, 87, 255),
                                                        Color.fromARGB(
                                                            255, 47, 131, 255),
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomRight),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Container(
                                                // color: Colors.red,
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 3, 10, 3),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    BuildItem(
                                                        iconData:
                                                            Icons.poll_rounded,
                                                        Widget: widget.Title,
                                                        warna: Colors.white,
                                                        Font: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w800),
                                                    BuildItem(
                                                        iconData: Icons
                                                            .person_pin_rounded,
                                                        Widget: widget
                                                                    .ParticipantData
                                                                .toString() +
                                                            " / " +
                                                            widget.Participant,
                                                        warna: Colors.white,
                                                        Font: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w800),
                                                    BuildItem(
                                                        iconData: Icons
                                                            .calendar_month_rounded,
                                                        Widget: widget.Duration,
                                                        warna: Colors.white,
                                                        Font: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w800),
                                                    BuildItem(
                                                        iconData: Icons
                                                            .question_mark_rounded,
                                                        Widget: widget.Status,
                                                        warna: (widget.Status ==
                                                                "Active")
                                                            ? Color.fromARGB(
                                                                255, 0, 255, 8)
                                                            : (widget.Status ==
                                                                    "End")
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        248,
                                                                        17,
                                                                        0)
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        212,
                                                                        212,
                                                                        212),
                                                        Font: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        LayoutBuilder(
                                            builder: (context, constraints) {
                                          return Container(
                                            padding:
                                                EdgeInsets.only(bottom: 25),
                                            margin: EdgeInsets.fromLTRB(
                                                15, 15, 15, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child:
                                                        Text("Description :")),
                                                Container(
                                                  child: Text(
                                                    widget.Description,
                                                    style: TextStyle(
                                                        fontFamily: "Arial",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 2, 24, 43),
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            width: constraints.maxWidth,
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                final candidate = widget.KadidatDetail[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return DetailCandidatePage(
                                        NamaKadidat: candidate.user.name,
                                        KelasKadidat:
                                            candidate.user.kelas.namakelas,
                                        GambarKadidat: candidate.user.gambar,
                                        VisiKadidat: candidate.visi,
                                        VideoKadidat: candidate.video,
                                        MisiKadidat: candidate.misi,
                                      );
                                    }));
                                  },
                                  child: BuildVote(
                                      candidates: candidate, isVoted: Isvoted),
                                );
                              }, childCount: widget.KadidatDetail.length),
                            ),
                            SliverToBoxAdapter(
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 35, right: 20, left: 20, bottom: 15),
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                child: Material(
                                  elevation: 3.5,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 0, 76, 255),
                                            Color.fromARGB(255, 12, 87, 255),
                                            Color.fromARGB(255, 47, 131, 255),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter),
                                    ),
                                    child: Material(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
                                      child: InkWell(
                                        onTap: () {
                                          MenujuPilihDheweResult(
                                              widget.Event_id);
                                        },
                                        splashColor: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Center(
                                          child: Text(
                                            "Lihat Hasil",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w800),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]);
                  },
                  // ))
                ),
              ),
            ),
          ],
        ));
  }

  Container BuildVote({
    Candidates? candidates,
    IsVoted? isVoted,
  }) {
    bool isSelected = false; // Inisialisasi variabel isSelected
    if (isVoted != null && candidates != null) {
      isSelected = (isVoted.userVote.name == candidates.user.name);
    }

    return Container(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.15,
      margin: EdgeInsets.fromLTRB(15, 10, 15, 15),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(40),
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.blue, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.17,
                  height: MediaQuery.of(context).size.width * 0.17,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(300),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(candidates!.user.gambar),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(300),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      (candidates != null) ? candidates.user.name : "",
                      style: TextStyle(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 3, 28, 48),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: (isSelected)
                      ? InkWell(
                          onTap: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.topSlide,
                              showCloseIcon: true,
                              title: "Pilihan Anda",
                              desc: "Anda telah memilih kandidat ini.",
                              btnOkOnPress: () {},
                              btnOkColor: Colors.blue,
                            ).show();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            height: MediaQuery.of(context).size.width * 0.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 136, 255,
                                          89), // Kandidat yang dipilih
                                      Color.fromARGB(255, 2, 204, 12),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: Icon(
                              FontAwesomeIcons.thumbtack,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : (candidates != null && Status == false)
                          ? (widget.Status == "Active")
                              ? InkWell(
                                  onTap: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.info,
                                      animType: AnimType.topSlide,
                                      title: "Yakin Pilih ???",
                                      desc: "Apakah yakin akan memilih " +
                                          candidates.user.name,
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                        // Implementasi pemilihan kandidat
                                        Vote.voteInsert(
                                          widget.Event_id,
                                          candidates.id,
                                          widget.GetToken,
                                        );

                                        Navigator.pop(context);
                                      },
                                      btnOkColor: Colors.blue,
                                      btnCancelColor:
                                          Color.fromARGB(255, 236, 218, 50),
                                    ).show();
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    height:
                                        MediaQuery.of(context).size.width * 0.1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors
                                                  .blue, // Kandidat yang dipilih
                                              Color.fromARGB(255, 12, 87, 255),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight)),
                                    child: Icon(
                                      FontAwesomeIcons.thumbtack,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1,
                                  height:
                                      MediaQuery.of(context).size.width * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.width * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            )),
            ],
          ),
        ),
      ),
    );
  }

  Align BuildItem({
    required IconData iconData,
    required String Widget,
    required Color warna,
    required String Font,
    required FontWeight fontWeight,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        // color: Colors.yellow,
        width: MediaQuery.of(context).size.width * 1,
        height:
            // MediaQuery.of(context).size.height * 0.04,
            (Widget != widget.Title)
                ? MediaQuery.of(context).size.height * 0.04
                : (widget.Title.length >= 38)
                    ? MediaQuery.of(context).size.height * 0.07
                    : MediaQuery.of(context).size.height * 0.04,
        margin:
            // EdgeInsets.fromLTRB(0, 3, 0, 0),
            (Widget != widget.Title)
                ? EdgeInsets.fromLTRB(0, 3, 0, 0)
                : (widget.Title.length >= 38)
                    ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : EdgeInsets.fromLTRB(0, 3, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 7, 0),
              child: Icon(
                iconData,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 28,
              ),
            ),
            Container(
              //color: Colors.red,
              width: MediaQuery.of(context).size.width * 0.75,
              // child: FittedBox(
              //   alignment: Alignment.centerLeft,
              //   fit: BoxFit.scaleDown,
              child: Text(
                Widget,
                style: TextStyle(
                    fontFamily: Font,
                    color: warna,
                    fontSize: 17,
                    fontWeight: fontWeight),
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
            ),
            //),
          ],
        ),
      ),
    );
  }
}
