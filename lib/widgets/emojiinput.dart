import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

class EmojiInput extends StatefulWidget {
  const EmojiInput(this.messageinput, {super.key});
  final TextEditingController messageinput;

  @override
  State<EmojiInput> createState() => _EmojiInputState();
}

class _EmojiInputState extends State<EmojiInput> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: EmojiPicker(
      
        onBackspacePressed: () {
         
        },
        textEditingController:
            widget.messageinput, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: Config(
          columns: 7,
          emojiSizeMax: 32 *
              (foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? 1.30
                  : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Category.RECENT,
          bgColor: const Color.fromARGB(255, 53, 57, 55).withOpacity(0.5),
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          backspaceColor: Colors.blue,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          recentTabBehavior: RecentTabBehavior.RECENT,
          recentsLimit: 28,
          noRecents: const Text(
            'No Recents',
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ), // Needs to be const Widget
          loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.MATERIAL,
        ),
      ),
    );
  }
}
