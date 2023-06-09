import 'package:flutter_test/flutter_test.dart';
import 'package:cybersoruce_plugin/cybersoruce_plugin.dart';
import 'package:cybersoruce_plugin/cybersoruce_plugin_platform_interface.dart';
import 'package:cybersoruce_plugin/cybersoruce_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCybersorucePluginPlatform
    with MockPlatformInterfaceMixin
    implements CybersorucePluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> tokenize({required String cardNumber, required String cardExpMonth, required String cardExpYear, required String cardCVV, required String merchantKey, required String merchantId, required String merchantSecret, required Environment environment}) {
    throw UnimplementedError();
  }
}

void main() {
  final CybersorucePluginPlatform initialPlatform = CybersorucePluginPlatform.instance;

  test('$MethodChannelCybersorucePlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCybersorucePlugin>());
  });

  test('getPlatformVersion', () async {
    CybersorucePlugin cybersorucePlugin = CybersorucePlugin();
    MockCybersorucePluginPlatform fakePlatform = MockCybersorucePluginPlatform();
    CybersorucePluginPlatform.instance = fakePlatform;

    expect(await cybersorucePlugin.getPlatformVersion(), '42');
  });
}
