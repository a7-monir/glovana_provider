import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/views/splash.dart';
import 'package:kiwi/kiwi.dart';
import 'core/app_theme.dart';
import 'core/logic/app_logger.dart';
import 'core/logic/bloc_observer.dart';
import 'core/logic/cache_helper.dart';
import 'core/logic/firebase_notifications.dart';
import 'core/logic/helper_methods.dart';
import 'core/logic/un_focus.dart';
import 'features/service_locator.dart';
import 'features/toggle_lang/bloc.dart';
import 'firebase_options.dart';

import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await init();
      _setUpGlobalErrorHandling();

      runApp(
        EasyLocalization(
          path: 'assets/translations',
          saveLocale: true,
          startLocale: Locale(CacheHelper.lang),
          supportedLocales: const [Locale('ar'), Locale('en')],
          child: const MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      AppLogger.error(
        'Unhandled zone error',
        tag: 'APP',
        error: error,
        stackTrace: stackTrace,
      );
      showUnexpectedError();
    },
  );
}

void _setUpGlobalErrorHandling() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    AppLogger.error(
      'Flutter framework error',
      tag: 'APP',
      error: details.exception,
      stackTrace: details.stack,
      data: details.context?.toDescription(),
    );
    showUnexpectedError();
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    AppLogger.error(
      'Platform dispatcher error',
      tag: 'APP',
      error: error,
      stackTrace: stackTrace,
    );
    showUnexpectedError();
    return true;
  };

  ErrorWidget.builder = (details) {
    AppLogger.error(
      'Widget build failed',
      tag: 'UI',
      error: details.exception,
      stackTrace: details.stack,
    );

    return Material(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              const Text(
                'Something went wrong.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please restart this screen or try again in a moment.',
                textAlign: TextAlign.center,
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 16),
                Text(
                  details.exceptionAsString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  };
}

Future<void> _activateFirebaseAppCheck() async {
  try {
    await FirebaseAppCheck.instance.activate();
    AppLogger.debug('Firebase App Check activated', tag: 'FIREBASE');
  } catch (error, stackTrace) {
    AppLogger.warning(
      'Firebase App Check activation skipped',
      tag: 'FIREBASE',
      data: {'reason': AppLogger.summarizeError(error)},
    );
    AppLogger.debug(
      'Firebase App Check stack trace',
      tag: 'FIREBASE',
      data: stackTrace.toString(),
    );
  }
}

Future<void> _initializeOptionalServices() async {
  await _activateFirebaseAppCheck();
}

Future<void> init() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await EasyLocalization.ensureInitialized();
  await CacheHelper.init();
  await initFirebase();
  await _initializeOptionalServices();
  Bloc.observer = MyBlocObserver();
  initKiwi();
}

Future<void> initFirebase() async {
  try {
    const firebaseAppName = 'GlovanaApp';

    FirebaseApp? app;

    try {
      app = Firebase.app(firebaseAppName);
    } catch (_) {
      app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    if (kDebugMode) {
      AppLogger.info(
        'Firebase initialized',
        tag: 'FIREBASE',
        data: {'appName': app.name},
      );
    }

    await GlobalNotification().setUpFirebase();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (error, stackTrace) {
    AppLogger.error(
      'Firebase initialization failed',
      tag: 'FIREBASE',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final langBloc = KiwiContainer().resolve<ToggleLangBloc>();
  bool isTablet = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final width = MediaQuery.of(context).size.width;
    isTablet = width >= 650;
    AppLogger.debug(
      'Screen size classified',
      tag: 'UI',
      data: {'isTablet': isTablet, 'width': width},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: isTablet ? Size(874, 402) : Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocConsumer<ToggleLangBloc, ToggleLangStates>(
          bloc: langBloc,
          listener: (context, state) {
            if (state is ToggleLangState) {
              context.setLocale(Locale(state.lang));
            }
          },
          builder: (context, state) {
            return MaterialApp(
              title: 'Glovana Provider',
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: AppTheme.light,
              home: const SplashScreen(),
              builder: (context, x) => UnFocus(child: x),
            );
          },
        );
      },
    );
  }
}
