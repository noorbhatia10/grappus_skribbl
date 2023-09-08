import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:grappus_skribbl/l10n/l10n.dart';
import 'package:grappus_skribbl/views/views.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: const AppTheme().themeData,
      scrollBehavior: MyCustomScrollBehavior(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // home: const OnboardingPage(),
      home: const GameMainPage(
        // url: 'ws://ec2-13-51-233-255.eu-north-1.compute.amazonaws.com/ws',
        url: 'ws://localhost:8080/ws',
        name: 'Name',
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
