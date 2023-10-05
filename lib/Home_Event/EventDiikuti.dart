import 'package:Pilih_Dhewe/Home_Event/ApiHome_Event.dart';
import 'package:Pilih_Dhewe/Home_Event/DetailEvent.dart';
import 'package:Pilih_Dhewe/Home_Event/Home.dart';
import 'package:Pilih_Dhewe/Profil/ApiProfil.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventDiikutiPage extends StatefulWidget {
  final String GetToken;
  const EventDiikutiPage({required this.GetToken});

  @override
  State<EventDiikutiPage> createState() => _EventDiikutiPageState();
}

class _EventDiikutiPageState extends State<EventDiikutiPage> {
  Future<List<GetEvent>>? getEvent = null;
  DataMe? dataMe;
  int IdUser = 0;
  int UserParticipant = 0;

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 0.2.toInt()));

    setState(() {
      getEvent = GetEvent.connectToAPI();
      GetDataMe();
    });
  }

  void GetDataMe() async {
    try {
      dataMe = await DataMe.GetMe(widget.GetToken);

      if (dataMe != null) {
        setState(() {
          IdUser = dataMe!.id;
          UserParticipant = dataMe!.candidateOf.length;
        });
      }
    } catch (e) {}
  }


  @override
  void initState() {
    super.initState();
    getEvent = GetEvent.connectToAPI();
    GetDataMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 47, 131, 255),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 0.17,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 0, 76, 255),
                    Color.fromARGB(255, 12, 87, 255),
                    Color.fromARGB(255, 47, 131, 255),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
                child: Center(
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
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            child: Text(
                          "Detail Diikuti",
                          style: TextStyle(
                              fontSize: 19,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 5,
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 246, 249, 255),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.83,
                    child: (UserParticipant == 0)
                        ? Center(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Anda belum mengikuti Event apapun.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins",
                                  fontSize: 17,
                                  color: Color.fromARGB(255, 0, 57, 104),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : AmbilEvent(),
                  ),
                ),
              )
            ],
          ),
        ));
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

  Widget BuildEvent(GetEvent getEvent) {
    bool isKandidat = false;
    if (getEvent != null) {
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
    if (isKandidat) {
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
    } else {
      return Container();
    }
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
                    : int.parse(dataMe!.id.toString()),
                Event_id: getEvent.id, GetToken: widget.GetToken,
                Description: getEvent.description,
                ParticipantData: getEvent.PartisipanData.length,
              )),
    );
    _handleRefresh();
  }
}
