import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/pages/EditProfilePage.dart';
import 'package:social_media/pages/HomePage.dart';
import 'package:social_media/widgets/HeaderWidget.dart';
import 'package:social_media/widgets/ProgressWidget.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;
  final User user;

  const ProfilePage({
    Key? key,
    required this.userProfileId,
    required this.user,
  }) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String? currentUserOnlineID = currentUser!.id;

  createProfileTopView() {
    return FutureBuilder(
      future: userReference.doc(widget.userProfileId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = User.fromDocument(snapshot.data!);
          final mq = MediaQuery.of(context).size;
          return Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        height: mq.height * .10,
                        width: mq.width * .20,
                        fit: BoxFit.cover,
                        imageUrl: "${user.imageUrl}",
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(
                            CupertinoIcons.person,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                createColumns("post", 0),
                                createColumns("followers ", 0),
                                createColumns("following", 0),
                              ],
                            ),
                            Row(
                              children: [createButton()],
                            )
                          ],
                        ))
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.profileName.toString(),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.bio.toString(),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )
              ],
            ),
          );
        }
        return circularProgress();
      },
    );
  }

  Widget createColumns(String title, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        )
      ],
    );
  }

  createButton() {
    // THis is the method to check the profile is of current user or an another user

    bool ownsprofile = currentUserOnlineID == widget.userProfileId;
    if (ownsprofile) {
      // this button will change according to user
      // if current user then edit profile button and if another user
      // follow unfollow button
      return createButtonTitleAndFunction(
          title: "Edit Profile", performFunction: editUserProfile);
    }
  }

  editUserProfile() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditProfilePage(
            currentUserOnlineID: currentUserOnlineID,
            user: widget.user,
          ),
        ));
  }

  Widget createButtonTitleAndFunction({
    required String title,
    required Function performFunction,
  }) {
    final mq = MediaQuery.of(context).size;
    return OutlinedButton(
        onPressed: editUserProfile,
        child: Container(
          alignment: Alignment.center,
          width: mq.width * .6,
          height: mq.height * 0.04,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(title),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(
          context,
          title: widget.user.userName.toString(),
        ),
        body: ListView(
          children: [
            createProfileTopView(),
          ],
        ));
  }
}
