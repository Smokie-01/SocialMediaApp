import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/pages/HomePage.dart';
import 'package:social_media/widgets/ProgressWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadPage extends StatefulWidget {
  final User user;

  const UploadPage({super.key, required this.user});
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  TextEditingController postDescriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  File? _image;
  bool isUploading = false;

  getUsersCurrentLocation() async {
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark mPlaceMark = placemarks[0];
    String specificAdress = "${mPlaceMark.locality},${mPlaceMark.country} ";
    locationController.text = specificAdress;
  }

  // Future<String> getTargetPath() async {
  //   final tDirectory = await getTemporaryDirectory();
  //   final path = tDirectory.path;
  //   return path;
  // }

  Future contorlUploadingAndSave() async {
    setState(() {
      isUploading = true;
    });

    String downloadURL = await uploadPhoto(_image);
    savePostInfoandDesc(
        url: downloadURL,
        location: locationController.text,
        description: postDescriptionController.text);

    locationController.clear();
    postDescriptionController.clear();

    setState(() {
      _image = null;
      isUploading = false;
    });
  }

  


  savePostInfoandDesc(
      {required String url,
      required String location,
      required String description}) {
    final uniqueImageId = DateTime.now().millisecondsSinceEpoch.toString();
    userPostReference
        .doc("AllPosts")
        .collection("userPost")
        .doc(uniqueImageId)
        .set({
      "post_id": DateTime.now().millisecondsSinceEpoch.toString(),
      "owner_id": widget.user.id,
      "timeStamp": time,
      "username": widget.user.userName,
      "Likes": {},
      "description ": description,
      "Location": location,
      "image_url": url,
      "profile_Image": widget.user.imageUrl ?? ""
    });
  }

  Future<String> uploadPhoto(File? image) async {
    UploadTask storageUploadTask = storageRefrence
        .child("post_${DateTime.now().toString()}.jpg")
        .putFile(image!);
    TaskSnapshot storageTaskSnapshot = await storageUploadTask;
    final downloadURL = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Widget takeImageFromCamera() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.white,
            fixedSize: const Size(100, 100)),
        onPressed: () async {
          final ImagePicker picker = ImagePicker();
          // Pick an image.
          final XFile? image = await picker.pickImage(
              source: ImageSource.camera, imageQuality: 70);

          if (image != null) {
            setState(() {
              _image = File(image.path);
            });
            Navigator.pop(context);
          }
        },
        child: Image.asset(
          "images/camera.png",
          height: 60,
          width: 60,
        ));
  }

  Widget takeImageFromGalary() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.white,
            fixedSize: const Size(100, 100)),
        onPressed: () async {
          final ImagePicker picker = ImagePicker();
          // Pick an image.
          final XFile? image = await picker.pickImage(
              source: ImageSource.gallery, imageQuality: 70);

          if (image != null) {
            setState(() {
              _image = File(image.path);
            });
            Navigator.pop(context);
          }
        },
        child: Image.asset(
          "images/gallery.png",
          height: 60,
          width: 60,
        ));
  }

  void showBotttomSheet() {
    // A method to show bottom sheet and acces galLary and camera
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (_) {
          return ListView(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            shrinkWrap: true,
            children: [
              const Text(
                "Choose Source",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const Divider(
                thickness: 2,
                endIndent: 25,
                indent: 25,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [takeImageFromGalary(), takeImageFromCamera()],
              )
            ],
          );
        });
  }

  Widget uploadImageScreen() {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              // onPressed: isUploading ? null : contorlUploadingAndSave,
              onPressed: () async  {
                isUploading ? null : await contorlUploadingAndSave().then((_) =>  (){});
               
              },
              child: const Text("Share",
                  style: TextStyle(color: Colors.amber, fontSize: 24)))
        ],
        backgroundColor: Colors.black,
        title: const Text("New Post ", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(children: [
          isUploading ? linearProgress() : const SizedBox(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: showBotttomSheet,
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    margin: const EdgeInsets.all(10),
                    height: 200,
                    width: double.infinity,
                    child: _image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Center(
                                child: Text("Please Select Image",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.white,
                              )
                            ],
                          )
                        : Image.file(fit: BoxFit.cover, _image!),
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "${widget.user.imageUrl}",
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(
                          CupertinoIcons.person,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                title: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: postDescriptionController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Say Something about Image",
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
              const Divider(
                thickness: 2,
                endIndent: 25,
                indent: 25,
                color: Colors.grey,
              ),
              ListTile(
                leading: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: IconButton(
                      icon: const Icon(Icons.location_pin),
                      onPressed: getUsersCurrentLocation,
                    ),
                  ),
                ),
                title: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: locationController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "so where were you ? ",
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
              const Divider(
                thickness: 2,
                endIndent: 25,
                indent: 25,
                color: Colors.grey,
              ),
            ],
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return uploadImageScreen();
  }
}
