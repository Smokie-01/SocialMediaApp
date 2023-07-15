// ignore_for_file: public_member_api_docs, sort_constructors_first



import 'package:flutter/material.dart';
import 'package:social_media/widgets/commentsWidget.dart';

class PostWidget extends StatefulWidget {
  final String? postImageUrl;
  final String profileImage;
  final String username;
  final String postDescription;
  final String location;

   PostWidget(
      {Key? key,
      required this.username,
      required this.postImageUrl,
      required this.postDescription,
      required this.profileImage,
      required this.location})
      : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
   int initialLikes = 0;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.profileImage),
            ),
            title: Text(widget.username, style: TextStyle(color: Colors.white)),
            subtitle: Row(
              children: [
               const  Icon(
                  Icons.location_pin,
                  color: Colors.amber,
                ),
                Text(widget.location, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            height: mq.height * .3,
            width: mq.width,
            child: Image.network(
              "${widget.postImageUrl}",
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                           initialLikes++;
                        });
                      },
                      child:  Icon(Icons.favorite, color: Colors.red)),
                     SizedBox(width: 6),
                    Text(initialLikes.toString(), style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children:  [
                    Icon(Icons.comment),
                    SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: (){
                      YourPostDetailsScreen();
                      },
                      child: Text('comments',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            " Post-Description :  ${widget.postDescription}",
            style:const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
