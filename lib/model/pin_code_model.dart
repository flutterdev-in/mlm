import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PinCodeModel {
  bool isValid; // Success
  List<String>? listAreas; //Name
  String? city; // Block
  String? district; // District
  String? state; // State

  PinCodeModel({
    required this.isValid,
    required this.listAreas,
    required this.city,
    required this.district,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      "isValid": isValid,
      "listAreas": listAreas,
      "city": city,
      "district": district,
      "state": state,
    };
  }

  factory PinCodeModel.fromMap(Map<String, dynamic> pinMap) {
    return PinCodeModel(
        isValid: pinMap["isValid"] ?? false,
        listAreas: pinMap["listAreas"],
        city: pinMap["city"],
        district: pinMap["district"],
        state: pinMap["state"]);
  }

  factory PinCodeModel.fromJson(Map<String, dynamic> pinMap) {
    var pcm = PinCodeModel(
        isValid: false,
        listAreas: null,
        city: null,
        district: null,
        state: null);
    String status = pinMap["Status"];
    if (status == "Success") {
      pcm.isValid = true;
      List offices = pinMap["PostOffice"];
      List<String> listAreas =
          offices.map((e) => e["Name"].toString()).toList();
      pcm.listAreas = listAreas;
      pcm.city = offices.first["Block"];
      pcm.district = offices.first["District"];
      pcm.state = offices.first["State"];
    }

    return pcm;
  }
}

Future<PinCodeModel?> getPinModel(int pinCode) async {
  if (pinCode.toString().length == 6) {
    var url = Uri.parse("https://api.postalpincode.in/pincode/$pinCode");
    Response response = await http.get(url);
    // print(response.body);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      Map<String, dynamic> map = data.first;

      return PinCodeModel.fromJson(map);
    }
  }
  return null;
}
