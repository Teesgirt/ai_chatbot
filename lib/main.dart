import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/ads/admob_service.dart';
import 'core/ads/app_open_ad_manager.dart';

// We store the listener in a top-level variable to prevent it from being garbage collected.
AppLifecycleListener? _lifecycleListener;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await AdmobService.initialize();

  // Load the first ad
  AppOpenAdManager().loadAd();

  // Set up lifecycle listener to show ad when app comes to foreground.
  // We use both onResume and onRestart for maximum compatibility across Android versions.
  _lifecycleListener = AppLifecycleListener(
    onRestart: () {
      AppOpenAdManager().showAdIfAvailable();
    },
    onResume: () {
      AppOpenAdManager().showAdIfAvailable();
    },
  );

  runApp(const MyApp());
}
