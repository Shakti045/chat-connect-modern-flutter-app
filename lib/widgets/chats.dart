import 'package:chatconnect/screens/contacts.dart';
import 'package:chatconnect/widgets/conversations.dart';
import 'package:flutter/material.dart';


class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConverSations(),
        Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
                style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.5),
                    padding: const EdgeInsets.all(15)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const Contacts()));
                },
                icon: const Icon(
                  Icons.message,
                  size: 35,
                )))
      ],
    );
  }
}
