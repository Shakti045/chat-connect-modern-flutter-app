import 'dart:io';

import 'package:chatconnect/screens/poststatus.dart';
import 'package:chatconnect/screens/statusview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyStatus extends StatefulWidget {
  const MyStatus({super.key});

  @override
  State<MyStatus> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyStatus> {
  bool _deletingstatus = false;
  Future getuserdetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  void deletestatus() async {
    setState(() {
      _deletingstatus = true;
    });
    await FirebaseFirestore.instance
        .collection('status')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    setState(() {
      _deletingstatus = false;
    });
  }

  late Future futuremaker;
  @override
  void initState() {
    futuremaker = getuserdetails();
    super.initState();
  }

  void _pickstatus() async {
    final pickedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedimage == null) {
      return;
    }
    if (context.mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return PostStatus(imagefile: File(pickedimage.path));
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('status')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("");
          }
          if (snapshot.hasData) {
            return ListTile(
              onTap: () {
                snapshot.data!.exists
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext ctx) => StatusView(
                            caption: snapshot.data!['caption'],
                            imageurl: snapshot.data!['statusurl'],
                            ondeleterequest: () {
                              deletestatus();
                            },
                            ismine: true)))
                    : _pickstatus();
              },
              leading: FutureBuilder(
                  future: futuremaker,
                  builder: (context, snap) {
                    if (snapshot.hasData) {
                      return !snapshot.data!.exists
                          ? const Icon(
                              Icons.add,
                              size: 50,
                            )
                          : Hero(
                              tag:snapshot.data!['statusurl'],
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  snapshot.data!['statusurl'],
                                ),
                              ),
                            );
                    }
                    return const Center();
                  }),
              title: const Text(
                'My status',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  snapshot.data!.exists
                      ? snapshot.data!['createdat']
                          .toDate()
                          .toLocal()
                          .toString()
                          .substring(0, 16)
                      : 'Tap to add status update',
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
              trailing: Offstage(
                  offstage: !_deletingstatus,
                  child: const CircularProgressIndicator()),
            );
          }
          return const Center(
            child: Icon(
              Icons.error,
              size: 40,
            ),
          );
        });
  }
}
