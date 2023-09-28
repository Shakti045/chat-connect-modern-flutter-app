import 'package:chatconnect/provider/contactsprovider.dart';
import 'package:chatconnect/provider/deleteconversation.dart';
import 'package:chatconnect/screens/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ConversationBubble extends ConsumerWidget {
//   const ConversationBubble(
//       {super.key, required this.otheruserid, required this.lastupdated});

//   final String otheruserid;
//   final Timestamp lastupdated;

//  @override
//   Widget build(BuildContext context, WidgetRef ref) {

//   }
// }

class ConversationBubble extends ConsumerWidget {
  const ConversationBubble(
      {super.key, required this.otheruserid, required this.lastupdated});

  final String otheruserid;
  final Timestamp lastupdated;

  Future getdetails() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(otheruserid)
        .get();
  }

  @override
  Widget build(BuildContext context, ref) {
    List<Contact> contacts = ref.watch(contactProvider);

    String helper(details) {
      final Contact ctn = contacts.firstWhere((element) {
        return element.phones.isNotEmpty
            ? element.phones[0].normalizedNumber == details['number']
            : false;
      }, orElse: () => Contact());

      return ctn.displayName.isNotEmpty ? ctn.displayName : details['number'];
    }

    return FutureBuilder(
        future: getdetails(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final details = snapshot.data;
            final displayname =
                contacts.isEmpty ? details['number'] : helper(details);
            final String conversationid = (int.parse(FirebaseAuth
                        .instance.currentUser!.phoneNumber!
                        .substring(1)) +
                    int.parse(details['number'].substring(1)))
                .toString();
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                tileColor: ref
                        .watch(deleteConversationStateProvider)
                        .contains(conversationid)
                    ? Colors.black54
                    : null,
                onLongPress: () {
                  ref
                      .read(deleteConversationStateProvider.notifier)
                      .rmoveoraddonversationid(conversationid);
                },
                onTap: ref.watch(deleteConversationStateProvider).isEmpty
                    ? () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => Chat(
                                displayname,
                                otheruserid,
                                details!['profilephoto'],
                                details['number'],
                                conversationid)));
                      }
                    : () {
                        ref
                            .read(deleteConversationStateProvider.notifier)
                            .rmoveoraddonversationid(conversationid);
                      },
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(details!['profilephoto']),
                ),
                title: Text(displayname),
                subtitle: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('conversations')
                        .doc(conversationid)
                        .collection('messages')
                        .orderBy('createdat', descending: true)
                        .limit(1)
                        .snapshots(),
                    builder: (BuildContext ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("");
                      }
                      if (!snapshot.hasData) {
                        return const Text("");
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Text('Statrted conversation',
                            style:  TextStyle(color: Colors.white38));
                      }
                      return Text(
                        snapshot.data!.docs[0]['message'],
                        style: const TextStyle(color: Colors.white38),
                      );
                    }),
                trailing: ref
                        .watch(deleteConversationStateProvider)
                        .contains(conversationid)
                    ? const Icon(Icons.check_rounded)
                    : Text(lastupdated
                        .toDate()
                        .toLocal()
                        .toString()
                        .substring(0, 16)),
              ),
            );
          }

          return const Text("");
        });
  }
}
