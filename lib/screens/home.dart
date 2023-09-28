import 'package:chatconnect/provider/contactsprovider.dart';
import 'package:chatconnect/provider/deleteconversation.dart';
import 'package:chatconnect/screens/settings.dart';
import 'package:chatconnect/widgets/calls.dart';
import 'package:chatconnect/widgets/chats.dart';
import 'package:chatconnect/widgets/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  bool loading = false;

  void getallcontacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> usercontacts =
          await FlutterContacts.getContacts(withProperties: true);
      ref.read(contactProvider.notifier).setcontacts(usercontacts);
    } else {
      ref.read(contactProvider.notifier).setcontacts([]);
    }
  }

  @override
  void initState() {
    super.initState();
    getallcontacts();
    tabController = TabController(length: 3, vsync: this);
  }

  void _deleteconversation() {
    setState(() {
      loading = true;
    });
    // final userid = FirebaseAuth.instance.currentUser!.uid;
    final firebasecollection =
        FirebaseFirestore.instance.collection('conversations');
    ref.read(deleteConversationStateProvider).forEach((element) async {
      // await firebasecollection.doc(element)
      //     .update({
      //   'users': FieldValue.arrayRemove([userid])
      // });
      ref.read(deleteConversationStateProvider).forEach((element) async {
        await firebasecollection.doc(element).delete();
      });
    });

    ref.read(deleteConversationStateProvider.notifier).resetdeletelist();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deletelist = ref.watch(deleteConversationStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: ref.watch(deleteConversationStateProvider).isEmpty
            ? const Text('ChatConnect')
            : Row(
                children: [
                  IconButton(
                      onPressed: () {
                        ref
                            .read(deleteConversationStateProvider.notifier)
                            .resetdeletelist();
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(ref
                      .watch(deleteConversationStateProvider)
                      .length
                      .toString()),
                ],
              ),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: deletelist.isEmpty
            ? [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.photo_camera)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search_sharp,
                      size: 30,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const SettingsPage()));
                    },
                    icon: const Icon(Icons.menu)),
              ]
            : [
                IconButton(
                    onPressed: _deleteconversation,
                    icon: const Icon(Icons.delete)),
              ],
        bottom: TabBar(
          controller: tabController,
          tabs: const <Widget>[
            Tab(
              child: Text('Chats'),
            ),
            Tab(
              child: Text('Status'),
            ),
            Tab(
              child: Text('Calls'),
            ),
          ],
        ),
      ),
      body: Column(children: [
        Offstage(
          offstage: !loading,
          child: const LinearProgressIndicator(),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: const <Widget>[
              Chats(),
              Status(),
              Calls(),
            ],
          ),
        ),
      ]),
    );
  }
}
