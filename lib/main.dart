import 'dart:io';

// import network, models, & data
import 'package:chirp_frontend/network/api_provider.dart';
import 'package:chirp_frontend/models/styles.dart';
import 'singletons/user_data.dart';

// import screens
import 'package:chirp_frontend/screens/login/login.dart';
import 'package:chirp_frontend/screens/onboarding/onboarding.dart';
import 'package:chirp_frontend/screens/consent_form/consent_form.dart';
import 'package:chirp_frontend/screens/settings/settings.dart';
import 'package:chirp_frontend/widgets/home.dart';

// import packages
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// An instance of the API provider. Used for cookies and calling endpoints
ApiProvider apiProvider = ApiProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // loads information from configuration file
  await GlobalConfiguration().loadFromAsset("app_settings");

  // loads dotenv
  await dotenv.load(fileName: "assets/.env");

  // gets path for document where cookies are stored
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  // create a new instance of the ApiProvider class for connecting endpoints
  apiProvider = ApiProvider();

  // add persisting cookies
  var cookieJar =
      PersistCookieJar(storage: FileStorage("$appDocPath/.cookies/"));
  apiProvider.addCookieJar(cookieJar);

  // fetch userData
  await userData.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chirp",
      theme: ThemeData(
        primarySwatch: mainColor,
        appBarTheme: const AppBarTheme(
          color: mainColor,
          titleTextStyle: h1,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: mainColor,
          foregroundColor: Colors.white,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(surfaceTintColor: mainColor),
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      home: userData.id == null ? ConsentForm(key: UniqueKey()) : const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/onboarding': (context) => Onboarding(key: UniqueKey()),
        '/timeline': (context) => Home(key: UniqueKey()),
        '/settings': (context) => Settings(key: UniqueKey(), payload: ''),
      },
    );
  }
}
