import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactState extends StateNotifier<List<Contact>> {
  ContactState() : super([]);

  void setcontacts(List<Contact> contacts) {
    state = contacts;
  }
}

final contactProvider = StateNotifierProvider<ContactState,List<Contact>>((ref) => ContactState());
