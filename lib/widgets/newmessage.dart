import 'dart:io';
import 'package:chatconnect/widgets/emojiinput.dart';
import 'package:chatconnect/widgets/mediaoptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class NewMessage extends StatefulWidget {
  const NewMessage(
      {super.key,
      required this.otheruserid,
      required this.conversationid,
      required this.setuploading});

  // final String otheruser;
  // final String currentuser;
  final String otheruserid;
  final String conversationid;
  final void Function(bool value) setuploading;

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageinput = TextEditingController();
  bool showimoji = false;

  @override
  void dispose() {
    _messageinput.dispose();
    super.dispose();
  }

  void _uploadmedia(File file, String extension) async {
    widget.setuploading(true);
    final firebasestorageref =
        FirebaseStorage.instance.ref().child('useruploads').child('${Timestamp.now().seconds}.$extension');

    await firebasestorageref.putFile(file);

    final downloadurl = await firebasestorageref.getDownloadURL();
    final conversarionref = FirebaseFirestore.instance
        .collection('conversations')
        .doc(widget.conversationid);
    await conversarionref.set({
      'users': [FirebaseAuth.instance.currentUser!.uid, widget.otheruserid],
      'lastupdated': Timestamp.now()
    });

    await conversarionref.collection('messages').add({
      'message': 'Sent a $extension',
      'mediamessage': true,
      'mediaurl': downloadurl,
      'sender': FirebaseAuth.instance.currentUser!.uid,
      'createdat': Timestamp.now(),
      'mediatype':extension
    });

    widget.setuploading(false);
  }

  void _sendmessage() async {
    if (_messageinput.text.isEmpty) {
      return;
    }
    final String text = _messageinput.text;
    _messageinput.clear();
    final conversarionref = FirebaseFirestore.instance
        .collection('conversations')
        .doc(widget.conversationid);
    await conversarionref.set({
      'users': [FirebaseAuth.instance.currentUser!.uid, widget.otheruserid],
      'lastupdated': Timestamp.now()
    });
    await conversarionref.collection('messages').add({
      'message': text,
      'mediamessage': false,
      'sender': FirebaseAuth.instance.currentUser!.uid,
      'createdat': Timestamp.now()
    });
  }

  void _pickmedia(String mode) async {
    Navigator.of(context).pop();
    if (mode == 'gallery' || mode == 'camera') {
      final imagepicker = ImagePicker();
      final XFile? pickedimage = await imagepicker.pickImage(
          source: mode == 'gallery' ? ImageSource.gallery : ImageSource.camera);
      if (pickedimage == null) {
        return;
      }
      _uploadmedia(File(pickedimage.path), 'jpg');
      return;
    }
    if (mode == 'video') {
      final imagepicker = ImagePicker();
      final XFile? pickedvideo =
          await imagepicker.pickVideo(source: ImageSource.gallery,maxDuration: const Duration(seconds: 30));
      if (pickedvideo == null) {
        return;
      }
      _uploadmedia(File(pickedvideo.path), 'mp4');
      return;
    }

    if (mode == 'document') {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) {
        return;
      }
      _uploadmedia(File(result.files.first.path!), 'pdf');
    }
  }

  void _showmediaoptions() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
            alignment: Alignment.center,
            backgroundColor: Colors.grey.shade800,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MediaOptionsButton(
                          icon: const Icon(Icons.picture_as_pdf, size: 35),
                          labeltext: 'Document',
                          onclick: () {
                            _pickmedia("document");
                          },
                          buttonbgc: Colors.indigoAccent),
                      MediaOptionsButton(
                          icon: const Icon(Icons.photo_camera, size: 35),
                          labeltext: 'Camera',
                          onclick: () {
                            _pickmedia("camera");
                          },
                          buttonbgc: Colors.pink.shade600),
                      MediaOptionsButton(
                          icon: const Icon(Icons.photo, size: 35),
                          labeltext: 'Gallery',
                          onclick: () {
                            _pickmedia("gallery");
                          },
                          buttonbgc: Colors.purple),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MediaOptionsButton(
                          icon: const Icon(
                            Icons.library_music,
                            size: 35,
                          ),
                          labeltext: 'Audio',
                          onclick: () {
                            _pickmedia("audio");
                          },
                          buttonbgc: Colors.orange.shade900),
                      MediaOptionsButton(
                          icon: const Icon(Icons.location_pin, size: 35),
                          labeltext: 'Location',
                          onclick: () {
                            _pickmedia("location");
                          },
                          buttonbgc: Colors.green.shade700),
                      MediaOptionsButton(
                          icon: const Icon(Icons.video_collection, size: 35),
                          labeltext: 'Video',
                          onclick: () {
                            _pickmedia("video");
                          },
                          buttonbgc: Colors.green.shade700),
                    ],
                  ),
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color:
                        const Color.fromARGB(255, 53, 57, 55).withOpacity(0.5),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            if (!showimoji) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            }
                            setState(() {
                              showimoji = !showimoji;
                            });
                          },
                          icon: Icon(!showimoji
                              ? Icons.emoji_emotions_sharp
                              : Icons.keyboard)),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: TextField(
                            canRequestFocus: !showimoji,
                            controller: _messageinput,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: 'Message',
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: _showmediaoptions,
                          icon: const Icon(Icons.link)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              IconButton(
                  style: IconButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 53, 57, 55)
                          .withOpacity(0.5),
                      padding: const EdgeInsets.all(10)),
                  onPressed: _sendmessage,
                  icon: const Icon(Icons.send)),
            ],
          ),
        ),
        Offstage(
          offstage: !showimoji,
          child: EmojiInput(_messageinput),
        ),
      ],
    );
  }
}
