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
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      saveLocale: true,
      startLocale: Locale(CacheHelper.lang),
      supportedLocales: const [Locale('ar'), Locale('en')],
      child: const MyApp(),
    ),
  );
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
        name: firebaseAppName,
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    if (kDebugMode) {
      print('✅ Firebase initialized with app name: ${app.name}');
    }

    await GlobalNotification().setUpFirebase();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    if (kDebugMode) {
      print('⚠️ Firebase init error: $e');
    }
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

    print("isTablet: $isTablet");
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
