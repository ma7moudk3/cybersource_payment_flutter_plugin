import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'cybersoruce_plugin.dart';
import 'cybersoruce_plugin_platform_interface.dart';

/// An implementation of [CybersorucePluginPlatform] that uses method channels.
class MethodChannelCybersorucePlugin extends CybersorucePluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('cybersoruce_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> tokenize(
      {required String cardNumber,
      required String cardExpMonth,
      required String cardExpYear,
      required String cardCVV,
      required String merchantKey,
      required String merchantId,
      required String merchantSecret,
      required Environment environment}) async {
    final version = await methodChannel.invokeMethod<String>('tokenize', {
      'cardNumber': cardNumber,
      'month': cardExpMonth,
      'year': cardExpYear,
      'cvv': cardCVV,
      'merchantKey': merchantKey,
      'merchantId': merchantId,
      'merchantSecret': merchantSecret,
      'environment': environment.name
    });
    return version;
  }
}
