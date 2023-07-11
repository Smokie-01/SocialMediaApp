import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_button/sign_button.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/pages/CreateAccountPage.dart';
import 'package:social_media/pages/NotificationsPage.dart';
import 'package:social_media/pages/ProfilePage.dart';
import 'package:social_media/pages/SearchPage.dart';
import 'package:social_media/pages/TimeLinePage.dart';

import 'package:social_media/pages/UploadPage.dart';

// Its Instance google signIn method to accces google acounts
final GoogleSignIn googleSignIn = GoogleSignIn();
final CollectionReference userReference =
    FirebaseFirestore.instance.collection("users");
final CollectionReference userPostReference =
    FirebaseFirestore.instance.collection("post");
final DateTime time = DateTime.now();
final Reference storageRefrence = FirebaseStorage.instance.ref().child("Posts");
User? currentUser;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    pageController;

    googleSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controllSignIn(gSignInAccount);
    }, onError: (gError) {
      print("Error Messgae " + gError.toString());
    });
    googleSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controllSignIn(gSignInAccount);
    }).catchError((onError) {
      print("Error Messgae " + onError.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  // to check weather the user is logged in or not
  bool isSignedIn = false;
  PageController pageController = PageController();
  int getPageIndex = 0;

  controllSignIn(GoogleSignInAccount? gSignInAccount) async {
    if (gSignInAccount != null) {
      await saveUserInfoToFireStore();
      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  loginUser() {
    googleSignIn.signIn();
  }

  saveUserInfoToFireStore() async {
    final GoogleSignInAccount? gCurrentUser = googleSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await userReference.doc(gCurrentUser!.id).get();

    if (!documentSnapshot.exists) {
      final userName = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateAccountPage(),
          ));
      if (userName != null) {
        userReference.doc(gCurrentUser.id).set({
          "id": gCurrentUser.id,
          "email": gCurrentUser.email,
          "userName": userName,
          "imageUrl": gCurrentUser.photoUrl,
          "profileName": gCurrentUser.displayName,
          "bio": "",
          "timeStamp ": time
        });

        documentSnapshot = await userReference.doc(gCurrentUser.id).get();
      }
    }

    currentUser = User.fromDocument(documentSnapshot);
  }

  void changePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  void whenPageChanges(int pageIndex) {
    setState(() {
      getPageIndex = pageIndex;
    });
  }

  Widget buildSignedInScreen() {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.grey, Colors.black],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Buddies",
              style: TextStyle(color: Colors.white, fontSize: 55),
            ),
            SignInButton(buttonType: ButtonType.google, onPressed: loginUser)
          ],
        ),
      ),
    );
  }

  Widget buildHomeScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          TimeLinePage(
            user: currentUser!,
          ),
          SearchPage(),
          UploadPage(
            user: currentUser!,
          ),
          NotificationsPage(),
          ProfilePage(
            user: currentUser!,
            userProfileId: currentUser!.id!,
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera_sharp),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
          )
        ],
        backgroundColor: Colors.black,
        onTap: changePage,
        currentIndex: getPageIndex,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return buildHomeScreen();
    } else {
      return buildSignedInScreen();
    }
  }
}
