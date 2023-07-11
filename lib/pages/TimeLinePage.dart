import 'package:flutter/material.dart';
import 'package:social_media/pages/HomePage.dart';
import 'package:social_media/widgets/HeaderWidget.dart';
import 'package:social_media/widgets/PostWidget.dart';
import 'package:social_media/widgets/ProgressWidget.dart';
import '../models/user.dart';

class TimeLinePage extends StatefulWidget {
  final User user;
  const TimeLinePage({
    Key? key,
    required this.user,
  }) : super(key: key);
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  List<Post> postList = [];
  @override
  void initState() {
    super.initState();
    fetchPost();
  }

  void fetchPost() {
    userPostReference
        .doc('AllPosts')
        .collection("userPost",)
        .get()
        .then((userPosts) {
      for (var doc in userPosts.docs) {
        Post post = Post(
            postID: doc.data()['post_id'],
            ownerID: doc.data()['owner_id'],
            username: doc.data()['username'],
            description: doc.data()['description '],
            imageURL: doc.data()['image_url'],
            likes: doc.data()['Likes'],
            loaction: doc.data()['Location'],
            profileImage: doc.data()['profile_Image']);

        postList.add(post);
      }
    });
  }

  @override
  Widget build(context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: customAppBar(context, title: "Scoop"),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                  itemCount: postList.length,
                  itemBuilder: (context, index) {
                    if (postList.isNotEmpty) {
                      return PostWidget(
                        
                        username: postList[index].username,
                        profileImage: postList[index].profileImage,
                        postImageUrl: postList[index].imageURL,
                        location: postList[index].loaction,
                        postDescription: postList[index].description,
                      );
                    } else {
                      return circularProgress();
                    }
                  }),
            ),
          ],
        ));
  }
}
