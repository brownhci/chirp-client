import 'package:chirp_frontend/models/styles.dart';
import 'package:chirp_frontend/singletons/user_data.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class CreateGroupForm extends StatefulWidget {
  final bool fromOnboarding;

  const CreateGroupForm({required Key key, required this.fromOnboarding})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateGroupFormState();
  }
}

class _CreateGroupFormState extends State<CreateGroupForm> {
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
                'Create a name for your group',
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
                    await apiProvider.createGroup(groupCodeController.text);
                    await apiProvider.joinGroup(groupCodeController.text);
                    await userData.update();
                    isFromOnboarding
                        ? Navigator.pop(context)
                        : Navigator.pushNamedAndRemoveUntil(context,
                            '/timeline', (Route<dynamic> route) => false);
                  } catch (e) {
                    setState(
                      () {
                        error = "Name already taken";
                      },
                    );
                  }
                },
                child: Text(
                  "Submit group name",
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
