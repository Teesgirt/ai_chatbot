import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService {
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
    
    // Add test device ID from logcat to see ads during development
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['8FFB62617F80D621AC0F033836FA02D8']),
    );
  }
}
