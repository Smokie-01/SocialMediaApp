import 'package:flutter/material.dart';
import 'package:social_media/widgets/HeaderWidget.dart';
import 'package:social_media/widgets/ProgressWidget.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Notification"),
      body: circularProgress(),
    );
  }
}

class NotificationsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Activity Feed Item goes here');
  }
}
