// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:flutter/material.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:social_media/pages/HomePage.dart';
import 'package:social_media/widgets/ProgressWidget.dart';

import '../models/user.dart';

class EditProfilePage extends StatefulWidget {
  final String? currentUserOnlineID;
  final User? user;
  const EditProfilePage({
    Key? key,
    this.currentUserOnlineID,
    required this.user,
  }) : super(key: key);
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();

    getUserProfileData();
  }

  TextEditingController profileNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isloading = false;

  getUserProfileData() async {
    setState(() {
      isloading = true;
    });
    DocumentSnapshot documentSnapshot =
        await userReference.doc(widget.currentUserOnlineID).get();

    User user = User.fromDocument(documentSnapshot);

    profileNameController.text = user.profileName!;
    bioController.text = user.bio!;

    setState(() {
      isloading = false;
    });
  }

  updateProfile() {
    if (profileNameController.text.trim().length > 3 ||
        bioController.text.trim().length > 3) {
      userReference.doc(widget.currentUserOnlineID).update({
        "profileName": profileNameController.text,
        "bio": bioController.text,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Profile Updated succesfully")));

      Navigator.pop(context);
    }
  }

  logOutUser() async {
    await googleSignIn.signOut().then((_) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.done))
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isloading
          ? circularProgress()
          : ListView(
              shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        height: mq.height * .10,
                        width: mq.width * .20,
                        fit: BoxFit.cover,
                        imageUrl: "${widget.user!.imageUrl}",
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          child: Icon(
                            CupertinoIcons.person,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          createProfileNameTFF(),
                          createBioNameTFF(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: updateProfile,
                        child: const Text("Update"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: logOutUser,
                        child: const Text("Logout"),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }

  Widget createProfileNameTFF() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Profile Name",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextField(
            style: const TextStyle(color: Colors.white),
            controller: profileNameController,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: "Write your Profile Name",
              hintStyle: TextStyle(color: Colors.white),
            ))
      ],
    );
  }

  Widget createBioNameTFF() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Bio",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextField(
            style: const TextStyle(color: Colors.white),
            controller: bioController,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: "Describe your self ",
              hintStyle: TextStyle(color: Colors.white),
            ))
      ],
    );
  }
}
