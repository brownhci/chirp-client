import '../../main.dart';
import 'package:chirp_frontend/models/styles.dart';
import 'package:chirp_frontend/widgets/custom_icons.dart';
import 'package:flutter/material.dart';

/// The Login page.
class Login extends StatefulWidget {
  final bool onboard;

  const Login({super.key, this.onboard = false});

  @override
  State<StatefulWidget> createState() {
    return _LoginState(onboard);
  }
}

/// State class for [Login].
class _LoginState extends State<Login> {
  // Result of querying the backend for the login notification
  late Future<dynamic> _loginNotification;

  /// Should onboard after login
  bool onboard;

  _LoginState(this.onboard);

  @override
  void initState() {
    super.initState();
    _loginNotification = apiProvider.fetchLoginNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                const Icon(CustomIcons.chirp, size: 35, color: Colors.white),
                const Text('Chirp', style: loginTitleStyle),
                FutureBuilder(
                  future: _loginNotification,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(height: 15);
                    } else if (snapshot.hasError) {
                      return const SizedBox(
                          height: 15); // use ${snapshot.error} to print error
                    } else {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Text(
                          '${snapshot.data}',
                          style: loginNotificationStyle,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            Column(
              children: <Widget>[
                ElevatedButton(
                  style: whiteElevatedButtonStyle,
                  onPressed: () {
                    /// Logs in users to the home page if they have an account; pushes to consent form otherwise
                    void login() async {
                      // TODO: modify onboarding for partial group
                      // account found and login successful; push to home (timeline)
                      Navigator.of(context).pushReplacementNamed(
                          onboard ? '/onboarding' : '/timeline');
                    }

                    login();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Sign in',
                        style: h3Bold,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
