import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const String path = '/settings';
  static const String name = 'settings';

  static Widget create() => const SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr())),
      body: Center(child: Text('settings.content'.tr())),
    );
  }
}
