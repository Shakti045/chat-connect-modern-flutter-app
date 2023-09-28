import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteConversationState extends StateNotifier<List<String>> {
  DeleteConversationState() : super([]);

  void rmoveoraddonversationid(String converastionid) {
    if (state.contains(converastionid)) {

      
      state = state.where((element) => element!=converastionid).toList();

    } else {
    
      state = [...state, converastionid];
    }
  }

  void resetdeletelist() {
    state = [];
  }
}

final deleteConversationStateProvider =
    StateNotifierProvider<DeleteConversationState, List<String>>(
        (ref) => DeleteConversationState());
