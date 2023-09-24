import 'package:chatconnect/provider/contactsprovider.dart';
import 'package:chatconnect/screens/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      

      return ctn.displayName.isNotEmpty?ctn.displayName: details['number'];
    }

    return FutureBuilder(
        future: getdetails(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final details = snapshot.data;
            final displayname =
                contacts.isEmpty ? details['number'] : helper(details);

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Chat(
                          displayname,
                          otheruserid,
                          details!['profilephoto'],
                          details['number'])));
                },
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(details!['profilephoto']),
                ),
                title: Text(displayname),
                trailing: Text(
                    lastupdated.toDate().toLocal().toString().substring(0, 16)),
              ),
            );
          }

          return const Text("");
        });
  }
}
