import 'package:chirp_frontend/models/styles.dart';
import 'package:flutter/material.dart';
import '../../singletons/user_data.dart';
import '../../main.dart';

class GroupForm extends StatefulWidget {
  final bool onboard;
  final bool fromOnboarding;

  const GroupForm(
      {required Key key, this.onboard = false, required this.fromOnboarding})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GroupFormState(this.onboard);
  }
}

class _GroupFormState extends State<GroupForm> {
  /// Should onboard after login
  bool onboard;

  _GroupFormState(this.onboard);

  TextEditingController groupCodeController = TextEditingController();

  String error = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFromOnboarding = widget.fromOnboarding;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Group Selection",
          style: pageHeader,
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Join group by group name',
                textDirection: TextDirection.ltr,
                style: h2,
              ),
              TextFormField(
                controller: groupCodeController,
                onChanged: (text) {
                  setState(() {
                    error = "";
                  });
                },
              ),
              const SizedBox(
                height: 25.0,
              ),
              ElevatedButton(
                style: colorElevatedButtonStyle,
                onPressed: () async {
                  try {
                    await apiProvider.joinGroup(groupCodeController.text);
                    await userData.update();
                    isFromOnboarding
                        ? Navigator.pop(context)
                        : Navigator.pushNamedAndRemoveUntil(context,
                            '/timeline', (Route<dynamic> route) => false);
                  } catch (e) {
                    setState(
                      () {
                        error = "Invalid group code";
                      },
                    );
                  }
                },
                child: Text(
                  "Submit group code",
                  style: h3.copyWith(color: lightTextColor),
                ),
              ),
              Text(
                error,
                style: h3.copyWith(color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
