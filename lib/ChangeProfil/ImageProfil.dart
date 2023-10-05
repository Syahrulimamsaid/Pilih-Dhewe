import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:Pilih_Dhewe/ChangeProfil/PersonalData.dart';
import 'package:Pilih_Dhewe/Profil/ApiProfil.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InfoGambarPage extends StatefulWidget {
  final String GetToken;
  const InfoGambarPage({required this.GetToken});

  @override
  State<InfoGambarPage> createState() => _InfoGambarPageState();
}

class _InfoGambarPageState extends State<InfoGambarPage> {
  File? images;
  Future AmbilGambarGalery() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        images = File(image.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UbahGambarPage(
                      imageFile: images!,
                      GetToken: widget.GetToken,
                    )));
      });
    }
  }

  Future AmbilGambarCamera() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        images = File(image.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UbahGambarPage(
                      imageFile: images!,
                      GetToken: widget.GetToken,
                    )));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.down,
            onDismissed: (direction) {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 246, 249, 255),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.33,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Foto Profil",
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
                    child: Text(
                      "Jenis file yang diterima hanya jpg dan ukuran maximal file adalah 2 mb.",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Calibri",
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            await AmbilGambarGalery();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.17,
                            height: MediaQuery.of(context).size.width * 0.17,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color.fromARGB(255, 215, 237, 255)),
                            child: Icon(
                              Icons.image,
                              color: Color.fromARGB(255, 22, 92, 255),
                              size: 37,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await AmbilGambarCamera();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 15),
                            width: MediaQuery.of(context).size.width * 0.17,
                            height: MediaQuery.of(context).size.width * 0.17,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color.fromARGB(255, 215, 237, 255)),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: Color.fromARGB(255, 22, 92, 255),
                              size: 37,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class UbahGambarPage extends StatefulWidget {
  final File imageFile;
  final String GetToken;
  const UbahGambarPage({required this.imageFile, required this.GetToken});

  @override
  State<UbahGambarPage> createState() => _UbahGambarPageState();
}

class _UbahGambarPageState extends State<UbahGambarPage>
    with TickerProviderStateMixin {
  String Error = "";
  bool Status = false;
  bool StatusImage = false;
  UbahGambar? ubahGambar;

  bool validateImageFile(File imageFile) {
    if (imageFile.path.toLowerCase().endsWith(".jpg")) {
      if (imageFile.lengthSync() <= 2 * 1024 * 1024) {
        return true;
      } else {
        setState(() {
          Status = true;
          Error = "Ukuran file melebihi batas maximal yang ditetapkan.";
        });
        return false;
      }
    } else {
      setState(() {
        Status = true;
        Error = "Jenis file tidak sesuai.";
      });
      return false;
    }
  }

  void UbahGambarUser() async {
    try {
      await UbahGambar.ubahGambar(widget.GetToken, widget.imageFile);
      setState(() {
        AnimateStatus = false;
        Status = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => UbahProfilPage(GetToken: widget.GetToken)),
          ((Route route) => false));
    } catch (e) {
      setState(() {
        AnimateStatus = false;
        Status = true;
        Error = e.toString();
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
  void dispose() {
    (controller != null) ? controller!.dispose() : "";
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    validateImageFile(widget.imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(10),
            child: Container(
              child: Image.file(widget.imageFile),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: (AnimateStatus == false)
              ? Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.all(30),
                              child: Text(
                                "Batal",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              AnimateStatus = true;
                              StartAnimate();
                              UbahGambarUser();
                            });
                          },
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.all(30),
                              child: Text(
                                "Selesai",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]))
              : Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Transform.rotate(
                    angle: (animation != null) ? animation!.value : 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.width * 0.15,
                      child: Icon(
                        Icons.settings,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ),
        (Status != false)
            ? Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Material(
                    elevation: 4,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Gagal",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: "Poppins",
                                    color: Color.fromARGB(255, 0, 31, 104)),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                child: Text(
                                  Error,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Poppins",
                                      color: Color.fromARGB(255, 0, 31, 104)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Color.fromARGB(255, 0, 94, 255)),
                                  child: Center(
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
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
                ),
              )
            : Align(
                alignment: Alignment.center,
                child: Container(),
              )
      ]),
    );
  }
}
