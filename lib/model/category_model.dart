import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../services/firebase.dart';

class CategoryModel {
  String name;
  String? imageUrl;
  DateTime uploadTime;
  Reference? imageSR;

  CategoryModel({
    required this.name,
    required this.imageUrl,
    required this.uploadTime,
    required this.imageSR,
  });

  Map<String, dynamic> toMap() {
    return {
      catMOs.name: name,
      catMOs.imageUrl: imageUrl,
      catMOs.uploadTime: Timestamp.fromDate(uploadTime),
      catMOs.imageSR: imageSR?.fullPath,
    };
  }

  factory CategoryModel.fromMap(Map catMap) {
    return CategoryModel(
      name: catMap[catMOs.name],
      imageUrl: catMap[catMOs.imageUrl],
      uploadTime: catMap[catMOs.uploadTime]?.toDate(),
      imageSR: catMap[catMOs.imageSR] != null
          ? storageRef.child(catMap[catMOs.imageSR])
          : null,
    );
  }
}

CategoriesModelObjects catMOs = CategoriesModelObjects();

class CategoriesModelObjects {
  final name = "name";
  final imageUrl = "imageUrl";
  final uploadTime = "uploadTime";
  final listCat = "listCat";
  final imageSR = "imageSR";

  final categories = "categories";
  DocumentReference<Map<String, dynamic>> categoriesDocRef() {
    return FirebaseFirestore.instance.collection("adminDocs").doc(categories);
  }

  Reference thisCatStorageRef(String catName) {
    return storageRef.child(categories).child("$catName.jpg");
  }

  Future<List<CategoryModel>?> listFireCatNames() async {
    return await categoriesDocRef().get().then((value) => listCatNames(value));
  }

  List<CategoryModel> listCatUptime(
      DocumentSnapshot<Map<String, dynamic>> docSnap) {
    var list0 = docSnap.data()?[listCat] as List;
    var list = list0.map((e) => CategoryModel.fromMap(e)).toList();
    list.sort((p1, p2) {
      return Comparable.compare(p2.uploadTime, p1.uploadTime);
    });
    return list;
  }

  List<CategoryModel> listCatNames(
      DocumentSnapshot<Map<String, dynamic>>? docSnap) {
    var list0 = docSnap!.data()?[listCat] as List;
    var list = list0.map((e) => CategoryModel.fromMap(e)).toList();
    list.sort((p1, p2) {
      return Comparable.compare(p1.name, p2.name);
    });
    return list;
  }
}
