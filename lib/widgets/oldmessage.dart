import 'package:chatconnect/widgets/mediamessage.dart';
import 'package:chatconnect/widgets/messagebubble.dart';
import 'package:chatconnect/widgets/videoplayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OldMessage extends StatefulWidget {
  const OldMessage(
      {super.key, required this.conversationid, required this.otheruserid});

  final String otheruserid;
  final String conversationid;

  @override
  State<OldMessage> createState() => _OldMessageState();
}

class _OldMessageState extends State<OldMessage> {
  late Object coversationinstance;

  @override
  void initState() {
    coversationinstance = FirebaseFirestore.instance
        .collection('conversations')
        .doc(widget.conversationid)
        .collection('messages')
        .orderBy('createdat', descending: true);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .doc(widget.conversationid)
            .collection('messages')
            .orderBy('createdat', descending: true)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // print(snapshot.data?.docs[0]['message']);
            // // print(snapshot.data);
            return const Center(
              child: Text(
                'Start  messaging to see messages',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            );
          }
          final List messages = snapshot.data!.docs;
          final currentuserid = FirebaseAuth.instance.currentUser!.uid;
          return ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                if (messages[index]['mediamessage']) {
                  final mediatype = messages[index]['mediatype'];
                  if (mediatype == 'mp4') {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          messages[index]['sender'] == currentuserid
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext ctx) => VideoApp(
                                      url: messages[index]['mediaurl'])));
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                              size: 40,
                            ),
                            label:const Text('Video'),
                            )
                      ],
                    );
                  } else if (mediatype == 'jpg' || mediatype=='pdf') {
                    return MediaMessage(
                        mediaurl: messages[index]['mediaurl'],
                        isme: messages[index]['sender'] == currentuserid,medaitype:mediatype);
                  } 
                }
                return MessageBubble.next(
                    message: messages[index]['message'],
                    isMe: messages[index]['sender'] == currentuserid);
              });
        });
  }
}
