import 'package:chatconnect/screens/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List contacts = [];

  bool loading = true;
  List availaibleusernumber = [];
  List databaseusers = [];
  
  void getallcontacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> usercontacts =
          await FlutterContacts.getContacts(withProperties: true);
      final dbusers =
          await FirebaseFirestore.instance.collection('users').get();
      availaibleusernumber =
          dbusers.docs.map((user) => user['number']).toList();
      contacts = usercontacts;
      databaseusers = dbusers.docs;
      setState(() {
        loading = false;
      });
    }
  }



  @override
  void initState() {
    getallcontacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: CircularProgressIndicator(),
    );

    if (!loading) {
      content = Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (BuildContext context, int index) {
              final userindex = contacts[index].phones.isNotEmpty
                  ? availaibleusernumber
                      .indexOf(contacts[index].phones[0].normalizedNumber)
                  : -1;

              return ListTile(
                onTap: () {
                  if (userindex == -1) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          '${contacts[index].displayName} is not in chatconnect'),
                      action: SnackBarAction(label: "Invite", onPressed: () {}),
                    ));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Chat(
                              contacts[index].displayName,
                              databaseusers[userindex]['userid'],
                              databaseusers[userindex]['profilephoto'],
                              contacts[index].phones[0].normalizedNumber,
                            )));
                  }
                },
                leading:  CircleAvatar(
                  backgroundImage: NetworkImage(userindex>=0?databaseusers[userindex]['profilephoto']:'https://i.stack.imgur.com/34AD2.jpg'),
                ),
                title: Text(contacts[index].displayName),
                trailing: userindex >= 0 ? const Text('Availaible') : null,
              );
            }),
      );
    }
    return Scaffold(
        appBar: AppBar(
          
          title: const Text('Select Contact'),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: content);
  }
}
