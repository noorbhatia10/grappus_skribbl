import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:grappus_skribbl/utils/app_util.dart';
import 'package:grappus_skribbl/views/views.dart';

class RDLoginPage extends StatefulWidget {
  const RDLoginPage({super.key});
  static const String routeName = '/rd-login';

  @override
  State<RDLoginPage> createState() => _RDLoginPageState();
}

class _RDLoginPageState extends State<RDLoginPage> {
  final TextEditingController _nameController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  List<String> avatars = [];

  @override
  Widget build(BuildContext context) {
    return BaseBackground(
      child: Center(
        child: Container(
          width: 551,
          height: 700,
          padding: const EdgeInsets.symmetric(
            horizontal: 47,
            vertical: 30,
          ),
          decoration: BoxDecoration(
            color: AppColors.ravenBlack,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quick Play',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 40,
                  color: AppColors.pastelPink,
                  fontFamily: 'PaytoneOne',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pick a name for yourself',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.butterCreamYellow,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundBlack,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.butterCreamYellow,
                  ),
                  focusNode: _focusNode,
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Type Here',
                    filled: false,
                    hintStyle: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.butterCreamYellow.withOpacity(0.3),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isEmpty) {
                      context.showSnackBar(message: 'Enter Name');
                    }
                    FocusScope.of(context).requestFocus(_focusNode);
                  },
                ),
              ),
              const SizedBox(height: 50),
              Text(
                'Select your Avatar',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.butterCreamYellow,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Wrap(),
              SkribblButton(
                onTap: () {
                  if (_nameController.value.text.trim().isEmpty) {
                    context.showSnackBar(message: 'Enter Name');
                  } else {
                    navigateTo(
                      context,
                      GameMainPage(
                        // url: 'ws://ec2-13-51-233-255.eu-north-1.compute.amazonaws.com/ws',
                        url: 'ws://localhost:8080/ws',
                        name: _nameController.value.text,
                      ),
                      GameMainPage.routeName,
                    );
                  }
                },
                text: 'Play Game',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
