import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_web/razorpay_web.dart';

class PrimeMember {
  int? member_position;
  String? member_id;
  String? user_name;
  String? password;
  String? name;
  String? email;
  String? phone;
  DateTime? regestratiom_time;
  bool? is_paid_offline;
  String? interested_in;
  String? member_photo;
  String? order_id;
  num wallet_bal;
  num coins_bal;
  DocumentReference<Map<String, dynamic>>? referer_doc;
  DocumentReference<Map<String, dynamic>>? auth_user_doc;
  DocumentReference<Map<String, dynamic>>? docRef;

  PrimeMember({
    required this.member_position,
    required this.member_id,
    required this.user_name,
    required this.password,
    required this.name,
    required this.email,
    required this.phone,
    required this.regestratiom_time,
    required this.is_paid_offline,
    required this.interested_in,
    required this.member_photo,
    required this.order_id,
    required this.wallet_bal,
    required this.coins_bal,
    required this.referer_doc,
    required this.auth_user_doc,
    required this.docRef,
  });

  //
  static const member_position_key = "member_position";
  static const member_id_key = "member_id";
  static const name_key = "name";
  static const email_key = "email";
  static const phone_key = "phone";
  static const regestratiom_time_key = "regestratiom_time";
  static const is_paid_offline_key = "is_paid_offline";
  static const interested_in_key = "interested_in";
  static const user_name_key = "user_name";
  static const password_key = "password";
  static const member_photo_key = "member_photo";
  static const order_id_key = "order_id";
  static const wallet_bal_key = "wallet_bal";
  static const coins_bal_key = "coins_bal";
  static const referer_doc_key = "referer_doc";
  static const auth_user_doc_key = "auth_user_doc";
  static const docRef_key = "docRef";

  //
  static final col_ref = FirebaseFirestore.instance.collection("prime_members");

  //

  Map<String, dynamic> toMap() {
    return {
      member_position_key: member_position,
      member_id_key: member_id,
      name_key: name,
      email_key: email,
      phone_key: phone,
      regestratiom_time_key: regestratiom_time,
      is_paid_offline_key: is_paid_offline,
      interested_in_key: interested_in,
      user_name_key: user_name,
      password_key: password,
      member_photo_key: member_photo,
      order_id_key: order_id,
      wallet_bal_key: wallet_bal,
      coins_bal_key: coins_bal,
      referer_doc_key: referer_doc?.id,
      auth_user_doc_key: auth_user_doc?.id,
    };
  }

  //
  static PrimeMember dummy() {
    return PrimeMember(
        member_position: null,
        member_id: null,
        user_name: null,
        password: null,
        name: null,
        email: null,
        phone: null,
        regestratiom_time: null,
        is_paid_offline: null,
        interested_in: null,
        member_photo: null,
        order_id: null,
        wallet_bal: 0,
        coins_bal: 0,
        referer_doc: null,
        auth_user_doc: null,
        docRef: null);
  }

  //

  static PrimeMember fromDS(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    Map<String, dynamic> json = docSnap.data() ?? {};

    return PrimeMember(
        member_position: json[member_position_key],
        member_id: json[member_id_key],
        user_name: json[user_name_key],
        password: json[password_key],
        name: json[name_key],
        email: json[email_key],
        phone: json[phone_key],
        regestratiom_time: json[regestratiom_time_key]?.toDate(),
        is_paid_offline: json[is_paid_offline_key],
        interested_in: json[interested_in_key],
        member_photo: json[member_photo_key],
        order_id: json[order_id_key],
        wallet_bal: json[wallet_bal_key] ?? 0,
        coins_bal: json[coins_bal_key] ?? 0,
        referer_doc: json[referer_doc_key] != null
            ? col_ref.doc(json[referer_doc_key])
            : null,
        auth_user_doc: json[auth_user_doc_key] != null
            ? col_ref.doc(json[auth_user_doc_key])
            : null,
        docRef: docSnap.reference);
  }

  //

  //
  Future<void> addPrimePositionViaFire(PrimeMember pmm) async {
    if (pmm.user_name != null &&
        pmm.member_position == null &&
        pmm.is_paid_offline == true &&
        pmm.referer_doc != null &&
        pmm.member_id != null) {
      HttpsCallable addPos =
          FirebaseFunctions.instance.httpsCallable('add_prime_position');
      await addPos.call(<String, dynamic>{
        PrimeMember.user_name_key: pmm.user_name!,
      });
    } else {
      Get.snackbar("Error", "Invalid user credentials");
    }
  }

  //
  //
  Future<PrimeMember?> last_prime_member() async {
    return col_ref
        .orderBy(member_position_key, descending: true)
        .limit(1)
        .get()
        .then(((qs) {
      if (qs.docs.isNotEmpty) {
        return PrimeMember.fromDS(qs.docs.first);
      }
      return null;
    }));
  }

  //
  Future<void> add_prime_position(PrimeMember pmm) async {
    await col_ref
        .orderBy(member_position_key, descending: true)
        .limit(1)
        .get()
        .then((qs) async {
      if (qs.docs.isNotEmpty) {
        var pmLast = PrimeMember.fromDS(qs.docs.first);
        pmm.member_position = pmLast.member_position! + 1;
        pmm.is_paid_offline = true;
        await pmm.docRef?.update(pmm.toMap());
      }
    });
  }

  //
  //
  String dateTime(DateTime time) {
    String ampm = DateFormat("a").format(time).toLowerCase();
    String chatDayTime = DateFormat("dd MMM").format(time);
    //
    String today = DateFormat("dd MMM").format(DateTime.now());
    // String chatDay =
    //     DateFormat("dd MMM").format(crm.lastChatModel!.senderSentTime);

    if (today == chatDayTime) {
      chatDayTime = DateFormat("h:mm").format(time) + ampm;
    }
    return chatDayTime;
  }

  //

  // static Future<void> old_to_new() async {
  //   var list_old_prime =
  //       await primeMOs.primeMembersCR().orderBy(primeMOs.userName).get();

  //   for (var qds in list_old_prime.docs) {
  //     var prime = PrimeMemberModel.fromMap(qds.data());

  //     await col_ref.add(PrimeMember(
  //             member_position: prime.memberPosition,
  //             member_id: prime.memberID,
  //             user_name: prime.userName,
  //             password: prime.userPassword,
  //             name: "${prime.firstName ?? ''} ${prime.lastName ?? ''}",
  //             email: prime.email,
  //             phone: prime.phoneNumber,
  //             regestratiom_time: prime.userRegTime,
  //             is_paid_offline: (prime.orderID == null),
  //             interested_in: prime.interestedIn,
  //             member_photo: prime.profilePhotoUrl,
  //             order_id: prime.orderID,
  //             wallet_bal: 0,
  //             coins_bal: 1000,
  //             referer_doc: col_ref.doc(prime.refMemberId),
  //             auth_user_doc: null,
  //             docRef: null)
  //         .toMap());
  //   }
  // }

  //

  // static Future<void> update_ref_doc() async {
  //   var list_old_prime = await col_ref.orderBy(user_name_key).get();

  //   for (var qds in list_old_prime.docs) {
  //     var prime = PrimeMember.fromDS(qds);
  //     var prime_ref = await col_ref
  //         .where(member_id_key, isEqualTo: prime.referer_doc?.id)
  //         .limit(1)
  //         .get();
  //     if (prime_ref.docs.isNotEmpty) {
  //       prime.referer_doc = prime_ref.docs.first.reference;
  //       await prime.docRef?.update(prime.toMap());
  //     }
  //   }
  // }
}

//
class Razor {
  //
  static const amount = 100000;
  static final razorpay = Razorpay();
  static const razorKey = "rzp_live_yCBJw6q6PHaIpJ";

  //

  // Future<bool> check_update_and_get_order_status (String userName) async {
  //   var isPaid = false;
  //   PrimeMember.col_ref.doc() primeMemberDR(userName).get().then((ds) async {
  //     if (ds.exists && ds.data() != null) {
  //       var pmm = PrimeMember.fromMap(ds.data()!);
  //       pmm.docRef = ds.reference;

  //       if (pmm.orderID != null && pmm.is_paid_offline != true) {
  //         HttpsCallable checkOrderStatus =
  //             FirebaseFunctions.instance.httpsCallable('orderStutus');
  //         var status = await checkOrderStatus.call(<String, dynamic>{
  //           "orderId": pmm.orderID,
  //         });
  //         if (status.data == "paid") {
  //           isPaid = true;
  //           pmm.is_paid_offline = true;
  //           await addPrimePosition(pmm);
  //         } else if (pmm.is_paid_offline == null &&
  //             (status.data == "attempted")) {
  //           pmm.is_paid_offline = false;
  //           await pmm.docRef!.update(pmm.toMap());
  //         }
  //       } else if (pmm.is_paid_offline == true && pmm.member_position == null) {
  //         await addPrimePosition(pmm);
  //       }
  //     }
  //   });
  //   return isPaid;
  // }

  // //
  // void razorInIt(String userName) async {
  //   razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
  //       (PaymentSuccessResponse response) async {
  //     var isPaid = await checkUpdateAndGetOrderStatus(userName);
  //     if (isPaid) {
  //       Get.snackbar("Payment success", "Proceed to prime");
  //     } else {
  //       Get.snackbar("Fetching payment...", "Please check status");
  //     }
  //   });
  //   razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
  //       (PaymentFailureResponse response) {
  //     Get.snackbar("Payment Error", "Please try again");
  //   });
  // }

  // //
  // void razorOrder(PrimeMember pmm) {
  //   if (pmm.orderID != null && pmm.phone != null && pmm.email != null) {
  //     razorpay.open({
  //       'key': razorKey,
  //       'amount': amount, //in the smallest currency sub-unit.
  //       'name': 'My Shop AU',
  //       'order_id': pmm.orderID!, // Generate order_id using Orders API

  //       'prefill': {
  //         'contact': pmm.phone!,
  //         'email': pmm.email!,
  //       }
  //     });
  //   } else {
  //     Get.snackbar("Error", "Invalid user credentials");
  //   }
  // }
}
