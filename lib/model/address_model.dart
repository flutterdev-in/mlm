import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:advaithaunnathi/model/pin_code_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  String name;
  String house;
  String colony;
  String? landmark;
  int pinCode;
  PinCodeModel pinCodeModel;
  DateTime updatedTime;

  AddressModel({
    required this.name,
    required this.house,
    required this.colony,
    required this.landmark,
    required this.pinCode,
    required this.pinCodeModel,
    required this.updatedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      addressMOs.name: name,
      addressMOs.house: house,
      addressMOs.colony: colony,
      addressMOs.landmark: landmark,
      addressMOs.pinCode: pinCode,
      addressMOs.updatedTime: Timestamp.fromDate(updatedTime),
      addressMOs.pinCodeModel: pinCodeModel.toMap(),
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> addressMap) {
    return AddressModel(
      name: addressMap[addressMOs.name] ?? "",
      house: addressMap[addressMOs.house] ?? "",
      colony: addressMap[addressMOs.colony] ?? "",
      landmark: addressMap[addressMOs.landmark] ?? "",
      pinCode: addressMap[addressMOs.pinCode] ?? 999999,
      updatedTime:
          addressMap[addressMOs.updatedTime]?.toDate() ?? DateTime.now(),
      pinCodeModel: PinCodeModel.fromMap(addressMap[addressMOs.pinCodeModel]),
    );
  }
}

//
AddressModelObjects addressMOs = AddressModelObjects();

class AddressModelObjects {
  final name = "name";

  final house = "house";
  final colony = "street";

  final landmark = "landmark";

  final pinCode = "pinCode";

  final pinCodeModel = "pinCodeModel";
  final updatedTime = "updatedTime";

  final addressCR = authUserCR.doc(fireUser()?.uid).collection("address");

  Future<AddressModel> dummyAddressModel() async {
    var pinM = await getPinModel(521126);

    return AddressModel(
      name: "MV Phaneendra",
      house: "7-27/1, last house",
      colony: "Sri nagar",
      landmark: "Opst to govt school",
      pinCode: 521126,
      updatedTime: DateTime.now(),
      pinCodeModel: pinM ??
          PinCodeModel(
              isValid: false,
              listAreas: null,
              city: null,
              district: null,
              state: null),
    );
  }
}
