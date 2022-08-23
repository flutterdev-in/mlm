import 'package:advaithaunnathi/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DefaultsModel {
  DocumentReference<Map<String, dynamic>>? addressDR;
  DefaultsModel({
    required this.addressDR,
  });

  factory DefaultsModel.fromMap(Map<String, dynamic> defaultsMap) {
    return DefaultsModel(
      addressDR: defaultsMap[defaultsMOs.address],
    );
  }
}

DefaultsModelObjects defaultsMOs = DefaultsModelObjects();

class DefaultsModelObjects {
  final address = "address";

  //
  DocumentReference<Map<String, dynamic>> defaultDR() {
    return authUserCR.doc(fireUser()!.uid).collection("docs").doc('defaults');
  }
}
