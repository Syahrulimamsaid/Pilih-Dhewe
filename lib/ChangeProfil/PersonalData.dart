import 'dart:async';
import 'dart:math';

import 'package:Pilih_Dhewe/ChangeProfil/ImageProfil.dart';
import 'package:Pilih_Dhewe/Home_Event/Home.dart';
import 'package:Pilih_Dhewe/Image/DetailNetworkImage.dart';
import 'package:Pilih_Dhewe/Profil/ApiProfil.dart';
import 'package:Pilih_Dhewe/Profil/Profil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UbahProfilPage extends StatefulWidget {
  final String? NameProfil;
  final String? KelasProfil;
  final String? Genderprofil;
  final String? RoleProfil;
  final String GetToken;
  final String? Number_Card;
  final int? Idkelas;
  final int? IdUser;

  const UbahProfilPage(
      {this.NameProfil,
      this.Genderprofil,
      this.KelasProfil,
      required this.GetToken,
      this.Number_Card,
      this.IdUser,
      this.Idkelas,
      this.RoleProfil});

  @override
  State<UbahProfilPage> createState() => _UbahProfilPageState();
}

class _UbahProfilPageState extends State<UbahProfilPage>
    with TickerProviderStateMixin {
  String ErrorName = "";
  UbahDataUser? ubahDataUser;
  bool StatusEdit = false;
  TextEditingController name = TextEditingController();
  Future<List<ListKelas>>? getKelas = null;
  ListKelas? _selectedKelas;
  String PilihanKelas = "";
  int IdPilihanKelas = 0;
  List<String> ListJenisKelamin = ["Laki-laki", "Perempuan"];
  String PilihanJenisKelamin = "";
  List<String> Load = ["Sedang Memproses Data"];
  DataMe? dataMe;
  String Gambar = "";
  String Name = "";
  String Gender = "";
  String Kelas = "";
  int IdKelas = 0;
  String Username = "";
  int IdUser = 0;

  void UbahData() async {
    try {
      bool BerhasilTidak = await UbahDataUser.ubahDataUser(
          widget.GetToken.toString(),
          name.text,
          PilihanJenisKelamin,
          IdPilihanKelas,
          IdUser);
      setState(() {
        AnimateStatus = !AnimateStatus;
      });
      if (BerhasilTidak == true) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: "Berhasil",
          desc: "Data berhasil diubah",
          animType: AnimType.topSlide,
          btnOkOnPress: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage(GetToken: widget.GetToken.toString())),
                ((Route<dynamic> route) => false));
          },
        ).show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: "Gagal",
          desc: "Data gagal diubah",
          animType: AnimType.topSlide,
          btnOkOnPress: () {},
        ).show();
      }
    } catch (e) {
      setState(() {
        AnimateStatus = !AnimateStatus;
      });
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: "Gagal",
        desc: "$e",
        animType: AnimType.topSlide,
        btnOkOnPress: () {},
      ).show();
    }
  }

  Route<dynamic> MunculPage(Widget pages) {
    return PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black54,
      pageBuilder: (context, animation, secondaryAnimation) {
        return pages;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  void GetDataMe() async {
    try {
      Gambar = "";
      dataMe = await DataMe.GetMe(widget.GetToken);

      if (dataMe != null) {
        setState(() {
          Gambar = dataMe!.gambar;
          name.text = dataMe!.name;
          PilihanJenisKelamin = dataMe!.gender;
          PilihanKelas = dataMe!.kelas.namakelas;
          IdPilihanKelas = dataMe!.kelas.id;
          Username = dataMe!.number_card;
          IdUser = dataMe!.id;
        });
      }
    } catch (e) {}
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
    GetDataMe();
    getKelas = ListKelas.getKelas(widget.GetToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Stack(children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfilPage(GetToken: widget.GetToken)),
                            (route) => false);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          FontAwesomeIcons.arrowLeft,
                          size: 27,
                          color: Color.fromARGB(255, 0, 31, 104),
                        ),
                      ))),
              Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: (dataMe != null)
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            height: MediaQuery.of(context).size.width * 0.4,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Stack(children: [
                              InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DetailNetworkImagePage(
                                              Gambar: Gambar);
                                        });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(Gambar),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            100,
                                          ),
                                        ),
                                        border: Border.all(
                                            width: 2,
                                            color: Color.fromARGB(
                                                255, 1, 27, 48))),
                                  )),
                              Positioned(
                                bottom: MediaQuery.of(context).size.width *
                                    2 /
                                    5 /
                                    20,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MunculPage(InfoGambarPage(
                                      GetToken: widget.GetToken,
                                    )));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.125,
                                    height: MediaQuery.of(context).size.width *
                                        0.125,
                                    child: Material(
                                      elevation: 4,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
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
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: Icon(
                                          FontAwesomeIcons.camera,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            height: MediaQuery.of(context).size.width * 0.4,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Stack(children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        100,
                                      ),
                                    ),
                                    border: Border.all(
                                        width: 2,
                                        color: Color.fromARGB(255, 1, 27, 48))),
                              ),
                              Positioned(
                                bottom: MediaQuery.of(context).size.width *
                                    2 /
                                    5 /
                                    20,
                                right: 0,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.125,
                                  height:
                                      MediaQuery.of(context).size.width * 0.125,
                                  child: Material(
                                    elevation: 4,
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(255, 0, 76, 255),
                                                Color.fromARGB(
                                                    255, 12, 87, 255),
                                                Color.fromARGB(
                                                    255, 47, 131, 255),
                                              ],
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Icon(
                                        FontAwesomeIcons.camera,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                  ),
                  InkWell(
                    onTap: () async {
                      final newName = await Navigator.of(context)
                          .push(MunculPage(UbahNamaPage(Name: name.text)));

                      if (newName != null) {
                        setState(() {
                          name.text = newName; // Update the name in the state
                        });
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        child: Text(
                                          "Nama",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Color.fromARGB(
                                                  255, 0, 31, 104),
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        child: Text(
                                          ErrorName,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.red,
                                              fontFamily: "Calibri",
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * 0.07,
                              padding: EdgeInsets.only(
                                left: 10,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                    height: MediaQuery.of(context).size.width *
                                        0.08,
                                    child: Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 0, 76, 255),
                                      size: 20,
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.63,
                                      margin: EdgeInsets.only(left: 15),
                                      child: Text(name.text,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 26, 26, 26),
                                              fontSize: 17,
                                              fontFamily: "Calibri",
                                              fontWeight: FontWeight.w600))),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        child: Icon(
                                          FontAwesomeIcons.pencil,
                                          size: 20,
                                          color:
                                              Color.fromARGB(255, 0, 76, 255),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Jenis Kelamin",
                            style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 0, 31, 104),
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.07,
                          padding:
                              EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.08,
                                height:
                                    MediaQuery.of(context).size.width * 0.08,
                                child: Icon(
                                  FontAwesomeIcons.venusMars,
                                  color: Color.fromARGB(255, 0, 76, 255),
                                  size: 20,
                                ),
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  margin: EdgeInsets.only(left: 15),
                                  child: Text(PilihanJenisKelamin,
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 26, 26, 26),
                                          fontSize: 17,
                                          fontFamily: "Calibri",
                                          fontWeight: FontWeight.w600))),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: PopupMenuButton<String>(
                                      icon: Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                        size: 20,
                                        color: Color.fromARGB(255, 0, 76, 255),
                                      ),
                                      onOpened: () {},
                                      onSelected: (String newValue) {
                                        setState(() {
                                          PilihanJenisKelamin = newValue;
                                        });
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return ListJenisKelamin.map((jenis) {
                                          return PopupMenuItem<String>(
                                            value: jenis,
                                            child: Text(jenis),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Kelas",
                            style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 0, 31, 104),
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.height * 0.07,
                          padding:
                              EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.08,
                                height:
                                    MediaQuery.of(context).size.width * 0.08,
                                //color: Colors.yellow,
                                child: Icon(
                                  Icons.door_back_door,
                                  color: Color.fromARGB(255, 0, 76, 255),
                                  size: 25,
                                ),
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  margin: EdgeInsets.only(left: 15),
                                  child: Text(PilihanKelas,
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 26, 26, 26),
                                          fontSize: 17,
                                          fontFamily: "Calibri",
                                          fontWeight: FontWeight.w600))),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                    child: FutureBuilder<List<ListKelas>>(
                                      future: getKelas,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            child: PopupMenuButton<String>(
                                              icon: Icon(
                                                Icons
                                                    .arrow_drop_down_circle_outlined,
                                                size: 20,
                                                color: Color.fromARGB(
                                                    255, 0, 76, 255),
                                              ),
                                              onOpened: () {},
                                              onSelected: (String newValue) {
                                                setState(() {});
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return Load.map((load) {
                                                  return PopupMenuItem<String>(
                                                    value: load,
                                                    child: Text(load),
                                                  );
                                                }).toList();
                                              },
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Text('Tidak ada data kelas.');
                                        } else {
                                          return Container(
                                            child: PopupMenuButton<ListKelas>(
                                              icon: Icon(
                                                Icons
                                                    .arrow_drop_down_circle_outlined,
                                                size: 20,
                                                color: Color.fromARGB(
                                                    255, 0, 76, 255),
                                              ),
                                              onSelected: (ListKelas newValue) {
                                                setState(() {
                                                  PilihanKelas = newValue
                                                      .NameKelas.toString();
                                                  IdPilihanKelas =
                                                      newValue.IdKelas;
                                                });
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return snapshot.data!
                                                    .map((kelas) {
                                                  return PopupMenuItem<
                                                      ListKelas>(
                                                    value: kelas,
                                                    child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                        child: Text(
                                                            kelas.NameKelas)),
                                                  );
                                                }).toList();
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: BuildText("Username", Icons.account_box, Username),
                  ),
                  (AnimateStatus == false)
                      ? Container(
                          margin: EdgeInsets.only(top: 30),
                          height: MediaQuery.of(context).size.height * 0.07,
                          width: MediaQuery.of(context).size.width * 0.35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                width: 2,
                                color: Color.fromARGB(255, 0, 76, 255),
                              )),
                          child: InkWell(
                            onTap: () {
                              if (name.text.isEmpty) {
                                setState(() {
                                  ErrorName = "Field harus diisi.";
                                });
                              } else {
                                setState(() {
                                  ErrorName = "";
                                });
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  title: "Ubah Data",
                                  desc:
                                      "Apakah yakin akan melakukan ubah data?",
                                  animType: AnimType.topSlide,
                                  btnOkOnPress: () {
                                    setState(() {
                                      AnimateStatus = !AnimateStatus;
                                      StartAnimate();
                                    });

                                    UbahData();
                                  },
                                  btnCancelOnPress: () {},
                                ).show();
                              }
                            },
                            borderRadius: BorderRadius.circular(100),
                            splashColor: Color.fromARGB(255, 0, 76, 255),
                            child: Center(
                              child: Text(
                                "Ubah Data",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 76, 255),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Transform.rotate(
                            angle: (animation != null) ? animation!.value : 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.width * 0.15,
                              child: Icon(
                                Icons.settings,
                                size: 50,
                                color: Color.fromARGB(255, 0, 76, 255),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Column BuildText(String TextTitle, IconData iconData, String Isi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            TextTitle,
            style: TextStyle(
                fontSize: 13,
                color: Color.fromARGB(255, 0, 31, 104),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 0.07,
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
                //color: Colors.yellow,
                child: Icon(
                  iconData,
                  color: Color.fromARGB(255, 0, 76, 255),
                  size: 25,
                ),
              ),
              Container(
                  //color: Colors.blue,
                  width: MediaQuery.of(context).size.width * 0.73,
                  margin: EdgeInsets.only(left: 15),
                  child: Text(Isi,
                      style: TextStyle(
                          color: const Color.fromARGB(255, 26, 26, 26),
                          fontSize: 17,
                          fontFamily: "Calibri",
                          fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ],
    );
  }
}

class UbahNamaPage extends StatefulWidget {
  final String Name;
  const UbahNamaPage({required this.Name});

  @override
  State<UbahNamaPage> createState() => _UbahNamaPageState();
}

class _UbahNamaPageState extends State<UbahNamaPage> {
  @override
  void initState() {
    super.initState();

    name.text = widget.Name;
  }

  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 246, 249, 255),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Masukkan nama Anda",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 57, 104),
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w800,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TextField(
                    autofocus: true,
                    style: TextStyle(
                        color: Color.fromARGB(255, 26, 26, 26),
                        fontSize: 17,
                        fontFamily: "Calibri",
                        fontWeight: FontWeight.w600),
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: name,
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width * 0.05),
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text(
                              "Batal",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 31, 104),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context, name.text);
                          },
                          child: Container(
                            child: Text(
                              "Selesai",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 31, 104),
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
