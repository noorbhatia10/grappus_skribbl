import 'dart:math';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grappus_skribbl/views/background/base_background.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBackground(
      child: Center(
        child: Stack(
          children: [
            Positioned(
              left: -70,
              top: 30,
              child: Transform.rotate(
                angle: pi / 4,
                child: SvgPicture.asset(
                  Assets.avatar02,
                  height: 400,
                ),
              ),
            ),
            Positioned(
              right: -40,
              bottom: -60,
              child: Transform.rotate(
                angle: 0.24,
                child: SvgPicture.asset(
                  Assets.avatar04,
                  height: 400,
                ),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Graptoons',
                    style: TextStyle(
                      color: AppColors.butterCreamYellow,
                      fontSize: 180,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                  Text(
                    'Making Masterpieces, One Chuckle at a Time.',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Outfit',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
