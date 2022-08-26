import 'package:advaithaunnathi/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:razorpay_web/razorpay_web.dart';

import '../model/user_model.dart';

//
class RegistrationModel {
  String? orderID;
  bool? isPaid;
  String? refMemberId;
  String? phoneNumber;
  String? name;
  String? interestedIn;
  String? userUID;
  DocumentReference<Map<String, dynamic>>? docRef;

  RegistrationModel({
    required this.orderID,
    required this.isPaid,
    required this.refMemberId,
    required this.phoneNumber,
    required this.name,
    required this.interestedIn,
    required this.userUID,
  });

  Map<String, dynamic> toMap() {
    return {
      regMOs.orderID: orderID,
      regMOs.isPaid: isPaid,
      regMOs.refMemberId: refMemberId,
      regMOs.phoneNumber: phoneNumber,
      regMOs.interestedIn: interestedIn,
      regMOs.name: name,
      regMOs.userUID: userUID
    };
  }

  factory RegistrationModel.fromMap(Map<String, dynamic> payMap) {
    return RegistrationModel(
      orderID: payMap[regMOs.orderID],
      isPaid: payMap[regMOs.isPaid],
      refMemberId: payMap[regMOs.refMemberId],
      phoneNumber: payMap[regMOs.phoneNumber],
      interestedIn: payMap[regMOs.interestedIn],
      name: payMap[regMOs.name],
      userUID: payMap[regMOs.userUID],
    );
  }
}

RegistrationModelObjects regMOs = RegistrationModelObjects();

class RegistrationModelObjects {
  final orderID = "orderID";
  final razorKey = "rzp_live_yCBJw6q6PHaIpJ";
  final payment = "payment";
  final isPaid = "isPaid";
  final refMemberId = "refMemberId";
  final phoneNumber = "phoneNumber";
  final interestedIn = "interestedIn";
  final name = "name";
  final userUID = "userUID";
  String refTc = "";
  final paymentDR =
      authUserCR.doc(fireUser()?.uid).collection("docs").doc("payment");

  final amount = 100000;
  final razorpay = Razorpay();

  // Future<String?> createAndGetRazorOrder(RegistrationModel regModel){

  // }

  Future<void> razorOder(RegistrationModel regModel) async {
    if (regModel.orderID == null) {
      HttpsCallable getOrderIDf =
          FirebaseFunctions.instance.httpsCallable('createAndGetOrderID');
      var orderIDf = await getOrderIDf.call();
      if (orderIDf.data != null) {
        regModel.orderID = orderIDf.data;
        if (regModel.orderID != null) {
          await paymentDR.set(regModel.toMap(), SetOptions(merge: true));
        }
      }
    }

    if (regModel.orderID != null) {
      Get.back();
      razorpay.open({
        'key': razorKey,
        'amount': 100000, //in the smallest currency sub-unit.
        'name': 'Advaita Unnathi',
        'order_id': regModel.orderID, // Generate order_id using Orders API
        // 'description': 'Fine T-Shirt',
        // 'timeout': 60, // in seconds
        'prefill': {
          'contact': regModel.phoneNumber ?? fireUser()?.phoneNumber ?? '',
          'email': fireUser()?.email ?? ''
        }
      });
    } else {
      Get.snackbar("Error", "No order found");
    }
  }

  void razorInIt() async {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) async {
      var rm = await checkAndGetRM();
      if (rm?.isPaid == true && rm?.refMemberId != null) {
        Get.snackbar("Payment success", "Proceed to prime");
        await userMOs.checkAndAddPos(rm!.refMemberId!);
      } else {
        Get.snackbar("Fetching payment...", "Proceed to prime");
      }
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      Get.snackbar("Payment Error", "Please try again");
    });
  }

  Future<RegistrationModel?> checkAndGetRM() async {
    RegistrationModel? rm;
    await paymentDR.get().then((ds) async {
      rm?.isPaid = null;
      if (ds.exists && ds.data() != null) {
        rm = RegistrationModel.fromMap(ds.data()!);
        rm!.docRef = ds.reference;

        if (rm?.orderID != null && rm?.isPaid != true) {
          HttpsCallable checkOrderStatus =
              FirebaseFunctions.instance.httpsCallable('orderStutus');
          var status = await checkOrderStatus.call(<String, dynamic>{
            "orderId": rm!.orderID,
          });
          if (status.data == "paid") {
            await paymentDR.update({isPaid: true});
            rm?.isPaid = true;
          } else if (rm?.isPaid == null &&
              (status.data == "created" || status.data == "attempted")) {
            await paymentDR.update({isPaid: false});
            rm?.isPaid = false;
          }
        }
      }
    });
    return rm;
  }
}
