import 'package:chatconnect/provider/contactsprovider.dart';
import 'package:chatconnect/screens/statusview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtherUserStatus extends ConsumerStatefulWidget {
  const OtherUserStatus({super.key});

  @override
  ConsumerState<OtherUserStatus> createState() {
    return _OtherUserStatusState();
  }
}

class _OtherUserStatusState extends ConsumerState<OtherUserStatus> {
  late Future futuremaker;

  List<String> contacts = [];
  Future<List<String>> getrelevantusers() async {
    final dbusers = await FirebaseFirestore.instance.collection('users').get();
    final availaibleusernumber =
        dbusers.docs.map((user) => user['number']).toList();
    ref.read(contactProvider).forEach((element) {
      if (element.phones.isEmpty) {
        return;
      }
      if (availaibleusernumber.contains(element.phones[0].normalizedNumber)) {
        contacts.add(element.phones[0].normalizedNumber);
      }
    });

    return contacts;
  }

  @override
  void initState() {
    futuremaker = getrelevantusers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futuremaker,
        builder: (BuildContext ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('status')
                    .where('number', whereIn: snapshot.data)
                    .snapshots(),
                builder: (BuildContext ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snap.hasData || snap.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No updates yet'),
                    );
                  }
                  if (snap.hasData) {
                    final List data = snap.data!.docs;
                
                    return Column(
                      children: [
                        for(final docs in data)
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>StatusView(caption: docs['caption'], imageurl: docs['statusurl'], ondeleterequest: () {}, ismine: false)));
                          },
                                leading: Hero(
                                  tag:docs['statusurl'] ,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(docs['statusurl']),
                                    radius: 30,
                                  ),
                                ),
                                title: Text(
                                  docs['number'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      docs['createdat']
                                          .toDate()
                                          .toLocal()
                                          .toString()
                                          .substring(0, 16),
                                      style:
                                          const TextStyle(color: Colors.white54),
                                    )))
                      ],
                    );
                  }
                  return const Center(
                    child: Icon(Icons.error),
                  );
                });
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
