import 'package:Pilih_Dhewe/Home_Event/ApiHome_Event.dart';
import 'package:Pilih_Dhewe/Login/ApiLogin.dart';
import 'package:Pilih_Dhewe/Login/Login.dart';
import 'package:Pilih_Dhewe/Profil/ApiProfil.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Profil/Profil.dart';
import 'DetailEvent.dart';

class HomePage extends StatefulWidget {
  final int? ID;
  final String? Name;
  final String? Gender;
  final String? Role;
  final String? Number_Card;
  final String GetToken;
  final String? Kelas;
  final int? IdKelas;
  final String? GambarProfil;
  // final String? Theme;
  final Function()? refreshCallback;

  const HomePage(
      {this.ID,
      this.Name,
      this.Gender,
      this.Role,
      this.Number_Card,
      this.IdKelas,
      required this.GetToken,
      this.GambarProfil,
      this.Kelas,
      // this.Theme,
      this.refreshCallback});

  @override
  State<HomePage> createState() => _HomePageState();
}

class Event {
  final String Title;
  final String Duration;
  final String Status;
  final Color warnaStatus;
  final String Participant;
  final List<Candidates> Kadidat;

  Event({
    required this.Title,
    required this.Duration,
    required this.Status,
    required this.warnaStatus,
    required this.Participant,
    required this.Kadidat,
  });
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String? Tes;

  DataMe? dataMe;
  String Name = "";
  String Kelas = "";
  String Gambar = "";
  int IdUser = 0;
  String Jalan = "Belum Jalan";

  void GetDataMe() async {
    try {
      dataMe = await DataMe.GetMe(widget.GetToken);

      if (dataMe != null) {
        setState(() {
          IdUser = dataMe!.id;
          Name = dataMe!.name;
          Kelas = dataMe!.kelas.namakelas;
          Gambar = dataMe!.gambar;
          Jalan = "Jalan";
        });
      }
    } catch (e) {
      Jalan = e.toString();
    }
  }

  void Hapus() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    // await sharedPreferences.remove('number_card');
    // await sharedPreferences.remove('password');
    await sharedPreferences.remove('GetToken');
  }

  void logout() {
    PostUser.logout(widget.GetToken).then((_) async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.remove('GetToken');
      Tes = "";
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
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

  Future<List<GetEvent>>? getEvent = null;

  @override
  void initState() {
    super.initState();
    getEvent = GetEvent.connectToAPI();
    GetDataMe();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 0.2.toInt()));

    setState(() {
      getEvent = GetEvent.connectToAPI();
      GetDataMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 47, 131, 255),
      body: RefreshIndicator(
        onRefresh: () {
          return _handleRefresh();
        },
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                child: Material(
                  // elevation: 10,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 0, 76, 255),
                            Color.fromARGB(255, 12, 87, 255),
                            Color.fromARGB(255, 47, 131, 255),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Spacer(
                              flex: 1,
                            ),
                            InkWell(
                              onTap: () {
                                MenujuProfil();
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  (dataMe != null)
                                                      ? Gambar
                                                      : ""),
                                              fit: BoxFit.cover),
                                          border: Border.all(
                                              color: Colors.white, width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.185,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.185,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Hello,",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: const Color.fromARGB(
                                                      255, 245, 245, 245),
                                                  fontFamily: "Poppins",
                                                  fontSize: 15),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              (dataMe != null) ? Name : "Nama",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontFamily: "Poppins",
                                                  fontSize: 17),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              (dataMe != null)
                                                  ? Kelas
                                                  : "Kelas",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 7,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.question,
                                          animType: AnimType.topSlide,
                                          title: "Logout ?",
                                          desc:
                                              "Apakah anda yakin akan Logout ?",
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            logout();
                                            // Hapus();
                                          },
                                          btnOkColor: Colors.blue,
                                          btnCancelColor:
                                              Color.fromARGB(255, 236, 218, 50))
                                      .show();
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Color.fromARGB(255, 246, 249, 255)),
                  child: AmbilEvent()),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<GetEvent>> AmbilEvent() {
    return FutureBuilder<List<GetEvent>>(
      future:
          getEvent, // Anda sebaiknya menggunakan variabel tanpa tanda "?" jika tidak null
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return EmptyEventAnimation(
              Tulisan: "Failed to fetch events: ${snapshot.error}'",
              icon: FontAwesomeIcons.exclamation);
        } else if (snapshot.hasData) {
          final List<GetEvent> eventList = snapshot.data!;

          // Langkah 2: Urutkan berdasarkan status
          eventList.sort((a, b) => a.status.compareTo(b.status));

          final activeEvents =
              eventList.where((event) => event.status == 'Active').toList();
          final inactiveEvents =
              eventList.where((event) => event.status == 'Inactive').toList();
          final doneEvents =
              eventList.where((event) => event.status == 'Selesai').toList();

          return ListView.builder(
            itemCount:
                activeEvents.length + inactiveEvents.length + doneEvents.length,
            itemBuilder: (context, index) {
              if (index < activeEvents.length) {
                return BuildEvent(
                  activeEvents[index],
                );
              } else if (index < activeEvents.length + inactiveEvents.length) {
                return BuildEvent(
                  inactiveEvents[index - activeEvents.length],
                );
              } else {
                return BuildEvent(
                  doneEvents[
                      index - activeEvents.length - inactiveEvents.length],
                );
              }
            },
          );
        } else {
          return EmptyEventAnimation(
              Tulisan: "Event Tidak Tersedia",
              icon: FontAwesomeIcons.faceSadTear);
        }
      },
    );
  }

  ListView EmptyEventAnimation(
      {required String Tulisan, required IconData icon}) {
    return ListView(children: [
      Center(
          child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon, // Ganti dengan ikon Font Awesome yang ingin Anda animasikan.
              size: 50.0,
              color: Colors.grey,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                Tulisan,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      )),
    ]);
  }

  InkWell BuildEvent(GetEvent getEvent) {
    bool isKandidat = false;
    if (getEvent != null && widget.ID != 0) {
      isKandidat = getEvent.Kadidat.any((element) => element.user.id == IdUser);
    }

    final event = Event(
      Title: getEvent.name,
      Duration: "${getEvent.start_date} - ${getEvent.end_date}",
      Status: getEvent.status,
      Participant: getEvent.totalPartisipan.toString(),
      warnaStatus: (getEvent.status == "Active")
          ? Colors.green
          : (getEvent.status == "Inactive")
              ? Colors.grey
              : Colors.red,
      Kadidat: getEvent.Kadidat,
    );

    return InkWell(
      onTap: () {
        _navigateToDetailEventPage(getEvent);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 20),
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 3.5,
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue, width: 1)),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: (isKandidat)
                              ? InkWell(
                                  onTap: () {
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.topSlide,
                                      dialogType: DialogType.info,
                                      desc:
                                          "Anda merupakan salah satu kandidat pada Event ini.",
                                      btnOkOnPress: () {},
                                    ).show();
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.06,
                                    height: MediaQuery.of(context).size.width *
                                        0.06,
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors
                                                  .blue, // Kandidat yang dipilih
                                              Color.fromARGB(255, 12, 87, 255),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight)),
                                    child: Icon(
                                      Icons.stars,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ))
                              : Container(),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: Text(
                              (getEvent.status == "Active")
                                  ? getEvent.status
                                  : (getEvent.status == "Inactive")
                                      ? getEvent.status
                                      : "End",
                              style: TextStyle(
                                  color: (getEvent.status == "Active")
                                      ? Colors.green
                                      : (getEvent.status == "Inactive")
                                          ? Colors.grey
                                          : Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 0.86,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          getEvent.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: const Color.fromARGB(255, 5, 44, 77)),
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15, left: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                children: [
                                  Container(
                                    child: Icon(
                                      Icons.person_pin_rounded,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.035,
                                      margin: EdgeInsets.only(left: 5),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          getEvent.PartisipanData.length
                                                  .toString() +
                                              " / " +
                                              getEvent.totalPartisipan
                                                  .toString() +
                                              " Participant",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.start,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 5, 10, 0),
                                  child: Text(
                                    getEvent.start_date.toString() +
                                        " - " +
                                        getEvent.end_date.toString(),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.right,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetailEventPage(GetEvent getEvent) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailEventPage(
                Title: getEvent.name,
                Duration: "${getEvent.start_date} - ${getEvent.end_date}",
                Status: (getEvent.status == "Active")
                    ? getEvent.status
                    : (getEvent.status == "Inactive")
                        ? getEvent.status
                        : "End",
                Participant: getEvent.totalPartisipan
                    .toString(), // Convert int to String
                warnaStatus: (getEvent.status == "Active")
                    ? Colors.green
                    : (getEvent.status == "Inactive")
                        ? Colors.grey
                        : Colors.red,
                KadidatDetail: getEvent.Kadidat,
                User_id: (dataMe != null)
                    ? int.parse(dataMe!.id.toString())
                    : int.parse(widget.ID.toString()),
                Event_id: getEvent.id, GetToken: widget.GetToken,
                Description: getEvent.description,
                ParticipantData: getEvent.PartisipanData.length,
              )),
    );
    _handleRefresh();
  }

  void MenujuProfil() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilPage(
                  GambarProfil:
                      (dataMe != null) ? dataMe?.gambar : widget.GambarProfil,
                  GetToken: widget.GetToken,
                )));
    _handleRefresh();
  }
}
