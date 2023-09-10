import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SkribblButton extends StatefulWidget {
  const SkribblButton({
    required this.text,
    required this.onTap,
    super.key,
  });

  final String text;
  final VoidCallback onTap;

  @override
  State<SkribblButton> createState() => _SkribblButtonState();
}

class _SkribblButtonState extends State<SkribblButton> {
  // data variables
  bool _isPressed = false;

  //constants
  static const double kShadow = 6;

  @override
  Widget build(BuildContext context) {
    final width = 270.0.toResponsiveWidth(context);
    final height = 80.0.toResponsiveHeight(context);
    return SizedBox(
      height: height + kShadow,
      width: width,
      child: InkWell(
        onTap: () async {
          widget.onTap();
          setState(() => _isPressed = true);
          await Future<void>.delayed(const Duration(milliseconds: 300));
          setState(() => _isPressed = false);
        },
        child: Stack(
          children: [
            Positioned(
              top: kShadow,
              bottom: 0,
              child: Container(
                height: height,
                width: width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.goldenYellow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 2),
                ),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 100),
              bottom: _isPressed ? 0 : kShadow,
              child: Container(
                height: height,
                width: width,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.butterCreamYellow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 2, color: AppColors.charcoalGrey),
                ),
                child: Text(
                  widget.text,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
