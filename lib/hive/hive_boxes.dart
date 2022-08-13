import 'package:hive_flutter/hive_flutter.dart';

HiveBoxes boxes = HiveBoxes();

class HiveBoxes {
  final userBox = "userBox";
}

final userBox = Hive.box(boxes.userBox);
String? userBoxUID() {
  return userBox.get(boxStrings.userUID);
}

//
BoxStrings boxStrings = BoxStrings();

class BoxStrings {
  final userUID = "userUID";
}
