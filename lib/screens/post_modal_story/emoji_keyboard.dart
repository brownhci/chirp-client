import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:chirp_frontend/models/styles.dart';
import 'custom_emoji_set.dart';

/// Example for EmojiPicker with Google Emoji Fonts
class EmojiKeyboard extends StatefulWidget {
  const EmojiKeyboard({super.key, required this.controller});

  final TextEditingController controller;

  @override
  _EmojiKeyboardState createState() => _EmojiKeyboardState();

  // TODO: replace everywhere?
  // @override
  // State<StatefulWidget> createState() {
  //   return _EmojiKeyboardState();
  // }
}

class _EmojiKeyboardState extends State<EmojiKeyboard> {
  late final TextStyle _textStyle;
  final bool isApple = [TargetPlatform.iOS, TargetPlatform.macOS]
      .contains(foundation.defaultTargetPlatform);

  @override
  void initState() {
    final fontSize = 24 * (isApple ? 1.2 : 1.0);
    // 1. Define Custom Font & Text Style
    _textStyle = DefaultEmojiTextStyle.copyWith(
      fontSize: fontSize,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Offstage(
          offstage: false,
          child: EmojiPicker(
            textEditingController: widget.controller,
            config: Config(
              height: 256,
              emojiSet: customEmojiSet,
              checkPlatformCompatibility: true,
              emojiTextStyle: _textStyle,
              swapCategoryAndBottomBar: true,
              emojiViewConfig: const EmojiViewConfig(),
              skinToneConfig: const SkinToneConfig(),
              categoryViewConfig: const CategoryViewConfig(),
              bottomActionBarConfig: const BottomActionBarConfig(
                backgroundColor: mainColor,
                buttonColor: mainColor,
              ),
              searchViewConfig: const SearchViewConfig(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
