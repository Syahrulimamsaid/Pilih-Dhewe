import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class LinkAPI {
  String ApiURL = "https://pilihdhewe.my.id/api";
}

class CekPassword {
  static Future<bool> cekPassword(
    String Token,
    String PasswordLama,
  ) async {
    final apiURL = LinkAPI().ApiURL + "/check-password";
    final headers = {
      'Authorization': 'Bearer $Token',
      'Content-Type': 'application/json',
    };
    var data = {"password": PasswordLama};

    final apiResult = await http.post(Uri.parse(apiURL),
        headers: headers, body: json.encode(data));

    if (apiResult.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

class UbahPassword {
  static Future<UbahPassword> ubahPassword(
      String Token, String PasswordBaru, String ConfirmPassword) async {
    final apiURL = LinkAPI().ApiURL + "/change-password";

    final headers = {
      'Authorization': 'Bearer $Token',
      'Content-Type': 'application/json',
    };

    var data = {
      'new_password': PasswordBaru,
      'new_password_confirmation': ConfirmPassword
    };

    final apiResult = await http.put(Uri.parse(apiURL),
        headers: headers, body: json.encode(data));

    if (apiResult.statusCode == 200) {
      var jsonResponse = json.decode(apiResult.body);
      var message = jsonResponse['message'];
      return UbahPassword();
    } else {
      var jsonResponse = json.decode(apiResult.body);
      var errorMessage = jsonResponse["message"];
      throw Exception('Gagal logout. $errorMessage');
    }
  }
}
