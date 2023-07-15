import 'package:flutter/material.dart';
import 'package:social_media/pages/HomePage.dart';
import 'package:social_media/widgets/HeaderWidget.dart';
import 'package:social_media/widgets/PostWidget.dart';
import 'package:social_media/widgets/ProgressWidget.dart';
import '../models/postModel.dart';
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
    print("fecth called");
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
            likes: 0,
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
              child: StreamBuilder(
                stream:  userPostReference.doc('AllPosts').collection("userPost").snapshots(),
                builder: (context, snapshot) {
                  print("stream builder called");
                  if(snapshot.hasData){
                   print(snapshot.data!.docs.length);

                  return  ListView.builder(
                    itemCount: postList.length,
                    itemBuilder: (context, index) {  
                         snapshot.data!.docs.map((docs) {  
                        PostWidget(
                          username: docs.data()['username'],
                          profileImage: docs.data()['profile_Image'],
                          postImageUrl: docs.data()['image_url'],
                          location: docs.data()['Location'],
                          postDescription: docs.data()['description'],
                        );
                      } ,
                      );          
                   return Center(child: circularProgress()); 
                   },
                  );
                 }
               return const Center(child: Text('There is No data'));}
              
              ),
            ),
          ],
        ));
  }
}
