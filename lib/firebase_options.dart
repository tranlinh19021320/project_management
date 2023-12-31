// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCYgaY3xTA5M0PyUjNh2eRo53I8tB0EqIQ',
    appId: '1:977583032008:web:8fc32511ac26cf42e647fd',
    messagingSenderId: '977583032008',
    projectId: 'project-management-89017',
    authDomain: 'project-management-89017.firebaseapp.com',
    databaseURL: 'https://project-management-89017-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'project-management-89017.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyChOV7hLKReVdsIu_TUFDfaR5xDSHXzK7k',
    appId: '1:977583032008:android:fad93d3f8f4ed792e647fd',
    messagingSenderId: '977583032008',
    projectId: 'project-management-89017',
    databaseURL: 'https://project-management-89017-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'project-management-89017.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeL-e2b5CEne3ZKXtZQx4aRBAaL1Ovy3o',
    appId: '1:977583032008:ios:7562ea10376d0a6ce647fd',
    messagingSenderId: '977583032008',
    projectId: 'project-management-89017',
    databaseURL: 'https://project-management-89017-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'project-management-89017.appspot.com',
    iosClientId: '977583032008-58amfiafo5rrse5poh50vcsq5d4ucv7m.apps.googleusercontent.com',
    iosBundleId: 'com.example.projectManagement',
  );
}
