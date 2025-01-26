// Generated file from FlutterFire CLI
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCYHY4i3ihYVn03BJ2mjWjdllVaJ1GOWcY',
    appId: '1:488633539226:web:21975206d29e3428349d23',
    messagingSenderId: '488633539226',
    projectId: 'aoura-ad5ee',
    authDomain: 'aoura-ad5ee.firebaseapp.com',
    databaseURL: 'https://aoura-ad5ee-default-rtdb.firebaseio.com',
    storageBucket: 'aoura-ad5ee.appspot.com',
    measurementId: 'G-1GNJ5SDCTN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2pgCkFcb9RYzjIiV3l8QFTTI68Y2Tyqo',
    appId: '1:488633539226:android:9d6199bb1e97cd15349d23',
    messagingSenderId: '488633539226',
    projectId: 'aoura-ad5ee',
    databaseURL: 'https://aoura-ad5ee-default-rtdb.firebaseio.com',
    storageBucket: 'aoura-ad5ee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDRq3TtOM-ucO9RsYpzytjCItRxzDOPwmc',
    appId: '1:488633539226:ios:412212127effde28349d23',
    messagingSenderId: '488633539226',
    projectId: 'aoura-ad5ee',
    databaseURL: 'https://aoura-ad5ee-default-rtdb.firebaseio.com',
    storageBucket: 'aoura-ad5ee.appspot.com',
    iosClientId: '488633539226-ijdpb8e5sa8e2vqgvj6mjc78tsek8t3i.apps.googleusercontent.com',
    iosBundleId: 'zw.co.appixiasoftwares.nestiq',
  );
}

