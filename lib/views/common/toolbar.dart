import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
      child: Text(
        'Graptoons',
        style: context.textTheme.bodyLarge?.copyWith(
          color: AppColors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
