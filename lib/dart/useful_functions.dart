import 'package:easy_debounce/easy_debounce.dart';

void afterDebounce({
  int seconds = 1,
  required Future<void> Function() after,
}) async {
  EasyDebounce.debounce('d', Duration(seconds: seconds), after);
}
