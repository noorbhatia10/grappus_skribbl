import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class GameDialog extends StatefulWidget {
  const GameDialog({
    required this.title,
    required this.body,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;
  final String body;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String body,
    required String subtitle,
  }) async {
    // ignore: unawaited_futures
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierColor: AppColors.transparent,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: GameDialog(
          title: title,
          body: body,
          subtitle: subtitle,
        ),
      ),
    );
  }

  @override
  State<GameDialog> createState() => _GameDialogState();
}

class _GameDialogState extends State<GameDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 527,
        color: AppColors.ravenBlack,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Text(
              widget.title,
              style: context.textTheme.headlineDialog,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineMedium
                  .withOpacity(.7)
                  ?.copyWith(fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 12),
            Text(
              widget.body,
              textAlign: TextAlign.center,
              style: context.textTheme.displayLarge?.copyWith(height: .8),
            ),
            const SizedBox(height: 55),
            TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 5),
              curve: Curves.easeInOut,
              tween: Tween<double>(
                begin: 0,
                end: 1,
              ),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                color: AppColors.pastelPink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
