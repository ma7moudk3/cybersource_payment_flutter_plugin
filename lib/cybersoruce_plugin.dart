import 'cybersoruce_plugin_platform_interface.dart';

class CybersorucePlugin {
  Future<String?> getPlatformVersion() {
    return CybersorucePluginPlatform.instance.getPlatformVersion();
  }

  Future<String?> tokenize(
      {required String cardNumber,
      required String cardExpMonth,
      required String cardExpYear,
      required String cardCVV,
      required String merchantKey,
      required String merchantId,
      required String merchantSecret,
      required Environment environment}) async {
    String? token = await CybersorucePluginPlatform.instance.tokenize(
        cardNumber: cardNumber,
        cardExpMonth: cardExpMonth,
        cardExpYear: cardExpYear,
        cardCVV: cardCVV,
        environment: environment,
        merchantId: merchantId,
        merchantKey: merchantKey,
        merchantSecret: merchantSecret);
    return token;
  }
}

enum Environment { production, sandbox }
