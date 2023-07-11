import 'package:flutter/material.dart';

Widget circularProgress() {
  return Container(
    padding: EdgeInsets.all(12),
    alignment: Alignment.center,
    child: Center(
        child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),
    )),
  );
}

linearProgress() {
  return Container(
    padding: EdgeInsets.all(12),
    alignment: Alignment.center,
    child: Center(
        child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreenAccent),
    )),
  );
}
