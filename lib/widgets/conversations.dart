import 'package:chatconnect/widgets/conversationbubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConverSations extends StatelessWidget {
  ConverSations({super.key});

  final List converstion = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 10),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('conversations')
              .where('users',
                  arrayContains: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.message,size: 35,),
                    Text('You have not statrted any conversation yet',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),textAlign: TextAlign.center,),
                  ],
                ),
              );
            }
            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              docs.sort((a, b) => b['lastupdated'].compareTo(a['lastupdated']));
              return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final otheruserindex = docs[index]['users']
                        .indexOf(FirebaseAuth.instance.currentUser!.uid);
                    return ConversationBubble(
                        otheruserid: docs[index]['users']
                            [otheruserindex == 0 ? 1 : 0],
                        lastupdated: docs[index]['lastupdated']);
                  });
            }
            return const Center(
              child: Icon(
                Icons.error,
                size: 40,
              ),
            );
          }),
    );
  }
}
