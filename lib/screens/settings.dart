import 'package:chatconnect/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final List<Map<String, Object>> additionals = [
  {
    "icon": Icons.key,
    "tittle": 'Account',
    "subtittle": 'Security notifications, change number'
  },
  {
    "icon": Icons.lock,
    "tittle": 'Privacy',
    "subtittle": 'Block contacts, disappearing messages'
  },
  {
    "icon": Icons.chat_bubble,
    "tittle": 'Chats',
    "subtittle": 'Theme, wallapapers, chat history'
  },
  {
    "icon": Icons.notifications,
    "tittle": 'Notifications',
    "subtittle": 'Message, group & call tones'
  },
  {
    "icon": Icons.storage,
    "tittle": 'Storage and data',
    "subtittle": 'Network usage, auto-download'
  },
  {
    "icon": Icons.language,
    "tittle": 'App language',
    "subtittle": "English(device's language)"
  },
];

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text("Settings"),
      ),
      body:  Column(
            children: [
               StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Expanded(
                          child:  Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                       if (snapshot.hasData) {
                        return  ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext  context)=>Profile(profileimageurl: snapshot.data!['profilephoto'], about: snapshot.data!['about'], name: snapshot.data!['name'] ?? snapshot.data!['number'], phone: snapshot.data!['number'])));
                            },
                            contentPadding: const EdgeInsets.all(10),
                            shape: const BorderDirectional(
                                bottom: BorderSide(width: 0.1, color: Colors.white)),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data!['profilephoto']),
                              radius: 30,
                            ),
                            title:  Text(
                              snapshot.data!['name'],
                              style:
                                 const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                            subtitle: Text(
                              snapshot.data!['about'],
                              style: TextStyle(color: Colors.white.withOpacity(0.5)),
                            ),
                            trailing: IconButton(
                                onPressed: () {}, icon: const Icon(Icons.qr_code)),
                          
                        );
                      }
                      
                      return const Center(
                        child: Icon(
                          Icons.error,
                          size: 40,
                        ),
                      );
                    }),
              
              const SizedBox(
                height: 10,
              ),
              
              for (final additional in additionals)
                ListTile(
                  leading: Icon(additional['icon'] as IconData),
                  title: Text(additional['tittle'] as String),
                  subtitle: Text(additional['subtittle'] as String),
                )
            ],
          ),
      
      
    );
  }
}
