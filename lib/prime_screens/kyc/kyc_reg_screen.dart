import 'package:advaithaunnathi/custom%20widgets/stream_builder_widget.dart';
import 'package:advaithaunnathi/dart/rx_variables.dart';
import 'package:advaithaunnathi/dart/text_formatters.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../Prime models/kyc_model.dart';

class KycRegScreen extends StatelessWidget {
  const KycRegScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var km = KycModel(
        aadhaarUrl: null,
        panCardUrl: null,
        checkOrPassbookUrl: null,
        accountNumber: null,
        ifsc: null,
        docRef: kycMOs.kycDR(),
        bankName: null);

    Widget bodyW(KycModel km) {
      return Obx(() => Stack(
            children: [
              KycBody(km),
              if (isLoading.value) const Center(child: GFLoader()),
            ],
          ));
    }

    return StreamDocBuilder(
      docRef: kycMOs.kycDR()!,
      loadingW: Scaffold(
          appBar: AppBar(title: const Text("KYC")), body: const GFLoader()),
      noResultsW:
          Scaffold(appBar: AppBar(title: const Text("KYC")), body: bodyW(km)),
      docBuilder: (context, docSnap) {
        km = KycModel.fromMap(docSnap.data()!);
        km.docRef = docSnap.reference;
        return Scaffold(
            appBar: AppBar(
                title: Row(
              children: [
                const Text("KYC"),
                if (km.isKycVerified)
                  const Text(
                    " (Verified)",
                    textScaleFactor: 0.9,
                  )
              ],
            )),
            body: bodyW(km));
      },
    );
  }
}

class KycBody extends StatelessWidget {
  final KycModel km;
  const KycBody(this.km, {Key? key}) : super(key: key);
  final underVerification = "\u23F3 Under verification";

  @override
  Widget build(BuildContext context) {
    var accountTc = TextEditingController(text: km.accountNumber ?? "");
    var ifscTc = TextEditingController(text: km.ifsc ?? "");
    var ifscDetails = "".obs;
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                readOnly: km.accountNumberStatus == kycMOs.verified,
                controller: accountTc,
                keyboardType: TextInputType.number,
                maxLength: 15,
                decoration: const InputDecoration(
                  labelText: "Bank Account Number",
                  counterText: "",
                ),
                onChanged: (value) {
                  if (value.contains(RegExp(r'^[0-9]{6,15}'))) {
                    EasyDebounce.debounce(
                        'd', const Duration(milliseconds: 1400), () async {
                      await km.docRef?.set({
                        kycMOs.accountNumber: value,
                        kycMOs.accountNumberStatus: kycMOs.uploaded,
                      }, SetOptions(merge: true));
                    });
                  }
                },
              ),
              if (km.accountNumberStatus == kycMOs.verified)
                const Text(
                  "\u2705 Verified",
                  style: TextStyle(color: Colors.green),
                ),
              if (km.accountNumberStatus == kycMOs.uploaded)
                Text(
                  underVerification,
                  style: const TextStyle(color: Colors.blue),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        if (km.bankName != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(km.bankName!),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                readOnly: km.ifscStatus == kycMOs.verified,
                controller: ifscTc,
                keyboardType: TextInputType.name,
                inputFormatters: [UpperCaseTextFormatter()],
                maxLength: 11,
                decoration: const InputDecoration(
                    labelText: "Bank IFSC Code", counterText: ""),
                onChanged: (value) async {
                  ifscDetails.value = "Fetching details...";
                  if (value.isNotEmpty) {
                    EasyDebounce.debounce(
                        'd', const Duration(milliseconds: 1400), () async {
                      var bankDetails = await kycMOs.getIFSCdetails(value);
                      ifscDetails.value = bankDetails ?? "Invalid IFSC code";
                      if (bankDetails != null) {
                        await km.docRef?.set({
                          kycMOs.ifsc: value,
                          kycMOs.bankName: await kycMOs.getIFSCbank(value),
                          kycMOs.ifscStatus: kycMOs.uploaded,
                        }, SetOptions(merge: true));
                      }
                    });
                  } else {
                    ifscDetails.value = "";
                  }
                },
              ),
              if (km.ifscStatus == kycMOs.verified)
                const Text(
                  "\u2705 Verified",
                  style: TextStyle(color: Colors.green),
                ),
              if (km.ifscStatus == kycMOs.uploaded)
                Text(
                  underVerification,
                  style: const TextStyle(color: Colors.blue),
                ),
              Obx(() => ifscDetails.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(ifscDetails.value),
                    )
                  : const SizedBox()),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text("${km.aadhaarUrl != null ? '' : 'Upload '}Aadhar card"),
                if (km.aadhaarUrl != null)
                  SizedBox(
                      height: 120,
                      child: CachedNetworkImage(imageUrl: km.aadhaarUrl!)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (km.aadhaarStatus == kycMOs.verified)
                      const Text(
                        "\u2705 Verified",
                        style: TextStyle(color: Colors.green),
                      ),
                    if (km.aadhaarStatus == kycMOs.uploaded)
                      Text(
                        underVerification,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    if (km.aadhaarStatus == kycMOs.invalid)
                      const Expanded(
                        child: Text(
                          "\u274C Invalid Aadhaar card, please upload valid Aadhaar card",
                          softWrap: true,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    IconButton(
                        onPressed: () {
                          if (km.aadhaarStatus != kycMOs.verified) {
                            kycMOs.pickPhoto(
                                ImageSource.gallery, kycMOs.aadhaarUrl);
                          }
                        },
                        icon: const Icon(MdiIcons.image)),
                    IconButton(
                        onPressed: () {
                          if (km.aadhaarStatus != kycMOs.verified) {
                            kycMOs.pickPhoto(
                                ImageSource.camera, kycMOs.aadhaarUrl);
                          }
                        },
                        icon: const Icon(MdiIcons.camera))
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text("${km.panCardUrl != null ? '' : 'Upload '}PAN card"),
                if (km.panCardUrl != null)
                  SizedBox(
                      height: 120,
                      child: CachedNetworkImage(imageUrl: km.panCardUrl!)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (km.panCardStatus == kycMOs.verified)
                      const Text(
                        "\u2705 Verified",
                        style: TextStyle(color: Colors.green),
                      ),
                    if (km.panCardStatus == kycMOs.uploaded)
                      Text(
                        underVerification,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    if (km.panCardStatus == kycMOs.invalid)
                      const Expanded(
                        child: Text(
                          "\u274C Invalid Pan card, please upload valid Pan card",
                          softWrap: true,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    IconButton(
                        onPressed: () {
                          if (km.panCardStatus != kycMOs.verified) {
                            kycMOs.pickPhoto(
                                ImageSource.gallery, kycMOs.panCardUrl);
                          }
                        },
                        icon: const Icon(MdiIcons.image)),
                    IconButton(
                        onPressed: () {
                          if (km.panCardStatus != kycMOs.verified) {
                            kycMOs.pickPhoto(
                                ImageSource.camera, kycMOs.panCardUrl);
                          }
                        },
                        icon: const Icon(MdiIcons.camera))
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                    "${km.checkOrPassbookUrl != null ? '' : 'Upload '}Cancelled cheque / Bank passbook first page"),
                if (km.checkOrPassbookUrl != null)
                  SizedBox(
                      height: 120,
                      child:
                          CachedNetworkImage(imageUrl: km.checkOrPassbookUrl!)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (km.checkOrPassbookStatus == kycMOs.verified)
                      const Text(
                        "\u2705 Verified",
                        style: TextStyle(color: Colors.green),
                      ),
                    if (km.checkOrPassbookStatus == kycMOs.uploaded)
                      Text(
                        underVerification,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    if (km.checkOrPassbookStatus == kycMOs.invalid)
                      const Expanded(
                        child: Text(
                          "\u274C Invalid documnet, please upload valid documnet",
                          softWrap: true,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    IconButton(
                        onPressed: () {
                          if (km.checkOrPassbookStatus != kycMOs.verified) {
                            kycMOs.pickPhoto(
                                ImageSource.gallery, kycMOs.checkOrPassbookUrl);
                          }
                        },
                        icon: const Icon(MdiIcons.image)),
                    IconButton(
                        onPressed: () {
                          if (km.checkOrPassbookStatus != kycMOs.verified) {
                            kycMOs.pickPhoto(
                                ImageSource.camera, kycMOs.checkOrPassbookUrl);
                          }
                        },
                        icon: const Icon(MdiIcons.camera))
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
