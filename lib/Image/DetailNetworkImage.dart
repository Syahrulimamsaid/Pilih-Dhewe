import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailNetworkImagePage extends StatefulWidget {
  final String Gambar;
  const DetailNetworkImagePage({required this.Gambar});

  @override
  State<DetailNetworkImagePage> createState() => _DetailNetworkImagePageState();
}

class _DetailNetworkImagePageState extends State<DetailNetworkImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(132, 0, 0, 0),
      body: SafeArea(
          child: Stack(children: [
        Align(
          alignment: Alignment.center,
          child: Container(padding: EdgeInsets.all(35),
            child: Image(
              image: NetworkImage(widget.Gambar),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 15),
                child: Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 27,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              )),
        ),
      ])),
    );
  }
}
