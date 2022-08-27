import 'package:advaithaunnathi/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

import '../dart/const_global_objects.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../dart/rx_variables.dart';
import 'prime_member_model.dart';

class KycModel {
  String? aadhaarUrl;
  String? panCardUrl;
  String? checkOrPassbookUrl;
  String? accountNumber;
  String? ifsc;
  String? bankName;

  String aadhaarStatus;
  String panCardStatus;
  String checkOrPassbookStatus;
  String accountNumberStatus;
  String ifscStatus;

  bool isKycVerified;
  DocumentReference<Map<String, dynamic>>? docRef;

  KycModel({
    required this.aadhaarUrl,
    required this.panCardUrl,
    required this.checkOrPassbookUrl,
    required this.accountNumber,
    required this.ifsc,
    required this.bankName,
    this.ifscStatus = "",
    this.aadhaarStatus = "",
    this.panCardStatus = "",
    this.checkOrPassbookStatus = "",
    this.accountNumberStatus = "",
    this.isKycVerified = false,
    this.docRef,
  });

  Map<String, dynamic> toMap() {
    return {
      kycMOs.aadhaarUrl: aadhaarUrl,
      kycMOs.panCardUrl: panCardUrl,
      kycMOs.checkOrPassbookUrl: checkOrPassbookUrl,
      kycMOs.accountNumber: accountNumber,
      kycMOs.ifsc: ifsc,
      kycMOs.ifscStatus: ifscStatus,
      kycMOs.aadhaarStatus: aadhaarStatus,
      kycMOs.panCardStatus: panCardStatus,
      kycMOs.checkOrPassbookStatus: checkOrPassbookStatus,
      kycMOs.accountNumberStatus: accountNumberStatus,
    };
  }

  factory KycModel.fromMap(Map<String, dynamic> kycMap) {
    var km = KycModel(
      aadhaarUrl: kycMap[kycMOs.aadhaarUrl],
      panCardUrl: kycMap[kycMOs.panCardUrl],
      checkOrPassbookUrl: kycMap[kycMOs.checkOrPassbookUrl],
      accountNumber: kycMap[kycMOs.accountNumber],
      ifsc: kycMap[kycMOs.ifsc],
      ifscStatus: kycMap[kycMOs.ifscStatus] ?? "",
      bankName: kycMap[kycMOs.bankName],
      aadhaarStatus: kycMap[kycMOs.aadhaarStatus] ?? "",
      panCardStatus: kycMap[kycMOs.panCardStatus] ?? "",
      checkOrPassbookStatus: kycMap[kycMOs.checkOrPassbookStatus] ?? "",
      accountNumberStatus: kycMap[kycMOs.accountNumberStatus] ?? "",
      isKycVerified: kycMap[kycMOs.isKycVerified] ?? false,
    );
    km.isKycVerified = kycMOs.isKycVrf(km);
    return km;
  }
}

KycModelObjects kycMOs = KycModelObjects();

class KycModelObjects {
  final aadhaarUrl = "aadhaarUrl";
  final panCardUrl = "panCardUrl";
  final accountNumber = "accountNumber";
  final accountNumberStatus = "accountNumberStatus";
  final ifsc = "ifsc";
  final ifscStatus = "ifscStatus";
  final checkOrPassbookUrl = "checkOrPassbookUrl";
  final bankName = "bankName";
  final aadhaarStatus = "aadhaarStatus";
  final panCardStatus = "panCardStatus";
  final checkOrPassbookStatus = "checkOrPassbookStatus";
  final isKycVerified = "isKycVerified";
  final kyc = "kyc";

  //
  final verified = "verified";
  final invalid = "invalid";
  final uploaded = "uploaded";
  DocumentReference<Map<String, dynamic>> kycDR(PrimeMemberModel pmm) {
    return pmm.docRef!.collection("docs").doc(kyc);
  }

  bool isKycVrf(KycModel km) {
    bool isAllUploaded = (km.aadhaarUrl != null &&
        km.panCardUrl != null &&
        km.checkOrPassbookUrl != null &&
        km.accountNumber != null &&
        km.ifsc != null &&
        km.bankName != null);
    bool isAllVerified = (km.aadhaarStatus == kycMOs.verified &&
        km.panCardStatus == kycMOs.verified &&
        km.checkOrPassbookStatus == kycMOs.verified &&
        km.accountNumberStatus == kycMOs.verified);

    return isAllUploaded && isAllVerified;
  }

  String? getCorresBoolName(String name) {
    if (name == aadhaarUrl) {
      return aadhaarStatus;
    } else if (name == panCardUrl) {
      return panCardStatus;
    } else if (name == checkOrPassbookUrl) {
      return checkOrPassbookStatus;
    }
    return null;
  }

  //
  Future<void> pickPhoto(
      {required ImageSource source,
      required String photoName,
      required PrimeMemberModel pmm}) async {
    await imagePicker.pickImage(source: source).then((photo) async {
      if (photo != null && fireUser() != null) {
        isLoading.value = true;
        // isLoading.value = true;
        await FlutterNativeImage.compressImage(
          photo.path,
        ).then((compressedFile) async {
          final storageRef = FirebaseStorage.instance.ref();

          final primeUserSR = storageRef
              .child(primeMOs.primeMembers)
              .child(pmm.userName!)
              .child("$photoName.jpg");
          await primeUserSR.putFile(compressedFile).then((ts) async {
            await ts.ref.getDownloadURL().then((url) async {
              await kycDR(pmm).set({
                photoName: url,
                getCorresBoolName(photoName) ?? "error": uploaded,
              }, SetOptions(merge: true));
            });
          });
        });
      }
      isLoading.value = false;
    });
  }

  Future<Map<String, dynamic>?> getIFSCmap(String ifsc) async {
    if (ifsc.contains(RegExp(r'^[A-Z]{4}0[0-9]{6}$'))) {
      var url = Uri.parse("https://ifsc.razorpay.com/$ifsc");
      Response response = await http.get(url);
      // print(response.body);
      if (response.statusCode == 200 && response.body != "Not Found") {
        Map<String, dynamic> dataMap = jsonDecode(response.body);
        return dataMap;
      }
    }
    return null;
  }

  Future<String?> getIFSCdetails(String ifsc) async {
    var dataMap = await getIFSCmap(ifsc);
    if (dataMap != null) {
      return "Bank : ${dataMap['BANK']}\nBranch : ${dataMap['BRANCH']}\nAddress : ${dataMap['ADDRESS']}";
    }
    return null;
  }

  Future<String?> getIFSCbank(String ifsc) async {
    var dataMap = await getIFSCmap(ifsc);
    if (dataMap != null) {
      return dataMap['BANK'].toString();
    }
    return null;
  }
}
