import 'package:chirp_frontend/main.dart';
import 'package:chirp_frontend/widgets/custom_icons.dart';
import 'package:chirp_frontend/models/styles.dart';
import 'package:chirp_frontend/singletons/user_data.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

/// The onboarding flow.
class Onboarding extends StatefulWidget {
  const Onboarding({required Key key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

/// The state class for [Onboarding].
class _OnboardingState extends State<Onboarding> {
  /// Key for the introduction screen.
  final introKey = GlobalKey<IntroductionScreenState>();
  String error = "";
  TextEditingController groupCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  /// Navigates to the consent form screen at the end of onboarding.
  ///
  /// context: the BuildContext at the end of onboarding.
  void _onIntroEnd(context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/timeline',
      (Route<dynamic> route) => false,
    );
  }

  /// Renders the image at each point during onboarding.
  ///
  /// assetName: the name of the image. Located in the assets folder.
  Align _buildImage(String assetName) {
    return Align(
      alignment: Alignment.bottomCenter,
      // child: Image.asset('assets/$assetName.png', height: 250.0),
      child: Image.asset('assets/$assetName.png', width: 300.0),
    );
  }

  Future<void> groupErrorMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("One moment...", style: h2),
          content: Text(
            error,
            style: h3,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Object containing styling for each page of onboarding.
    var pageDecoration = PageDecoration(
      titleTextStyle: h1.copyWith(fontSize: 40),
      bodyTextStyle: h3,
      bodyPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      pageColor: Colors.white,
      imagePadding: const EdgeInsets.only(bottom: 20),
    );

    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      key: introKey,
      pages: [
        PageViewModel(
          titleWidget: const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
          bodyWidget: introPageContent(),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
          bodyWidget: flexiblePageLayout(
            pageTitle: 'Share your feelings anonymously.',
            pageDescription:
                'Choose from a wide selection of emojis to describe how you feel. Don\'t worry; all posts are completely anonymous.',
            pageContent: _buildImage('chirp_onboarding_1'),
            introKey: introKey,
            showBottomButton: true,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
          bodyWidget: flexiblePageLayout(
            pageTitle: "Join a group with friends",
            pageDescription: '',
            pageContent: joinGroupPageContent(introKey),
            introKey: introKey,
            showBottomButton: false,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
          bodyWidget: flexiblePageLayout(
            pageTitle: 'Reflect on your mood.',
            pageDescription:
                'Get a glimpse into your headspace. The profile page keeps a log of your posts, just like a mood tracker.',
            pageContent: _buildImage('chirp_onboarding_2'),
            introKey: introKey,
            showBottomButton: true,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
          bodyWidget: welcomePageContent(username: "${userData.data?['name']}"),
          decoration: pageDecoration,
        ),
      ],
      showNextButton: false,
      showDoneButton: false,
      onDone: () => _onIntroEnd(context),
      dotsDecorator: const DotsDecorator(
        size: Size(8.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeColor: mainColor,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  Widget flexiblePageLayout({
    required String pageTitle,
    required String pageDescription,
    required Widget pageContent,
    required GlobalKey<IntroductionScreenState> introKey,
    required bool showBottomButton,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: [
          const Icon(
            CustomIcons.chirp,
            size: 25,
            color: mainColor,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
            child: Text(
              pageTitle,
              style: const TextStyle(
                fontSize: 35,
                height: 1,
                fontWeight: FontWeight.w400,
                fontFamily: "MarkaziText",
              ),
              textAlign: TextAlign.center,
            ),
          ),
          pageContent,
          Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Text(
              pageDescription,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: "NunitoSans",
              ),
              textAlign: TextAlign.center,
            ),
          ),
          showBottomButton
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: onboardingButton(
                    buttonText: "Next",
                    onPressed: () {
                      introKey.currentState?.next();
                    },
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget joinGroupPageContent(GlobalKey<IntroductionScreenState> introKey) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          "A group is how you connect with friends and provide emotional support",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "NunitoSans",
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 100.0,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Group Code",
          ),
          controller: groupCodeController,
          onChanged: (text) {
            setState(() {
              error = "";
            });
          },
        ),
        const SizedBox(
          height: 40.0,
        ),
        onboardingButton(
          buttonText: 'Join group',
          onPressed: () async {
            try {
              if (groupCodeController.text != "") {
                await apiProvider.joinGroup(groupCodeController.text);
                await userData.update();
                introKey.currentState?.next();
              } else {
                error = "You must enter a group code to join a group!";
                groupErrorMessage();
              }
            } catch (e) {
              setState(
                () {
                  error = "You must enter a valid group code!";
                  groupErrorMessage();
                },
              );
            }
          },
        ),
        const Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)),
        Text.rich(
          TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text: 'Or ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "NunitoSans",
                ),
              ),
              TextSpan(
                  text: 'skip for now.',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "NunitoSans",
                    color: mainColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      introKey.currentState?.next();
                    }),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        const Text(
          "You can join a new group or create your own at any time in settings.",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "NunitoSans",
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget introPageContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            CustomIcons.chirp,
            size: 40,
            color: mainColor,
          ),
          const SizedBox(height: 25),
          const Text(
            'Chirp is an emoji-only, social app.',
            style: TextStyle(
              fontSize: 35,
              height: 1,
              fontWeight: FontWeight.w400,
              fontFamily: "MarkaziText",
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          onboardingButton(
            buttonText: "Create account",
            onPressed: () {
              introKey.currentState?.next();
            },
          )
        ],
      ),
    );
  }

  Widget welcomePageContent({required String username}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 70),
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            CustomIcons.chirp,
            size: 70,
            color: mainColor,
          ),
          const SizedBox(height: 30),
          Text(
            'Welcome to Chirp, \n$username.',
            style: const TextStyle(
              fontSize: 35,
              height: 1,
              fontWeight: FontWeight.w400,
              fontFamily: "MarkaziText",
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            "This is your unique username. Don't worry, your real identity is completely anonymous.",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "NunitoSans",
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.bottomCenter,
            child: onboardingButton(
              buttonText: "Let's go",
              onPressed: () => _onIntroEnd(context),
            ),
          )
        ],
      ),
    );
  }

  Widget onboardingButton(
      {required String buttonText, required void Function()? onPressed}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: mainColor,
          minimumSize: const Size(double.infinity, 40),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: "NunitoSans",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
