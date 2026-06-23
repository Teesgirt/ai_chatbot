import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants/admob_constants.dart';

class BannerAdWidget extends StatefulWidget {
  
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_bannerAd == null) {
      _loadBanner();
    }
  }

  Future<void> _loadBanner() async {
    final width = MediaQuery.of(context).size.width.truncate();

    final AdSize? adaptiveSize =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );

    if (adaptiveSize == null) {
      debugPrint('Failed to get adaptive banner size');
      return;
    }

    final banner = BannerAd(
      adUnitId: AdmobConstants.bannerAdUnit,
      size: adaptiveSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;

          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });

          debugPrint('Banner Ad Loaded');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();

          debugPrint(
            'Banner Ad failed to load: ${error.message}',
          );
        },
      ),
    );

    await banner.load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}