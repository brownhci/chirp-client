# Chirp Frontend

The frontend for Chirp; created in Flutter/Dart 

## Flutter Setup

- Install Flutter, set up an editor, and set up an emulator. Follow the instructions [here](https://flutter.dev/docs/get-started/install) for your respective operating system. Be sure to install Flutter in `/Users/yourUser/Developer` to allow Android Studio to access the Flutter SDK. If the Developer folder does not exist, create a new folder titled `Developer`.

  - Make sure to update your path for the shell you are using. If the flutter command is not found, try removing double quotes when you entering the following command in your bash_profile or zshrc: `export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"`.

- Make sure you follow all the setup directions, including installing and setting up Android Studio (plus Xcode for Mac). Run `flutter` to do initial setup, and then `flutter doctor` to see which plugins need to be installed. You will need to install Flutter and Dart plugins for your respective editor (Android Studio).

  - Note: If you are getting android toolchain errors when running `flutter doctor` then in AndroidStudio, go to Tools>SDK Manager>Android SDK > SDKTools and check the boxes for platform tools, command line tools, build tools and emulator
  - Note: If you are having issues with cocoapods, use homebrew to install rather than gem

- Configure an emulator for Android Studio. You do not need to set up for web.

- Move to the directory you want the Flutter project to be in. Make a clone of this GitHub project.

- Once you have Android Studio and an emulator set up, open Android Studio to ensure the Flutter and Dart plugins are installed. If not, follow the steps [here](https://flutter.dev/docs/get-started/editor?tab=androidstudio).

Configure the path to your local Flutter and Dart SDKs in Android Studio.

To configure Flutter SDK: go to Android Studio > Preferences > Languages and Frameworks > Flutter. Under Flutter SDK Path, enter the path to where you downloaded Flutter -- this should be `Users/yourUser/Developer/flutter`. Click Apply.

To configure Dart SDK: go to Android Studio > Preferences > Languages and Frameworks > Dart. Under Dart SDK Path, enter `<path to local Flutter installation>/flutter/bin/cache/dart-sdk`. Click Apply.

- Finally, open `chirp-client` and open `pubspec.yaml`. Get the packages by running `flutter pub get` in your terminal.

## Repository Setup

You'll need to add the local secrets to your copy of the repository.

- Create a `.env` file in the assets folder and add the line `SALT="<your-salt-here>"`

- Create a directory called `cfg` in the assets folder, and create an `app_settings.json` file within it

- In `app_settings.json`, add the following:

```
{
  "host": "<your-backend-url>"
}
```

## Layout

```
.
-- lib: houses all code
   -- models: data collections and code formatting (eg. styles)
	 -- network: api requests (eg. post/get)
	 -- screens: displays for each screen of the app (eg. login, timeline)
	 -- widgets: elements used throughout the app (eg. home, icons)
```

## Running the frontend

Note: make sure your emulated device has enough internal storage and SD card (~4098 MB seems to work for now)
See [this StackOverflow resource](https://stackoverflow.com/questions/54461288/installation-failed-with-message-error-android-os-parcelableexception-java-io)

VSCode will connect automatically to running simulators. Launch a simulator through Xcode or Android Studio, then run `flutter run` in the VSCode terminal. If only one simulator is running, it will automatically connect and launch; otherwise, select the simulator you would like to use.

## Deprecated Notes

NOTE: Flutter is incompatible with Java 11. You will need Java 8, which is installed with Android Studio. If you need Java 11 for a different reason, we are currently setting up a Docker container for compatibility as soon as possible.

Setting up Java 11 with Flutter on Windows [StackOverflow Resource](https://stackoverflow.com/questions/60869110/android-license-status-unknown-in-flutter-doctor/60869111#60869111)

Configuring environment variables for Android [Article](https://kashanhaider.com/set-up-android-environment-variables-on-macos/)