
import 'cybersoruce_plugin_platform_interface.dart';

class CybersorucePlugin {
  Future<String?> getPlatformVersion() {
    return CybersorucePluginPlatform.instance.getPlatformVersion();
  }

  Future<String?> tokenize({
    required String cardNumber,
    required String cardExpMonth,
    required String cardExpYear,
    required String cardCVV,
  }) {
    return CybersorucePluginPlatform.instance.tokenize(
      cardNumber: cardNumber,
      cardExpMonth: cardExpMonth,
      cardExpYear: cardExpYear,
      cardCVV: cardCVV,
    );
  }
}
