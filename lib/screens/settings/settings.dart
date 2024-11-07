import 'package:chirp_frontend/models/styles.dart';
import 'package:chirp_frontend/screens/login/login.dart';
import 'package:chirp_frontend/singletons/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// screens
import 'package:chirp_frontend/screens/group_form/create_group_form.dart';
import 'package:chirp_frontend/screens/group_form/group_form.dart';

import '../../main.dart';

/// The Settings page.
class Settings extends StatefulWidget {
  /// The notification payload.
  final String payload;

  const Settings({required Key key, required this.payload}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

/// The state class for [Settings]
class _SettingsState extends State<Settings> {
  /// Toggles notifications.
  ///
  /// Defaults to true.
  // TODO: add _alertOn for use with notifications settings

  /// Checks whether the user is logged in.
  ///
  /// Defaults to true.
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    isLoggedIn = true;
    // TODO: add alertOn default initialization
    // TODO: add notificationPlugin
  }

  // TODO: add confirmation that notifications were received

  /// Pushes the payload to the Settings page.
  void onNotificationClick(String payload) {
    print('Payload $payload');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Settings(payload: payload, key: UniqueKey());
        },
      ),
    );
  }

  void onJoinGroupClick() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => GroupForm(
          key: UniqueKey(),
          fromOnboarding: false,
        ),
      ),
    );
  }

  void onCreateGroupClick() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => CreateGroupForm(
          key: UniqueKey(),
          fromOnboarding: false,
        ),
      ),
    );
  }

  /// Sends confirmation alert when logging out.
  Future<void> confirmLogout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out?', style: h2),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("You'll need to sign back in.", style: h3),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Stay',
                style: h3.copyWith(color: fadedTextColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Log out',
                style: h3.copyWith(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                // TODO: await apiProvider.logoutUser(); -- confirm why this was commented out
                print('pressed log out button');
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Login(),
                  ),
                  ModalRoute.withName('/login'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // TODO: add widget for notifications section in settings (currently disabled?)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: const BackButton(color: mainTextColor),
        backgroundColor: backgroundColor,
        title: Text(
          'Settings',
          style: pageHeader.copyWith(color: mainTextColor),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "User ID: ${userData.id}",
                      style: h3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "User Group: ${userData.data?['group']}",
                      style: h3,
                    ),
                  ),
                ]),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 20),
              child: Text("Group Settings", style: h2),
            ),
            (userData.data?["group"] != null)
                ? SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 0,
                      child: TextButton(
                        style: settingsButtonStyle,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Leave Group',
                                style: h3,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward, // Arrow icon
                              color: mainTextColor,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          await apiProvider.leaveGroup();
                          await userData.update();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Login()),
                            ModalRoute.withName('/login'),
                          );
                        },
                      ),
                    ),
                  )
                : Column(children: [
                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 0,
                        child: TextButton(
                          style: settingsButtonStyle,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Create Group',
                                  style: h3,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward, // Arrow icon
                                color: mainTextColor,
                              ),
                            ],
                          ),
                          onPressed: () => {onCreateGroupClick()},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 0,
                        child: TextButton(
                          style: settingsButtonStyle,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Join Group',
                                  style: h3,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward, // Arrow icon
                                color: mainTextColor,
                              ),
                            ],
                          ),
                          onPressed: () => {onJoinGroupClick()},
                        ),
                      ),
                    ),
                  ]),

            // Section with account settings.
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 20),
              child: Text("Account", style: h2),
            ),
            SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 0,
                // The logout button.
                child: TextButton(
                  style: settingsButtonStyle,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Log Out',
                          style: h3,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward, // Arrow icon
                        color: mainTextColor,
                      ),
                    ],
                  ),
                  onPressed: () {
                    confirmLogout();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
