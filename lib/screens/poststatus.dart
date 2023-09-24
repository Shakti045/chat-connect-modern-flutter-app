import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PostStatus extends StatefulWidget {
  const PostStatus({super.key, required this.imagefile});

  final File imagefile;

  @override
  State<StatefulWidget> createState() {
    return _PostStatusState();
  }
}

class _PostStatusState extends State<PostStatus> {
  bool uploading = false;
  final _captiontextcontroller = TextEditingController();
  double _percentage = 0;

  Future<String> uploadFile() async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('status')
        .child('${Timestamp.now().seconds}.jpg');

    final uploadTask = storageReference.putFile(widget.imagefile);

    uploadTask.snapshotEvents.listen((snapshot) {
      double percentage =
          (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      setState(() {
        _percentage = percentage;
      });
    });
    await uploadTask;
    return await storageReference.getDownloadURL();
  }

  void _uploadstatus() async {
    setState(() {
      uploading = true;
    });
    final urlstring = await uploadFile();
    await FirebaseFirestore.instance
        .collection('status')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      'statusurl': urlstring,
      'caption': _captiontextcontroller.text.isNotEmpty
          ? _captiontextcontroller.text
          : null,
      'createdat': Timestamp.now(),
      'number':FirebaseAuth.instance.currentUser!.phoneNumber
    });
    setState(() {
      uploading = false;
    });
    if(context.mounted){
        Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  Column(
          children: [
            Expanded(
              child: Image.file(
                widget.imagefile,
                fit: BoxFit.fitWidth,
              ),
            ),
            Offstage(
              offstage: !uploading,
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Uploading $_percentage%....')
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _captiontextcontroller,
                decoration: const InputDecoration(
                  hintText: "Add a caption....",
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      
                      onPressed: () {},
                      child: const Text('Status (Contacts)')),
                  IconButton(
                       
                      style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          backgroundColor: Colors.green.shade800),
                      onPressed:_uploadstatus,
                      icon: const Icon(Icons.send))
                ],
              ),
            ),
          ],
        ),
      
    );
  }
}
