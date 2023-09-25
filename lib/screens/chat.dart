import 'package:chatconnect/widgets/newmessage.dart';
import 'package:chatconnect/widgets/oldmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class Chat extends StatefulWidget {
  const Chat(this.username, this.userid, this.imageuri, this.otheruser,
      {super.key});

  final String username;
  final String userid;
  final String imageuri;
  final String otheruser;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool uploading = false;

  void setuploading(bool value) {
    setState(() {
      uploading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String conversationid = (int.parse(
                FirebaseAuth.instance.currentUser!.phoneNumber!.substring(1)) +
            int.parse(widget.otheruser.substring(1)))
        .toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.imageuri),
                ),
                // Text(widget.username)
              ],
            )),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.username,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userid)
                    .snapshots(),
                builder: (BuildContext ctx, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!['status'],
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w700),
                    );
                  } else {
                    return const Text("");
                  }
                })
          ],
        ),
        actions: [
          // IconButton(onPressed: () {}, icon: const Icon(Icons.call)),

          ZegoSendCallInvitationButton(
            isVideoCall: true,
            resourceID: "zegouikit_call",
            icon: ButtonIcon(icon: const Icon(Icons.video_call)),
            // For offline call notification
            invitees: [
              ZegoUIKitUser(
                id: widget.userid,
                name: widget.otheruser,
              ),
            ],
            iconSize: const Size(35, 35),
          ),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        ],
      ),
      body: Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: OldMessage(
                    conversationid: conversationid,
                    otheruserid: widget.userid)),
            Offstage(
              offstage: !uploading,
              child: const Center(child: LinearProgressIndicator()),
            ),
            NewMessage(
                otheruserid: widget.userid,
                conversationid: conversationid,
                setuploading: setuploading),
          ],
        );
      }),
    );
  }
}
