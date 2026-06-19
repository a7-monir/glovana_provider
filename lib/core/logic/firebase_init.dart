import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

Future<FirebaseApp>? _firebaseInitFuture;

Future<FirebaseApp> ensureFirebaseInitialized() async {
  if (Firebase.apps.isNotEmpty) {
    return Firebase.app();
  }

  if (_firebaseInitFuture != null) {
    return _firebaseInitFuture!;
  }

  _firebaseInitFuture = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  late final FirebaseApp app;
  try {
    app = await _firebaseInitFuture!;
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app' && Firebase.apps.isNotEmpty) {
      app = Firebase.app();
    } else {
      _firebaseInitFuture = null;
      rethrow;
    }
  } catch (_) {
    _firebaseInitFuture = null;
    rethrow;
  }

  if (kDebugMode) {
    print(
      'Firebase initialized with app name: ${app.name}, '
      'projectId: ${app.options.projectId}, appId: ${app.options.appId}',
    );
  }

  return app;
}
