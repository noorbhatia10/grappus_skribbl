import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BaseBackground extends StatelessWidget {
  const BaseBackground({
    super.key,
    this.child,
  });
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundBlack,
            ),
          ),
          SvgPicture.asset(
            Assets.gridBackground,
            fit: BoxFit.cover,
          ),
          Container(
            child: child,
          ),
        ],
      ),
    );
  }
}
