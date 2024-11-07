import 'dart:async';
import 'package:chirp_frontend/models/styles.dart';
import 'package:chirp_frontend/screens/login/login.dart';
import 'package:chirp_frontend/singletons/user_data.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

/// The Consent Form page.
class ConsentForm extends StatefulWidget {
  const ConsentForm({required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ConsentFormState();
  }
}

/// The state class for [ConsentForm]
class _ConsentFormState extends State<ConsentForm> {
  /// Controls the user's ability to scroll down the page.
  final _scrollController = ScrollController();

  /// Detects whether the user is at the bottom.
  var atBottom = false;

  _ConsentFormState();

  @override
  void initState() {
    super.initState();
  }

  /// Creates a new account if the user agrees to the consent form
  Future<void> createNewUser() async {
    userData.id = await apiProvider.createAccount(userData.deviceId);
    await userData.update();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Login(onboard: true)),
        (Route<dynamic> route) => false);
  }

  /// Loads the consent form text file.
  ///
  /// context: the BuildContext of the current page.
  Future<String> loadAsset(BuildContext context) async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/consent.txt');
  }

  /// Creates an alert preventing the user from proceeding to next page.
  ///
  /// User must be at the bottom of the page for this to be disabled.
  Future<void> disableAgreement() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("One moment...", style: h2),
          content: Text(
            'Please read the user agreement before continuing.',
            style: h3,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Inelegant solution for consent forms and oversized screens (run pixel check on timer)
    // TODO: check scroll position on render
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_scrollController.hasClients) {
          setState(
            () {
              if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent) {
                atBottom = true;
              } else {
                atBottom = false;
              }
            },
          );
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User Agreement", style: pageHeader),
        elevation: 0.0,
      ),

      // Loads the text file.
      body: FutureBuilder(
        future: loadAsset(context),
        builder: (context, snapshot) {
          // Creates a scrollListener that detects when the user is at the
          // bottom of the page.
          // only checks for end of the consent form after a user begins scrolling
          scrollListener() {
            setState(
              () {
                if (_scrollController.position.pixels ==
                    _scrollController.position.maxScrollExtent) {
                  atBottom = true;
                } else {
                  atBottom = false;
                }
              },
            );
          }

          // Attaches the listener to the scrollController to detect when the
          // user is at the bottom of the screen.
          _scrollController.addListener(scrollListener);

          // Renders the consent form if text loads successfully.
          if (snapshot.hasData) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text(snapshot.data!, style: h3),
              ),
            );
            // Returns the error if the text does not load successfully
          } else if (snapshot.hasError) {
            return Text("error detected: $snapshot.error");
          }
          // Returns a loading symbol otherwise
          return const CircularProgressIndicator();
        },
      ),
      // The bottom area where the user agrees to the user agreement
      bottomNavigationBar: BottomAppBar(
        color: backgroundColor,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 0),
          child: ElevatedButton(
            style:
                atBottom ? colorElevatedButtonStyle : grayElevatedButtonStyle,
            onPressed: () {
              // If the user is at the bottom, the button routes the
              // user to the timeline page
              if (atBottom) {
                createNewUser();
              } else {
                disableAgreement();
              }
            },
            child: Text(
              "I agree",
              style: h3.copyWith(
                color: atBottom ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
