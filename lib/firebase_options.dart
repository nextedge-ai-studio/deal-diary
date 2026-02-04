import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase 設定選項
/// 此檔案由 FlutterFire CLI 風格手動建立
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  // Web 平台設定
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAvuMIxgxLXuVTmrTlxakxSS2j4DFD0yQM',
    appId: '1:260483016700:web:51a3ebac4a4749c178b479',
    messagingSenderId: '260483016700',
    projectId: 'calendar-48fcb',
    authDomain: 'calendar-48fcb.firebaseapp.com',
    storageBucket: 'calendar-48fcb.firebasestorage.app',
    measurementId: 'G-8M8ERRVL1Y',
  );

  // Android 平台設定 (TODO: 待日後設定)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvuMIxgxLXuVTmrTlxakxSS2j4DFD0yQM',
    appId: '1:260483016700:web:51a3ebac4a4749c178b479',
    messagingSenderId: '260483016700',
    projectId: 'calendar-48fcb',
    storageBucket: 'calendar-48fcb.firebasestorage.app',
  );

  // iOS 平台設定 (TODO: 待日後設定)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAvuMIxgxLXuVTmrTlxakxSS2j4DFD0yQM',
    appId: '1:260483016700:web:51a3ebac4a4749c178b479',
    messagingSenderId: '260483016700',
    projectId: 'calendar-48fcb',
    storageBucket: 'calendar-48fcb.firebasestorage.app',
  );

  // macOS 平台設定 (TODO: 待日後設定)
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAvuMIxgxLXuVTmrTlxakxSS2j4DFD0yQM',
    appId: '1:260483016700:web:51a3ebac4a4749c178b479',
    messagingSenderId: '260483016700',
    projectId: 'calendar-48fcb',
    storageBucket: 'calendar-48fcb.firebasestorage.app',
  );

  // Windows 平台設定 (TODO: 待日後設定)
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAvuMIxgxLXuVTmrTlxakxSS2j4DFD0yQM',
    appId: '1:260483016700:web:51a3ebac4a4749c178b479',
    messagingSenderId: '260483016700',
    projectId: 'calendar-48fcb',
    storageBucket: 'calendar-48fcb.firebasestorage.app',
  );
}
