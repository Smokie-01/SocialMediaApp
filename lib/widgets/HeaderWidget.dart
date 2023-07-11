import 'package:flutter/material.dart';

AppBar customAppBar(BuildContext context,
    {String title = "",
    bool disableBackButton = false,
    bool isAppTitle = false}) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    automaticallyImplyLeading: disableBackButton ? false : true,
    title: Text(
      isAppTitle ? "OctetX" : title,
      style: TextStyle(color: Colors.white, fontSize: isAppTitle ? 45 : 24),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: isAppTitle ? true : false,
    backgroundColor: Colors.black,
  );
}
