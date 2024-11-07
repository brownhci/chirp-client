import 'package:chirp_frontend/models/styles.dart';
import 'package:chirp_frontend/screens/post_modal_story/story_emoji_page.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Provides framework for main emojis on the first page of the mood-posting
/// modal. Includes route for pushing selected data to the next page.
class MainMoods extends StatefulWidget {
  const MainMoods({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainMoodsState();
  }
}

/// State class for [MainMoods].
class _MainMoodsState extends State<MainMoods> {
  /// Label for the main emoji.
  String _mainEmojiLabel = "initial";

  /// Unicode value of the main emoji.
  String _mainEmojiValue = "";

  /// Toggles the Next button. Defaults to false (button disabled).
  bool next = false;

  /// The Unicode value for each mood. Includes a boolean indicating
  /// if the mood was selected.
  String satisfiedCode = '\u{1f642}';
  bool satisfiedSelected = false;
  String sadCode = '\u{1f622}';
  bool sadSelected = false;
  String happyCode = '\u{1f60a}';
  bool happySelected = false;
  String scaredCode = '\u{1f630}';
  bool scaredSelected = false;
  String tiredCode = '\u{1f971}';
  bool tiredSelected = false;
  String boredCode = '\u{1f610}';
  bool boredSelected = false;
  String excitedCode = '\u{1f604}';
  bool excitedSelected = false;
  String angryCode = '\u{1f621}';
  bool angrySelected = false;
  String stressedCode = '\u{1f623}';
  bool stressedSelected = false;

  /// Function toggling the state of the Satisfied mood.
  /// When the corresponding button is pressed, it calls this function to
  /// select or deselect the mood.
  Future<void> _toggleSatisfied() async {
    setState(() {
      // Checks if Satisfied is already selected.
      // If so, the Next button is deselected. If not, Next is selected.
      if (satisfiedSelected & next) {
        next = false;
      } else {
        next = true;
      }
      // Toggles the Satisfied mood.
      satisfiedSelected = !satisfiedSelected;
      // All other moods are deselected.
      sadSelected = happySelected = scaredSelected = tiredSelected =
          boredSelected =
              excitedSelected = angrySelected = stressedSelected = false;
      // Changes main emoji data to corresponding mood.
      _mainEmojiLabel = 'Satisfied';
      _mainEmojiValue = satisfiedCode;
    });
  }

  /// Function toggling the state of the Sad mood.
  /// When the corresponding button is pressed, it calls this function to
  /// select or deselect the mood.
  Future<void> _toggleSad() async {
    setState(() {
      // Checks if Sad is already selected.
      // If so, the Next button is deselected. If not, Next is selected.
      if (sadSelected & next) {
        next = false;
      } else {
        next = true;
      }
      // Toggles the Sad mood.
      sadSelected = !sadSelected;
      // All other moods are deselected.
      satisfiedSelected = happySelected = scaredSelected = tiredSelected =
          boredSelected =
              excitedSelected = angrySelected = stressedSelected = false;
      // Changes main emoji data to corresponding mood.
      _mainEmojiLabel = 'Sad';
      _mainEmojiValue = sadCode;
    });
  }

  /// Function toggling the state of the Happy mood.
  /// When the corresponding button is pressed, it calls this function to
  /// select or deselect the mood.
  Future<void> _toggleHappy() async {
    setState(() {
      // Checks if Happy is already selected.
      // If so, the Next button is deselected. If not, Next is selected.
      if (happySelected & next) {
        next = false;
      } else {
        next = true;
      }
      // Toggles the Happy mood.
      happySelected = !happySelected;
      // All other moods are deselected.
      satisfiedSelected = sadSelected = scaredSelected = tiredSelected =
          boredSelected =
              excitedSelected = angrySelected = stressedSelected = false;
      // Changes main emoji data to corresponding mood.
      _mainEmojiLabel = 'Happy';
      _mainEmojiValue = happyCode;
    });
  }

  /// Function toggling the state of the Scared mood.
  /// When the corresponding button is pressed, it calls this function to
  /// select or deselect the mood.
  Future<void> _toggleScared() async {
    setState(() {
      // Checks if Scared is already selected.
      // If so, the Next button is deselected. If not, Next is selected.
      if (scaredSelected & next) {
        next = false;
      } else {
        next = true;
      }
      // Toggles the Scared mood.
      scaredSelected = !scaredSelected;
      // All other moods are deselected.
      satisfiedSelected = sadSelected = happySelected = tiredSelected =
          boredSelected =
              excitedSelected = angrySelected = stressedSelected = false;
      // Changes main emoji data to corresponding mood.
      _mainEmojiLabel = 'Scared';
      _mainEmojiValue = scaredCode;
    });
  }

  /// Function toggling the state of the Tired mood.
  /// When the corresponding button is pressed, it calls this function to
  /// select or deselect the mood.
  Future<void> _toggleTired() async {
    setState(() {
      // Checks if Tired is already selected.
      // If so, the Next button is deselected. If not, Next is selected.
      if (tiredSelected & next) {
        next = false;
      } else {
        next = true;
      }
      // Toggles the Tired mood.
      tiredSelected = !tiredSelected;
      // All other moods are deselected.
      satisfiedSelected = sadSelected = happySelected = scaredSelected =
          boredSelected =
              excitedSelected = angrySelected = stressedSelected = false;
      // Changes main emoji data to corresponding mood.
      _mainEmojiLabel = 'Tired';
      _mainEmojiValue = tiredCode;
    });
  }

  /// Function toggling the state of the Bored mood.
  /// When the corresponding button is pressed, it calls this function to
  /// select or deselect the mood.
  Future<void> _toggleBored() async {
    setState(() {
      // Checks if Bored is already selected.
      // If so, the Next button is deselected. If not, Next is selected.
      if (boredSelected & next) {
        next = false;
      } else {
        next = true;
      }
      // Toggles the Bored mood.
      boredSelected = !boredSelected;
      // All other moods are deselected.
      satisfiedSelected = sadSelected = happySelected = scaredSelected =
          tiredSelected =
              excitedSelected = angrySelected = stressedSelected = false;
      // Changes main emoji data to corresponding mood.
      _mainEmojiLabel = 'Bored';
      _mainEmojiValue = boredCode;
    });
  }

  /// Function toggling the state of the Excited mood.
  /// When the corresponding button is pressed, it calls this function to
  /// select or deselect the mood.
  Future<void> _toggleExcited() async {
    setState(() {
      // Checks if Excited is already selected.
      // If so, the Next button is deselected. If not, Next is selected.
      if (excitedSelected & next) {
        next = false;
      } else {
        next = true;
      }
      // Toggles the Excited mood.
      excitedSelected = !excitedSelected;
      // All other moods are deselected.
      satisfiedSelected = sadSelected = happySelected = scaredSelected =
          tiredSelected =
              boredSelected = angrySelected = stressedSelected = false;
      // Changes main emoji data to corresponding mood.
      _mainEmojiLabel = 'Excited';
      _mainEmojiValue = excitedCode;
    });
  }

  /// Function toggling the state of the Angry mood.
  /// When the corresponding button is pressed, it calls this function to
  /// select or deselect the mood.
  Future<void> _toggleAngry() async {
    setState(() {
      // Checks if Angry is already selected.
      // If so, the Next button is deselected. If not, Next is selected.
      if (angrySelected & next) {
        next = false;
      } else {
        next = true;
      }
      // Toggles the Angry mood.
      angrySelected = !angrySelected;
      // All other moods are deselected.
      satisfiedSelected = sadSelected = happySelected = scaredSelected =
          tiredSelected =
              boredSelected = excitedSelected = stressedSelected = false;
      // Changes main emoji data to corresponding mood.
      _mainEmojiLabel = 'Angry';
      _mainEmojiValue = angryCode;
    });
  }

  /// Function toggling the state of the Stressed mood.
  /// When the corresponding button is pressed, it calls this function to
  /// select or deselect the mood.
  Future<void> _toggleStressed() async {
    setState(() {
      // Checks if Stressed is already selected.
      // If so, the Next button is deselected. If not, Next is selected.
      if (stressedSelected & next) {
        next = false;
      } else {
        next = true;
      }
      // Toggles the Stressed mood.
      stressedSelected = !stressedSelected;
      // All other moods are deselected.
      satisfiedSelected = sadSelected = happySelected = scaredSelected =
          tiredSelected =
              boredSelected = excitedSelected = angrySelected = false;
      // Changes main emoji data to corresponding mood.
      _mainEmojiLabel = 'Stressed';
      _mainEmojiValue = stressedCode;
    });
  }

  /// Container for individual moods. Each Container holds a toggle button
  /// and a label for that mood.
  Container mood(
      String charCode, bool moodSelected, Function toggleFunc, String label) {
    return Container(
      width: 105,
      height: 105,
      margin: const EdgeInsets.all(8),
      decoration: moodSelected
          ? BoxDecoration(
              border: Border.all(color: mainColor),
              borderRadius: BorderRadius.circular(15))
          : BoxDecoration(border: Border.all(color: Colors.transparent)),
      child: TextButton(
        onPressed: () {
          toggleFunc();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(text: TextSpan(text: charCode, style: moodPostMainEmoji)),
            Text(label, style: h4)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            mood(satisfiedCode, satisfiedSelected, _toggleSatisfied,
                "Satisfied"),
            mood(sadCode, sadSelected, _toggleSad, "Sad"),
            mood(happyCode, happySelected, _toggleHappy, "Happy")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            mood(scaredCode, scaredSelected, _toggleScared, "Scared"),
            mood(tiredCode, tiredSelected, _toggleTired, "Tired"),
            mood(boredCode, boredSelected, _toggleBored, "Bored")
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            mood(excitedCode, excitedSelected, _toggleExcited, "Excited"),
            mood(angryCode, angrySelected, _toggleAngry, "Angry"),
            mood(stressedCode, stressedSelected, _toggleStressed, "Stressed")
          ],
        ),
        Container(height: 20),
        ElevatedButton(
          style: next ? colorElevatedButtonStyle : grayElevatedButtonStyle,

          // Pushes the second page of the mood-posting modal. Passes selected
          // mood data to the next page through mainEmoji field, which is set
          // in each of the corresponding _toggle functions.
          onPressed: () {
            if (next) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MoodPostStory(
                    mainEmojiLabel: _mainEmojiLabel,
                    mainEmojiValue: _mainEmojiValue,
                    key: UniqueKey(),
                  ),
                ),
              );
            }
          },
          child: Text(
            "Next",
            style: h3.copyWith(
              color: next ? Colors.white : Colors.black
            ),
          ),
        )
      ],
    );
  }
}
