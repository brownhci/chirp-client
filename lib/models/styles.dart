import 'package:flutter/material.dart';

const mainColor = Colors.indigo;
const accentColor = Colors.cyan;

const backgroundColor = Color(0xfff3f3f3);
const cardColor = Colors.white;
const navbarColor = Color(0xffE8EAF6);

const mainTextColor = Colors.black;
const lightTextColor = Colors.white;
const fadedTextColor = Colors.grey;

// GENERAL TEXT STYLING

const TextStyle h0 = TextStyle(
  fontSize: 38, color: mainTextColor, fontWeight: FontWeight.w500, fontFamily: "MarkaziText");

const TextStyle h1 = TextStyle(fontSize: 18, fontFamily: "MarkaziText");

const TextStyle h2 = TextStyle(
    fontSize: 24, fontWeight: FontWeight.w400, fontFamily: "MarkaziText");

const TextStyle h3 = TextStyle(
  fontSize: 16,
  color: mainTextColor,
  fontFamily: "NunitoSans",
);

const TextStyle h3Bold = TextStyle(
    fontSize: 16,
    color: mainTextColor,
    fontFamily: "NunitoSans",
    fontWeight: FontWeight.w600);

const TextStyle h4 = TextStyle(
  fontSize: 14,
  color: mainTextColor,
  fontFamily: "NunitoSans",
);

const TextStyle h5 = TextStyle(
  fontSize: 12,
  color: mainTextColor,
  fontFamily: "NunitoSans",
);


const TextStyle pageHeader = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w400,
  fontFamily: "MarkaziText",
  color: lightTextColor
);

const TextStyle buttonText = TextStyle(
  fontSize: 18,
  color: mainTextColor,
  fontFamily: "NunitoSans",
);

// EMOJI STYLING

TextStyle mainEmojiStyle = const TextStyle(
  color: mainTextColor,
  fontSize: 45,
);

TextStyle storyEmojiStyle = const TextStyle(
  color: mainTextColor,
  fontSize: 27,
  letterSpacing: 3.0,
);

const TextStyle timeStyle =
    TextStyle(color: fadedTextColor, fontFamily: "NunitoSans", fontSize: 14);

// MOOD-POSTING MODAL STYLING

TextStyle moodPostMainEmoji = const TextStyle(
  fontSize: 50,
);

// PROFILE STYLING

const TextStyle profileNameStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    color: lightTextColor,
    fontFamily: "MarkaziText");

const TextStyle profileDateStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: lightTextColor,
    fontFamily: "NunitoSans");

const TextStyle profileCardDayStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 35,
    color: mainColor,
    fontFamily: "MarkaziText");

const TextStyle profileCardMonthStyle = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 25,
    color: mainTextColor,
    fontFamily: "MarkaziText");

// ONBOARDING STYLING

const TextStyle loginTitleStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    color: lightTextColor,
    fontFamily: "MarkaziText");

const TextStyle loginNotificationStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w100,
    color: lightTextColor,
    fontFamily: "NunitoSans");

const TextStyle onboardTitleStyle = TextStyle(
    fontSize: 40, fontWeight: FontWeight.w400, fontFamily: "MarkaziText");

// TEXT BUTTON STYLING
final ButtonStyle navigationButtonStyle = TextButton.styleFrom(
  padding: const EdgeInsets.all(10),
  shape: const CircleBorder(),
);

final ButtonStyle settingsButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.zero, // No rounding
  )
);

// ELEVATED BUTTON STYLING
final ButtonStyle whiteElevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10));

final ButtonStyle grayElevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey,
    padding: const EdgeInsets.fromLTRB(40, 15, 40, 15));

final ButtonStyle colorElevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: mainColor,
    padding: const EdgeInsets.fromLTRB(40, 15, 40, 15));
