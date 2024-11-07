import 'package:chirp_frontend/models/styles.dart';
import 'package:chirp_frontend/screens/post_modal_main/moods.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

/// Provides framework for the first page of mood-posting modal.
/// Mood emojis and next button are formatted via moods.dart.
class MoodPostMain extends StatefulWidget {
  const MoodPostMain({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MoodPostMain();
  }
}

/// State class for [MoodPostMain].
class _MoodPostMain extends State<MoodPostMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, top: 40),
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("How are you feeling?", style: h0),
                Container(height: 10),
                const Text("Choose an emoji to represent your mood.",
                    style: h3),
                Container(height: 10),
                MainMoods(key: UniqueKey()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
