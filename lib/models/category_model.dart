import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/category_model.dart';
import '../services/firebase.dart';

class CategoryModel {
  String name;
  String? image_url;
  DateTime upload_time;
  Reference? image_sr;
  DocumentReference<Map<String, dynamic>>? docRef;

  CategoryModel({
    required this.name,
    required this.image_url,
    required this.upload_time,
    required this.image_sr,
    required this.docRef,
  });
  Map<String, dynamic> toMap() {
    return {
      name_key: name,
      image_url_key: image_url,
      upload_time_key: Timestamp.fromDate(upload_time),
      image_sr_key: image_sr?.fullPath,
    };
  }

  //
  static final col_ref = FirebaseFirestore.instance.collection("categories");
  //
  static const name_key = "name";
  static const image_url_key = "image_url";
  static const upload_time_key = "upload_time";
  static const image_sr_key = "image_sr";
  //

  static CategoryModel fromDS(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    Map<String, dynamic> json = docSnap.data() ?? {};

    return CategoryModel(
      name: json[name_key],
      image_url: json[image_url_key],
      upload_time: json[upload_time_key]?.toDate(),
      image_sr: json[image_sr_key] != null
          ? storageRef.child(json[image_sr_key])
          : null,
      docRef: docSnap.reference,
    );
  }

  //
  static Future<void> old_to_new() async {
    var list_old_cat = await catMOs.listFireCatNames();
    if (list_old_cat != null) {
      for (var cat in list_old_cat) {
        await col_ref.add(CategoryModel(
                name: cat.name,
                image_url: cat.imageUrl,
                upload_time: cat.uploadTime,
                image_sr: cat.imageSR,
                docRef: null)
            .toMap());
      }
    }
  }
}
