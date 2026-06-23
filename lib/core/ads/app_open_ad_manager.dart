import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/admob_constants.dart';

class AppOpenAdManager {
  static final AppOpenAdManager _instance = AppOpenAdManager._internal();
  factory AppOpenAdManager() => _instance;
  AppOpenAdManager._internal();

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  bool _isLoadingAd = false;
  DateTime? _appOpenLoadTime;

  void loadAd() {
    if (_isLoadingAd || _isAdAvailable) {
      debugPrint('AppOpenAd: Skip loading. isAdAvailable: $_isAdAvailable, isLoading: $_isLoadingAd');
      return;
    }

    _isLoadingAd = true;
    debugPrint('AppOpenAd: Loading ad...');
    
    AppOpenAd.load(
      adUnitId: AdmobConstants.appOpenAdUnit,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AppOpenAd: Ad loaded successfully.');
          _appOpenAd = ad;
          _isLoadingAd = false;
          _appOpenLoadTime = DateTime.now();
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd: Ad failed to load: $error');
          _isLoadingAd = false;
          _appOpenAd = null;
        },
      ),
    );
  }

  bool get _isAdAvailable {
    if (_appOpenAd == null) return false;
    if (_appOpenLoadTime == null) return false;
    
    // Check if the ad is expired (App Open ads expire after 4 hours)
    return DateTime.now().difference(_appOpenLoadTime!).inHours < 4;
  }

  void showAdIfAvailable() {
    debugPrint('AppOpenAd: showAdIfAvailable called.');

    if (!_isAdAvailable) {
      debugPrint('AppOpenAd: Ad not available. Calling loadAd().');
      loadAd();
      return;
    }

    if (_isShowingAd) {
      debugPrint('AppOpenAd: Ad is already showing.');
      return;
    }

    debugPrint('AppOpenAd: Showing ad.');
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('AppOpenAd: Ad dismissed.');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AppOpenAd: Ad failed to show: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );

    _appOpenAd!.show();
  }
}
