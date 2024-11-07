import 'package:chirp_frontend/models/styles.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_custom.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:chirp_frontend/main.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_emoji/flutter_emoji.dart';

import 'emoji_keyboard.dart';

/// Provides framework for the story emoji-posting modal.
/// This class updates the value inside the emoji entry box and pushes the data.
///
/// The emoji keyboard created by [EmojiKeyboard] is rendered offscreen by the
/// [sliding_up_panel.dart] package. It slides up when the user taps the emoji
/// entry box.
///
class MoodPostStory extends StatefulWidget with KeyboardCustomPanelMixin {
  /// Label for the main emoji selected on the previous page.
  final String mainEmojiLabel;

  /// Unicode value of the main emoji selected on the previous page.
  final String mainEmojiValue;

  MoodPostStory(
      {required Key key,
      required this.mainEmojiLabel,
      required this.mainEmojiValue})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _MoodPostStoryState(mainEmojiLabel, mainEmojiValue);

  @override
  ValueNotifier get notifier => notifier;
}

/// State class for [MoodPostStory].
class _MoodPostStoryState extends State<MoodPostStory> {
  var emojiParser = EmojiParser();
  var _isProcessing = false;

  /// Label for the main emoji selected on the previous page. Passed from
  /// [MoodPostStory] class.
  final String mainEmojiLabel;

  /// Unicode value of the main emoji selected on the previous page. Passed from
  /// [MoodPostStory] class.
  final String mainEmojiValue;

  /// A PanelController for sliding the emoji keyboard up and down.
  PanelController pc = PanelController();

  /// The FocusNode for the emoji entry box.
  // static final FocusNode _nodeText8 = FocusNode();

  /// The notifier for the emoji entry box. The value is initialized to an
  /// empty String. It is updated as the user enters emojis.
  final storyEmojis = ValueNotifier<String>('');

  /// The time the user posts their mood
  late DateTime timePosted;
  late double keyboardHeight;
  late double parallaxOffset;

  // Keyboard controllers
  final _scrollController = ScrollController();
  late final EmojiTextEditingController _controller;

  @override
  void initState() {
    _controller = EmojiTextEditingController(emojiTextStyle: storyEmojiStyle);
    super.initState();
    timePosted = DateTime.now();
    keyboardHeight = 256.0;
    parallaxOffset = 0.25;
  }

  /// The constructor for the state class.
  _MoodPostStoryState(this.mainEmojiLabel, this.mainEmojiValue);

  /// The emoij entry box.
  ///
  /// [context]: the BuildContext for the widget.
  Widget _inputField(context) {
    return TextField(
      contextMenuBuilder: (context, editableTextState) {
        final List<ContextMenuButtonItem> buttonItems =
            editableTextState.contextMenuButtonItems;
        buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
          return buttonItem.type == ContextMenuButtonType.paste;
        });
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: buttonItems,
        );
      },
      controller: _controller,
      scrollController: _scrollController,
      style: storyEmojiStyle,
      cursorHeight: 30,
      maxLines: 1,
      maxLength: 5,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.none,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.only(
          left: 16.0,
          bottom: 8.0,
          top: 8.0,
          right: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onTap: () {
        pc.open();
      },
    );
  }

  /// Prevents users from submitting a new post unless they
  /// enter at least one story emoji.
  Future<void> disableSubmission(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Whoa there!", style: h2),
          content: Text(message, style: h3),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pc.close();
      },
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, top: 40),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            body: SlidingUpPanel(
              maxHeight: keyboardHeight,
              minHeight: 0,
              isDraggable: false,
              controller: pc,
              parallaxEnabled: true,
              parallaxOffset: parallaxOffset,
              panel: EmojiKeyboard(controller: _controller),
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text("Want to share why?", style: h0),
                      Container(height: 10),
                      const Text("Enter up to five story emojis.", style: h3),
                      Container(height: 10),
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text: mainEmojiValue,
                                style: moodPostMainEmoji,
                              ),
                            ),
                            Text(mainEmojiLabel, style: h4)
                          ],
                        ),
                      ),
                      _inputField(context),
                      ElevatedButton(
                        style: colorElevatedButtonStyle,
                        onPressed: () {
                          // Pushes the user back to the home screen. Clears all
                          // previously pushed screens. Disabled if the user has
                          // not entered at least one story emoji.
                          if ((_controller.text == '')) {
                            disableSubmission(
                                'Please enter at least one story emoji.');
                          } else if (emojiParser.count(_controller.text) > 5) {
                            disableSubmission(
                                'Please enter at most five story emojis.');
                          } else {
                            if (_isProcessing) return;
                            _isProcessing = true;
                            apiProvider
                                .makePost(mainEmojiValue,
                                    _controller.value.text.toString())
                                .then((value) async {
                              // TODO: add notification plugin & schedule reminders
                              // TODO: await userData.update();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/timeline', (Route<dynamic> route) => false);
                            });
                          }
                        },
                        child: Text(
                          "Submit",
                          style: buttonText.copyWith(color: lightTextColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationPlugin {}
