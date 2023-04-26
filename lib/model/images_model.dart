import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';

import '../services/firebase.dart';

class ImageModel {
  String url;
  Reference? sr;
  ImageModel({
    required this.url,
    required this.sr,
  });

  Map<String, dynamic> toMap() {
    return {
      "url": url,
      "sr": sr?.fullPath,
    };
  }

  factory ImageModel.fromMap(var image) {
    
    if (image is Map) {
      return ImageModel(
        url: image["url"] ?? "",
        sr: image["sr"] != null ? storageRef.child(image["sr"]) : null,
      );
    } else {
      return ImageModel(
        url: image ?? "",
        sr: null,
      );
    }
  }
}
