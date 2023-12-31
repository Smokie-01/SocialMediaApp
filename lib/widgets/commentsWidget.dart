import 'package:flutter/material.dart';
import '../models/commentsModel.dart';
class YourPostDetailsScreen extends StatelessWidget {
  void showComments(BuildContext context) {
  List<Comment> comments = [];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              Comment comment = comments[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(""),
                ),
                title: Text(comment.comment),
              );
            },
          ),
        );
      },
    );
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showComments(context),
          child: Text('View Comments'),
        ),
      ),
    );
  }
}