import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  /// 0 = coins, 1 = wallet, 2 = cash, 3 = shopping;
  int? from;
  int? to;
  num amount;

  /// null = invalid, 0 = initiated, 10 = completed, 1 = approved, 2 = under_progress, 3 = rejected, 4 = pending_from_admin, 5 = kyc_pending;
  int? status;
  String? admin_comments;
  DateTime init_time;
  DateTime? settlement_time;
  String? bank_trans_id;
  num charges;
  DocumentReference<Map<String, dynamic>>? shopping_order;
  DocumentReference<Map<String, dynamic>> claim_member;
  DocumentReference<Map<String, dynamic>> claim_user;
  DocumentReference<Map<String, dynamic>> docRef;

  Transaction({
    required this.from,
    required this.to,
    required this.amount,
    required this.status,
    required this.admin_comments,
    required this.init_time,
    required this.settlement_time,
    required this.bank_trans_id,
    required this.charges,
    required this.shopping_order,
    required this.claim_member,
    required this.claim_user,
    required this.docRef,
  });

  //
  static const from_key = "from";
  static const to_key = "to";
  static const amount_key = "amount";
  static const status_key = "status";
  static const admin_comments_key = "admin_comments";
  static const init_time_key = "init_time";
  static const settlement_time_key = "settlement_time";
  static const bank_trans_id_key = "bank_trans_id";
  static const charges_key = "charges";
  static const shopping_order_key = "shopping_order";
  static const claim_member_key = "claim_member";
  static const claim_user_key = "claim_user";

  //
  static final col_ref = FirebaseFirestore.instance.collection("transactions");
}
