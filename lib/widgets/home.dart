import 'package:chirp_frontend/models/styles.dart';
import 'package:chirp_frontend/screens/timeline/timeline.dart';
import 'package:chirp_frontend/screens/profile/profile.dart';
import 'package:chirp_frontend/screens/post_modal_main/main_mood_page.dart';
import 'package:chirp_frontend/singletons/user_data.dart';
import 'package:flutter/material.dart';

/// The default display.
///
/// Has a bottom navigation bar to switch between Timeline and Profile views.
/// Nav bar includes a button for creating new posts.
class Home extends StatefulWidget {
  const Home({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

/// The state class for [Home].
class _HomeState extends State<Home> {
  /// The pages represented by the bottom nav bar.
  ///
  /// Default display starts with Timeline.
  late List<Widget> _pages;

  /// Switches display between pages in the bottom nav bar.
  ///
  /// Defaults to 0 index (Timeline).
  late int _currentIndex;

  /// Indicates if current display is on Timeline.
  ///
  /// Defaults true.
  late bool _timelinePressed;

  /// Indicates if current display is on Profile.
  ///
  /// Defaults false.
  late bool _profilePressed;

  @override
  void initState() {
    super.initState();
    _pages = [
      Timeline(key: UniqueKey()),
      Profile(key: UniqueKey()),
    ];
    _timelinePressed = true;
    _profilePressed = false;
    _currentIndex = userData.data?['group_mode'] == "full" ? 0 : 1;
    // TODO: add notifications
  }

  /// Changes [_currentIndex] to reflect the index of the current page.
  ///
  /// index: represents the page index in [_pages] to switch to.
  void changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// Opens the mood-posting modal from the bottom of the screen.
  Route<dynamic> _openModal() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MoodPostMain(key: UniqueKey()),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      // Button to create a new post.
      floatingActionButtonLocation: userData.data?['group_mode'] == 'full'
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).push(_openModal());
        },
        child: const Icon(Icons.add, size: 20, color: Colors.white),
      ),
      bottomNavigationBar: userData.data?['group_mode'] == 'full'
          ? BottomAppBar(
              shape: const CircularNotchedRectangle(),
              color: navbarColor,
              surfaceTintColor: Colors.white,
              notchMargin: 4,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Button for displaying timeline page.
                  TextButton(
                    style: navigationButtonStyle,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.forum,
                          size: 18,
                          color: _timelinePressed ? Colors.black : Colors.grey,
                        ),
                        const Text("Timeline", style: h5)
                      ],
                    ),
                    onPressed: () {
                      // Switches to timeline page when pressed.
                      changeIndex(0);
                      _timelinePressed = true;
                      _profilePressed = false;
                    },
                  ),

                  // Button for displaying profile page.
                  TextButton(
                    style: navigationButtonStyle,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          size: 18,
                          color: _profilePressed ? Colors.black : Colors.grey,
                        ),
                        const Text("Profile", style: h5)
                      ],
                    ),
                    onPressed: () {
                      // Switches to profile page when pressed.
                      changeIndex(1);
                      _timelinePressed = false;
                      _profilePressed = true;
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
