import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'cybersoruce_plugin.dart';
import 'cybersoruce_plugin_method_channel.dart';

abstract class CybersorucePluginPlatform extends PlatformInterface {
  /// Constructs a CybersorucePluginPlatform.
  CybersorucePluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static CybersorucePluginPlatform _instance = MethodChannelCybersorucePlugin();

  /// The default instance of [CybersorucePluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelCybersorucePlugin].
  static CybersorucePluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CybersorucePluginPlatform] when
  /// they register themselves.
  static set instance(CybersorucePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> tokenize({
    required String cardNumber,
    required String cardExpMonth,
    required String cardExpYear,
    required String cardCVV,
    required String merchantKey,
    required String merchantId,
    required String merchantSecret,
    required Environment environment
  }) {
    throw UnimplementedError('tokenize() has not been implemented.');
  }
}
