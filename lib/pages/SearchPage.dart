import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/pages/HomePage.dart';

import 'package:social_media/widgets/ProgressWidget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
 var searchResult;

  void contorlSearching(String searchTxt) {
    FutureOr<QuerySnapshot> allUsers = userReference
        .where("profileName", isGreaterThanOrEqualTo: searchTxt)
        .get();
    setState(() {
      searchResult = allUsers;
    });
  }

  AppBar customSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: TextFormField(
        onChanged: (value) {},
        style: const TextStyle(color: Colors.white),
        onFieldSubmitted: contorlSearching,
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.person_pin,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
              onPressed: () => searchController.clear(),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              )),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          filled: true,
          hintText: 'Search users...',
          hintStyle: const TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget noResultScreen() {
    return const Center(
      child: Text(
        " No Search Users ",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget resultsScreen() {
    return FutureBuilder(
      future: searchResult(),
      builder: (context, AsyncSnapshot snapshot) {
        List<UserResult> searchUsersResult = [];
        if (snapshot.connectionState == ConnectionState.done) {
          for (var user in snapshot.data) {
            print(snapshot.data);
            User eachUser = User.fromDocument(user);
            UserResult userResult = UserResult(eachUser: eachUser);
            searchUsersResult.add(userResult);
          }
        } else {
          return circularProgress();
        }

        return ListView(
          children: searchUsersResult,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: customSearchAppBar(),
      body: searchResult == null ? noResultScreen() : resultsScreen(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;

  const UserResult({super.key, required this.eachUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 5),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => print("Tapped"),
            child: ListTile(
              tileColor: Colors.grey,
              title: Text("${eachUser.profileName}"),
              subtitle: Text("${eachUser.userName}"),
              leading: SizedBox(
                width: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: "${eachUser.imageUrl}",
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(
                        CupertinoIcons.person,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
