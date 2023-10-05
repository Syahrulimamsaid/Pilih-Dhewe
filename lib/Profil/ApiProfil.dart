import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http_parser/http_parser.dart';

class LinkAPI {
  String ApiURL = "https://pilihdhewe.my.id/api";
}

class DataMe {
  int id;
  String number_card;
  String name;
  String gender;
  String role;
  Kelas kelas;
  String gambar;
  List<CandidateOf> candidateOf;

  DataMe(
      {required this.id,
      required this.number_card,
      required this.name,
      required this.gender,
      required this.role,
      required this.gambar,
      required this.candidateOf,
      required this.kelas});

  static Future<DataMe> GetMe(String Token) async {
    String apiURL = LinkAPI().ApiURL + "/me";

    final headers = {
      'Authorization': 'Bearer $Token',
      'Content-Type': 'application/json',
    };
    var apiResult = await http.get(Uri.parse(apiURL), headers: headers);

    if (apiResult.statusCode == 200) {
      var jsonResponse = json.decode(apiResult.body);
      var userData = jsonResponse["data"];

      var candidateOf = userData["candidate_of"] as List<dynamic>;
      List<CandidateOf> candidatedata = candidateOf.map((candidateOfData) {
        return CandidateOf.GetCandidateOf(
            candidateOfData as Map<String, dynamic>);
      }).toList();

      return DataMe(
          id: int.parse(userData["id"].toString()),
          number_card: userData["number_card"],
          name: userData["name"],
          gender: userData["gender"],
          role: userData["role"],
          gambar: userData["gambar"],
          candidateOf: candidatedata,
          kelas: Kelas.GetKelas(userData["kelas"]));
    } else {
      var jsonResponse = json.decode(apiResult.body);
      var errorMessage = jsonResponse["message"];
      throw Exception(errorMessage);
    }
  }
}

class ListKelas {
  int IdKelas;
  String NameKelas;

  ListKelas({required this.IdKelas, required this.NameKelas});

  factory ListKelas.resulttKelas(Map<String, dynamic> object) {
    return ListKelas(IdKelas: object["id"], NameKelas: object["name"]);
  }

  static Future<List<ListKelas>> getKelas(String Token) async {
    String apiUrl = "https://pilihdhewe.my.id/api/kelas";

    var headers = {
      'Authorization': 'Bearer $Token',
      'Content-Type': 'application/json',
    };

    final apiResult = await http.get(Uri.parse(apiUrl), headers: headers);

    if (apiResult.statusCode == 200) {
      var jsonObject = json.decode(apiResult.body);
      var kelasDataList =
          (jsonObject as List<dynamic>).cast<Map<String, dynamic>>();

      List<ListKelas> kelas = kelasDataList.map((kelasdata) {
        return ListKelas.resulttKelas(kelasdata);
      }).toList();
      return kelas;
    } else {
      throw Exception("Error");
    }
  }
}

class UbahDataUser {
  static Future<bool> ubahDataUser(String Token, String Name,
      String JenisKelamin, int IdKelas, int IdUser) async {
    String apiUrl = LinkAPI().ApiURL + "/siswa/" + IdUser.toString();

    var headers = {
      'Authorization': 'Bearer $Token',
      'Content-Type': 'application/json',
    };
    var bodyData = {'name': Name, 'gender': JenisKelamin, 'kelas_id': IdKelas};

    final apiResult = await http.put(Uri.parse(apiUrl),
        headers: headers, body: json.encode(bodyData));

    if (apiResult.statusCode == 200) {
      return true;
    } else {
      var jsonResponse = json.decode(apiResult.body);
      var errorMessage = jsonResponse["message"];
      throw Exception(errorMessage);
    }
  }
}

class UbahGambar {
  static Future<void> ubahGambar(String token, File gambar) async {
    String apiUrl = LinkAPI().ApiURL + "/img-update";

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Bearer $token';

    var fileStream = http.ByteStream(Stream.castFrom(gambar.openRead()));
    var length = await gambar.length();

    var multipartFile = http.MultipartFile(
      'gambar',
      fileStream,
      length,
      filename: 'gambar.jpg', // Nama berkas yang sesuai
      contentType: MediaType('image', 'jpeg'), // Tipe konten gambar
    );

    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      // Berhasil mengirim gambar
      print('Image uploaded successfully');
    } else {
      // Gagal mengirim gambar
      print('Image upload failed');
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
