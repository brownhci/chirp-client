import 'package:chirp_frontend/screens/post_modal_main/main_mood_page.dart';
import 'package:flutter/cupertino.dart';

/// Placeholder class until user triggers the mood-posting modal.
class MoodPost extends StatelessWidget {
  const MoodPost({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MoodPostMain(key: UniqueKey());
  }
}
