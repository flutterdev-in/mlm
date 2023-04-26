import 'package:cloud_firestore/cloud_firestore.dart';

class AuthUser {
  String first_name;
  String? sur_name;
  String phone;
  String? email;
  bool? is_male;
  DateTime? dob;
  String? home_town;
  String? profile_pic;
  String? fcm_token;
  DateTime? first_login_time;
  DocumentReference<Map<String, dynamic>> docRef;

  //
  AuthUser({
    required this.first_name,
    required this.sur_name,
    required this.phone,
    required this.email,
    required this.is_male,
    required this.dob,
    required this.home_town,
    required this.profile_pic,
    required this.fcm_token,
    required this.first_login_time,
    required this.docRef,
  });

  //
  static const first_name_key = "first_name";
  static const sur_name_key = "sur_name";
  static const phone_key = "phone";
  static const email_key = "email";
  static const is_male_key = "is_male";
  static const dob_key = "dob";
  static const home_town_key = "home_town";
  static const profile_pic_key = "profile_pic";
  static const fcm_token_key = "fcm_token";
  static const first_login_time_key = "first_login_time";

  //
  static final col_ref = FirebaseFirestore.instance.collection("auth_users");

  //
  Map<String, dynamic> toMap() {
    return {
      first_name_key: first_name,
      sur_name_key: sur_name,
      phone_key: phone,
      email_key: email,
      is_male_key: is_male,
      dob_key: dob,
      home_town_key: home_town,
      profile_pic_key: profile_pic,
      fcm_token_key: fcm_token,
      first_login_time_key: first_login_time
    };
  }

  //
  static AuthUser fromDS(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    Map<String, dynamic> json = docSnap.data() ?? {};

    return AuthUser(
        first_name: json[first_name_key],
        sur_name: json[sur_name_key],
        phone: json[phone_key],
        email: json[email_key],
        is_male: json[is_male_key],
        dob: json[dob_key],
        home_town: json[home_town_key],
        profile_pic: json[profile_pic_key],
        fcm_token: json[fcm_token_key],
        first_login_time: json[first_login_time_key],
        docRef: docSnap.reference);
  }
}
