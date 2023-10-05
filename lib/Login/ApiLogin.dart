
import 'package:http/http.dart' as http;
import 'dart:convert';


class LinkAPI {
  String ApiURL = "https://pilihdhewe.my.id/api";
}

class PostUser extends LinkAPI {
  int id;
  String number_card;
  String name;
  String gender;
  String role;
  String SetToken;
  Kelas kelas;
  String gambar;

  PostUser(
      {required this.id,
      required this.number_card,
      required this.name,
      required this.gender,
      required this.role,
      required this.SetToken,
      required this.gambar,
      required this.kelas});

  static Future<PostUser> connectToAPI(
      String numberCard, String password) async {
    String apiURL = LinkAPI().ApiURL + "/auth/login";
    var apiResult = await http.post(Uri.parse(apiURL), body: {
      "number_card": numberCard,
      "password": password,
    });

    if (apiResult.statusCode == 200) {
      var jsonResponse = json.decode(apiResult.body);
      var userData = jsonResponse["user"];
      var token = jsonResponse["token"];

      var candidateOf = userData["candidate_of"] as List<dynamic>;
      List<CandidateOf> candidatedata = candidateOf.map((candidateOfData) {
        return CandidateOf.GetCandidateOf(
            candidateOfData as Map<String, dynamic>);
      }).toList();

      return PostUser(
          id: int.parse(userData["id"].toString()),
          number_card: userData["number_card"],
          name: userData["name"],
          gender: userData["gender"],
          role: userData["role"],
          SetToken: token.toString(),
          gambar: userData["gambar"],
          kelas: Kelas.GetKelas(userData["kelas"]));
    } else {
      var jsonResponse = json.decode(apiResult.body);
      var errorMessage = jsonResponse["message"];
      throw Exception('$errorMessage');
    }
  }

  static Future<void> logout(String token) async {
    String apiURL = LinkAPI().ApiURL + "/auth/logout";

    var apiResult = await http.post(
      Uri.parse(apiURL),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (apiResult.statusCode == 200) {
    } else {
      var jsonResponse = json.decode(apiResult.body);
      var errorMessage = jsonResponse["message"];
      throw Exception('Gagal logout. $errorMessage');
    }
  }
}

class Kelas {
  final int id;
  final String namakelas;
  final String st;
  final String ed;

  Kelas(
      {required this.id,
      required this.namakelas,
      required this.ed,
      required this.st});

  factory Kelas.GetKelas(Map<String, dynamic> object) {
    return Kelas(
        id: int.parse(object["id"].toString()),
        namakelas: object["name"],
        st: object["created_at"],
        ed: object["updated_at"]);
  }
}

class CandidateOf {
  int id;
  String event_id;
  String user_id;
  String visi;
  String misi;
  int myTotalVote;
  EventUser eventUser;

  CandidateOf(
      {required this.id,
      required this.event_id,
      required this.myTotalVote,
      required this.user_id,
      required this.eventUser,
      required this.misi,
      required this.visi});

  factory CandidateOf.GetCandidateOf(Map<String, dynamic> object) {
    return CandidateOf(
        id: int.parse(object["id"].toString()),
        event_id: object["evend_id"].toString(),
        user_id: object["user_id"].toString(),
        visi: object["visi"].toString(),
        misi: object["misi"].toString(),
        eventUser: EventUser.GetEventuser(object["event"]),
        myTotalVote: int.parse(object["my_total_vote"].toString()));
  }
}

class EventUser {
  int id;
  String name;
  String description;
  String end_date;
  String start_date;
  String status;
  int totalPartisipan;

  EventUser(
      {required this.id,
      required this.description,
      required this.end_date,
      required this.name,
      required this.start_date,
      required this.status,
      required this.totalPartisipan});

  factory EventUser.GetEventuser(Map<String, dynamic> object) {
    return EventUser(
        id: int.parse(object["id"].toString()),
        description: object["description"],
        end_date: object["end_date"],
        name: object["name"],
        start_date: object["start_date"],
        status: object["status"],
        totalPartisipan: int.parse(object["total_partisipan"].toString()));
  }
}
