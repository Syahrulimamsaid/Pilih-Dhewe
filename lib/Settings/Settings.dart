import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final String? Theme;
  const SettingsPage({super.key, this.Theme});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String Tema = "Terang";

  void HasilTheme() async {
    final resultTema = await Navigator.of(context)
        .push(TemaPage(SelectTheme: widget.Theme.toString()) as Route<Object?>);

    if (resultTema != null) {
      setState(() {
        Tema = resultTema.toString(); // Update the name in the state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color.fromARGB(255, 47, 131, 255),
          body: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.125,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 0, 76, 255),
                    Color.fromARGB(255, 12, 87, 255),
                    Color.fromARGB(255, 47, 131, 255),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
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
                            size: 27,
                            color: Color.fromARGB(255, 233, 234, 235),
                          ),
                        ))),
              ),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.875,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 246, 249, 255),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Settings",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 0, 57, 104),
                              fontFamily: "Poppins",
                              fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.72,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => TemaPage()),
                              // );
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TemaPage(
                                        SelectTheme: widget.Theme.toString());
                                  });
                            },
                            child: Build_Menu_Settings(
                                Icons.brightness_4_outlined, "Tema", Tema),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Container Build_Menu_Settings(
      IconData iconData, String TitleText, String SelectText) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Material(
        elevation: 1,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 15),
                child: Icon(
                  iconData,
                  size: 27,
                  color: Color.fromARGB(255, 22, 92, 255),
                ),
              ),
              Column(
                children: [
                  Text(
                    TitleText,
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    SelectText,
                    style: TextStyle(
                        fontSize: 13,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TemaPage extends StatefulWidget {
  final String SelectTheme;
  const TemaPage({super.key, required this.SelectTheme});

  @override
  State<TemaPage> createState() => _TemaPageState();
}

class _TemaPageState extends State<TemaPage> {
  String Pilihan = "";
  void PilihTema(String value) {
    setState(() {
      Pilihan = value;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.SelectTheme == "Terang") {
      setState(() {
        Pilihan = "Terang";
      });
    } else {
      setState(() {
        Pilihan = "Gelap";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(25),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35,
          child: Material(
            borderRadius: BorderRadius.circular(30),
            color: const Color.fromARGB(255, 58, 58, 58),
            elevation: 5,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 246, 249, 255),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Center(
                        child: Text(
                          "Pilih Tema",
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 57, 104),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                        child: Column(
                      children: [
                        Container(
                            child: RadioListTile(
                          title: Text("Terang"),
                          value: "Terang",
                          onChanged: (value) {
                            setState(() async {
                              Pilihan = value!;
                              final SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                                       await sharedPreferences.remove('Theme');
                              sharedPreferences.setString('Theme', value!);
                            });
                          },
                          groupValue: Pilihan,
                        )),
                        Container(
                            child: RadioListTile(
                          title: Text("Gelap"),
                          value: "Gelap",
                          onChanged: (value) {
                            setState(() async {
                              Pilihan = value!;
                              final SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                                  await sharedPreferences.remove('Theme');
                              sharedPreferences.setString('Theme', value!);
                            });
                          },
                          groupValue: Pilihan,
                        ))
                      ],
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 30),
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
                            onTap: () {},
                            child: Container(
                              child: Text(
                                "Oke",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 31, 104),
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
