import 'package:advaithaunnathi/dart/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentModel {
  String? orderID;
  String? paymentID;
  DateTime? paymentTime;

  PaymentModel({
    required this.orderID,
    required this.paymentID,
    required this.paymentTime,
  });

  Map<String, dynamic> toMap() {
    return {
      pmos.orderID: orderID,
      pmos.paymentID: paymentID,
      pmos.paymentTime:
          paymentTime != null ? Timestamp.fromDate(paymentTime!) : null,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> payMap) {
    return PaymentModel(
        orderID: payMap[pmos.orderID],
        paymentTime: payMap[pmos.paymentTime]?.toDate(),
        paymentID: payMap[pmos.paymentID]);
  }
}

PaymentModelObjects pmos = PaymentModelObjects();

class PaymentModelObjects {
  final orderID = "orderID";
  final paymentTime = "paymentTime";
  final paymentID = "paymentID";
  final razorKey = "rzp_test_hRloZF3oVbYuXn";
  final payment = "payment";
  String refTc = "";
  final paymentDR =
      authUserCR.doc(fireUser!.uid).collection("docs").doc("payment");

  final amount = 100000;
  final razorpay = Razorpay();

  void openRazor(String orderId) {
    razorpay.open({
      'key': 'rzp_test_hRloZF3oVbYuXn',
      'amount': 100000, //in the smallest currency sub-unit.
      'name': 'Advaita Unnathi',
      'order_id': orderId, // Generate order_id using Orders API
      // 'description': 'Fine T-Shirt',
      // 'timeout': 60, // in seconds
      'prefill': {
        'contact': fireUser?.phoneNumber ?? '',
        'email': fireUser?.email ?? ''
      }
    });
  }

  Future<void> razorOder() async {
    if (fireUser != null) {
      String? orderID;

      var paymentDS0 = await paymentDR.get();

      if (!paymentDS0.exists || paymentDS0.data()!["orderID"] == null) {
        HttpsCallable setOrder =
            FirebaseFunctions.instance.httpsCallable('setOrderID');
        await setOrder.call(<String>[fireUser!.uid]);
      }
      var paymentDS1 = await paymentDR.get();
      orderID = paymentDS1.data()!["orderID"];

      if (orderID != null) {
        openRazor(orderID);
      }
    }
  }

  void onError(PaymentFailureResponse response) {
    Get.snackbar("Payment Error", "Please try again");
  }

  Future<void> onSuccess(PaymentSuccessResponse response) async {
    if (response.paymentId != null) {
      HttpsCallable setOrder =
          FirebaseFunctions.instance.httpsCallable('paymentVerification');
      await setOrder.call(<String, dynamic>{
        "uid": fireUser!.uid,
        "paymentID": response.paymentId!,
        "refMemberId": refTc,
      });

      var paymentDS1 = await paymentDR.get();
      final paymentID = paymentDS1.data()!["paymentID"];

      if (paymentID != null) {
        Get.snackbar("Payment Success", "Congrats");
      }
    } else {
      Get.snackbar("Payment Error", "Please try again");
    }
  }
}
