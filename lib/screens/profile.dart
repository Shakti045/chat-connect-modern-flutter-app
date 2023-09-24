import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile(
      {super.key,
      required this.profileimageurl,
      required this.about,
      required this.name,
      required this.phone});

  final String profileimageurl;
  final String name;
  final String about;
  final String phone;
  @override
  State<Profile> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  bool loading = false;
  late String profileurl;

  @override
  void initState() {
    profileurl = widget.profileimageurl;
    super.initState();
  }

  void _pickimage(String method) async {
    final XFile? pickedimage = await ImagePicker().pickImage(
        source: method == 'camera' ? ImageSource.camera : ImageSource.gallery);
    if (pickedimage == null) {
      return;
    }

    setState(() {
      loading = true;
    });
    if(context.mounted){
      Navigator.of(context).pop();
    }
    final uploadedfileref = FirebaseStorage.instance
        .ref()
        .child('user_profile_photos')
        .child('${widget.name}.jpg');
    ;
    await uploadedfileref.putFile(File(pickedimage.path));

    final downloadurl = await uploadedfileref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"profilephoto": downloadurl});
    setState(() {
      profileurl = downloadurl;
      loading = false;
    });
  }

  void _showimageoptions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profile photo',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 30,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                          onPressed: () {
                            _pickimage('camera');
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Pick from camera")),
                      TextButton.icon(
                          onPressed: () {
                            _pickimage('picture');
                          },
                          icon: const Icon(Icons.photo),
                          label: const Text("Pick from gallery")),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            loading
                ? const CircularProgressIndicator()
                : GestureDetector(
                    onTap: _showimageoptions,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(profileurl),
                      radius: 80,
                    ),
                  ),
            const SizedBox(
              height: 15,
            ),
            ListTile(
              shape: const BorderDirectional(
                  bottom: BorderSide(width: 0.1, color: Colors.white)),
              leading: const Icon(Icons.person),
              title: const Text(
                'Name',
                style: TextStyle(color: Colors.white54),
              ),
              subtitle: Text(
                widget.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            ),
            ListTile(
              shape: const BorderDirectional(
                  bottom: BorderSide(width: 0.1, color: Colors.white)),
              leading: const Icon(Icons.info_rounded),
              title: const Text(
                'About',
                style: TextStyle(color: Colors.white54),
              ),
              subtitle: Text(
                widget.about,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              trailing:
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            ),
            ListTile(
              shape: const BorderDirectional(
                  bottom: BorderSide(width: 0.1, color: Colors.white)),
              leading: const Icon(Icons.call),
              title: const Text(
                'Phone',
                style: TextStyle(color: Colors.white54),
              ),
              subtitle: Text(
                widget.phone,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            )
          ],
        ),
      ),
    );
  }
}
