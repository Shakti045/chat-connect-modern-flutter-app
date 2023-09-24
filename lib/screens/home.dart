import 'package:chatconnect/provider/contactsprovider.dart';
import 'package:chatconnect/screens/settings.dart';
import 'package:chatconnect/widgets/calls.dart';
import 'package:chatconnect/widgets/chats.dart';
import 'package:chatconnect/widgets/status.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatConnect'),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.photo_camera)),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search_sharp,
                size: 30,
              )),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const SettingsPage()));
              },
              icon: const Icon(Icons.menu)),
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
      body: TabBarView(
        controller: tabController,
        children: const <Widget>[
          Chats(),
          Status(),
          Calls(),
        ],
      ),
    );
  }
}
