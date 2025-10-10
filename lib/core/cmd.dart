// fvm
// flutter pub run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart
//fvm flutter pub run easy_localization:generate -S assets/translations
//fvm flutter packages pub run build_runner build
//fvm flutter packages pub run build_runner build --delete-conflicting-outputs

// create app logo
//flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons*

//flutter build apk
//flutter build apk --release
//when happen conflict while pull
//pull --no-ff

// to update cocoa pods if he say you have no permissions for user/bin
//sudo gem install cocoapods -n /usr/local/bin

// add this line to Podfile when create new project
//source 'https://github.com/CocoaPods/Specs.git'

/*
//when coca pods stuck you can get a progression, you can clone master yourself:
pod repo remove master
git clone https://github.com/CocoaPods/Specs.git ~/.cocoapods/repos/master
pod setup
*/

// To install firebase using npm
//sudo npm install -g firebase-tools

// To uninstall firebase using npm
//npm uninstall -g firebase-tools

// for copy the .ssh
// tr -d '\n' < /Users/amrbakr/.ssh/id_rsa.pub | pbcopy
// to enable firebase cli
// dart pub global activate flutterfire_cli
// export PATH="$PATH":"$HOME/.pub-cache/bin"
// flutterfire configure
//flutterfire configure --project=online-store-e137a
// firebase login
// firebase logout
// firebase projects:list
// firebase projects:createf
//fvm flutter pub run easy_localization:generate -S assets/translations -f keys -O lib/gen -o locale_keys.g.dart

//fvm flutter build apk --release --no-tree-shake-svg

//firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk

// fvm flutter clean
// fvm flutter pub get
// fvm flutter pub add --dev dart_code_metrics
// fvm dart run dart_code_metrics:metrics check-unused-files lib

// to clean npm cache
//npm cache clean --force

// to get sh1
/*
cd android
./gradlew signingReport

or

//for mac
keytool -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore
// then the password by default is android

// for windows
keytool -list -v \
-alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
 */

/*
add These lines to info.plist
     ----- this in dict tag
    <key>FirebaseAppDelegateProxyEnabled</key>
    <true/>
 */

/*
// Google places api to get posts places
// ask the client for paid api key the current api key is for nabit
https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=31.0181956,31.3903093&radius=20000&type=post&keyword=البريد &key=AIzaSyDpXz7AuDjP9XqLcVM62aVaXd2nmkxJCGw
 */

// remove the local changes to the previous commit
// git reset

// Background Colors

// Background Black:    \u001b[40m        or \x1b[40m
// Background Red:      \u001b[41m        or \x1b[40m
// Background Green:    \u001b[42m        or \x1b[40m
// Background Yellow:   \u001b[43m        or \x1b[40m
// Background Blue:     \u001b[44m        or \x1b[40m
// Background Magenta:  \u001b[45m        or \x1b[40m
// Background Cyan:     \u001b[46m        or \x1b[40m
// Background White:    \u001b[47m        or \x1b[40m

// Bright  ساطع
// Background Bright Black:         \u001b[40;1m   or \x1b[40;1m
// Background Bright Red:           \u001b[41;1m   or \x1b[41;1m
// Background Bright Green:         \u001b[42;1m   or \x1b[42;1m
// Background Bright Yellow:        \u001b[43;1m   or \x1b[43;1m
// Background Bright Blue:          \u001b[44;1m   or \x1b[44;1m
// Background Bright Magenta:       \u001b[45;1m   or \x1b[45;1m
// Background Bright Cyan:          \u001b[46;1m   or \x1b[46;1m
// Background Bright White:         \u001b[47;1m   or \x1b[47;1m

//Reset: \u001b[0m
