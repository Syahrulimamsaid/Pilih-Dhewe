

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LinkAPI {
  String ApiURL = "https://pilihdhewe.my.id/api";
}

class GetEvent extends LinkAPI {
  int id;
  String name;
  String start_date;
  String end_date;
  String status;
  String description;
  int totalPartisipan;
  List<Partisipan> PartisipanData;
  List<Candidates> Kadidat;

  GetEvent(
      {required this.id,
      required this.name,
      required this.start_date,
      required this.end_date,
      required this.status,
      required this.totalPartisipan,
      required this.description,
      required this.PartisipanData,
      required this.Kadidat});

  factory GetEvent.createGetEvent(Map<String, dynamic> object) {
    var eventCadidates = object["candidates"] as List<dynamic>;

    List<Candidates> candidates = eventCadidates.map((candidatesData) {
      return Candidates.GetCadidates(candidatesData as Map<String, dynamic>);
    }).toList();

    var eventPartisipan = object["partisipan"] as List<dynamic>;
    List<Partisipan> partisipan = eventPartisipan.map((partisipanData) {
      return Partisipan.GetPartisipan(partisipanData as Map<String, dynamic>);
    }).toList();

    return GetEvent(
        id: int.parse(object["id"].toString()),
        name: object["name"],
        start_date: object["start_date"],
        end_date: object["end_date"],
        status: object["status"],
        description: object["description"],
        PartisipanData: partisipan,
        totalPartisipan: int.parse(object["total_partisipan"].toString()),
        Kadidat: candidates);
  }

  static Future<List<GetEvent>> connectToAPI() async {
    String apiURL = LinkAPI().ApiURL + "/events";
    var apiResult = await http.get(Uri.parse(apiURL));
    var jsonObject = json.decode(apiResult.body);
    var eventDataList =
        (jsonObject as Map<String, dynamic>)["data"] as List<dynamic>;

    List<GetEvent> events = eventDataList.map((eventData) {
      return GetEvent.createGetEvent(eventData as Map<String, dynamic>);
    }).toList();
    return events;
  }
}

class Candidates {
  final int id;
  final int event_id;
  final String visi;
  final String video;
  final String misi;
  final int total_vote;
  User user;

  Candidates(
      {required this.id,
      required this.event_id,
      required this.total_vote,
      required this.visi,
      required this.misi,
      required this.video,
      required this.user});

  factory Candidates.GetCadidates(Map<String, dynamic> object) {
    return Candidates(
        id: int.parse(object["id"].toString()),
        event_id: int.parse(object["event_id"].toString()),
        total_vote: int.parse(object["total_vote"].toString()),
        user: User.GetUser(object["user"]),
        visi: object["visi"],
        video: object["video"],
        misi: object["misi"]);
  }
}

class User {
  final int id;
  final String number_card;
  final String name;
  final String gender;
  final String role;
  Kelas kelas;
  final String gambar;

  User(
      {required this.id,
      required this.number_card,
      required this.name,
      required this.gender,
      required this.role,
      required this.gambar,
      required this.kelas});

  factory User.GetUser(Map<String, dynamic> object) {
    return User(
        id: int.parse(object["id"].toString()),
        number_card: object["number_card"],
        name: object["name"],
        gender: object["gender"],
        role: object["role"],
        gambar: object["gambar"],
        kelas: Kelas.GetKelas(object["kelas"]));
  }
}

class Partisipan {
  final int id;
  final String number_card;
  final String name;
  final String gender;
  final String role;
  Kelas kelas;

  Partisipan(
      {required this.id,
      required this.number_card,
      required this.name,
      required this.gender,
      required this.role,
      required this.kelas});

  factory Partisipan.GetPartisipan(Map<String, dynamic> object) {
    return Partisipan(
        id: int.parse(object["id"].toString()),
        number_card: object["number_card"],
        name: object["name"],
        gender: object["gender"],
        role: object["role"],
        kelas: Kelas.GetKelas(object["kelas"]));
  }
}

class Kelas {
  final int id;
  final String namakelas;

  Kelas({required this.id, required this.namakelas});

  factory Kelas.GetKelas(Map<String, dynamic> object) {
    return Kelas(
      id: int.parse(object["id"].toString()),
      namakelas: object["name"],
    );
  }
}


class Vote {
  static Future<Vote> voteInsert(
      int eventId, int candidateId, String token) async {
    String apiURL = LinkAPI().ApiURL + "/votes";

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    var data = {
      "event_id": eventId.toString(),
      "candidate_id": candidateId.toString(),
    };

    var apiResult = await http.post(Uri.parse(apiURL),
        body: json.encode(data), headers: headers);

    if (apiResult.statusCode == 200) {
      var jsonObject = json.decode(apiResult.body);
      return jsonObject['messege'];
    } else {
      throw Exception('Gagal. Kode status: ${apiResult.statusCode}');
    }
  }
}

class IsVoted {
  final int id;
  final int total_vote;
  final String event_id;
  final String visi;
  final String misi;
  UserVote userVote;
  final String video;

  IsVoted(
      {required this.event_id,
      required this.id,
      required this.total_vote,
      required this.visi,
      required this.misi,
      required this.video,
      required this.userVote});

  factory IsVoted.fromJson(Map<String, dynamic> object) {
    return IsVoted(
        id: int.parse(object["id"].toString()),
        event_id: object["event_id"].toString(),
        total_vote: int.parse(object["total_vote"].toString()),
        visi: object["visi"],
        misi: object["misi"],
        video: object["video"],
        userVote: UserVote.GetUserVote(object["user"]));
  }

  static Future<IsVoted?> cekVoted(int eventId, String token) async {
    final apiURL = LinkAPI().ApiURL + "/isMyVoted/" + eventId.toString();

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final apiResult = await http.get(Uri.parse(apiURL), headers: headers);

    if (apiResult.statusCode == 200) {
      final jsonObject = json.decode(apiResult.body);
      final data = jsonObject["data"];

      if (data != null) {
        return IsVoted.fromJson(data);
      } else {
        return null;
      }
    } else {
      throw Exception("Gagal :${apiResult.statusCode}");
    }
  }
}

class UserVote {
  final int id;
  final String name;
  final String gender;
  final String role;
  final int kelas_id;
  final String gambar;
  Kelas kelas;

  UserVote(
      {required this.id,
      required this.name,
      required this.gender,
      required this.role,
      required this.gambar,
      required this.kelas_id,
      required this.kelas});

  factory UserVote.GetUserVote(Map<String, dynamic> object) {
    return UserVote(
        id: int.parse(object["id"].toString()),
        name: object["name"],
        gender: object["gender"],
        role: object["role"],
        gambar: object["gambar"],
        kelas_id: int.parse(object["kelas_id"].toString()),
        kelas: Kelas.GetKelas(object["kelas"]));
  }
}
