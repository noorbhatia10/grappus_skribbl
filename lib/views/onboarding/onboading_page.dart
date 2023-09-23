import 'dart:math';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grappus_skribbl/views/onboarding/cubit/onboarding_cubit.dart';
import 'package:grappus_skribbl/views/views.dart';

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
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Graptoons',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.butterCreamYellow,
                      fontSize: 183,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Making Masterpieces, One Chuckle at a Time.',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SkribblButton(
                        onTap: () => context.pushNamed(
                          const LoginPage(),
                          LoginPage.routeName('common'),
                        ),
                        text: 'Get Started!',
                      ),
                      const SizedBox(width: 20),
                      BlocConsumer<OnboardingCubit, OnboardingState>(
                        listenWhen: (a, b) => a.uniqueRoomId != b.uniqueRoomId,
                        listener: (context, state) {
                          if (state.uniqueRoomId.isNotNullOrEmpty) {
                            showModalBottomSheet<Widget>(
                              context: context,
                              builder: (context) {
                                return Material(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                      horizontal: 20.0,
                                    ),
                                    child: Column(
                                      children: [
                                        SelectableText(
                                          'Room has been created with ID: ${state.uniqueRoomId}',
                                          style: context.textTheme.bodyLarge
                                              ?.copyWith(
                                            color: AppColors.backgroundBlack,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SkribblButton(
                                          text: 'Copy',
                                          onTap: () {
                                            // todo: write copy link function here
                                            context
                                              ..pop()
                                              ..pushNamed(
                                                LoginPage(
                                                  roomId: state.uniqueRoomId ??
                                                      'common',
                                                ),
                                                LoginPage.routeName(
                                                  state.uniqueRoomId ??
                                                      'common',
                                                ),
                                              );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                        builder: (context, state) {
                          return SkribblButton(
                            onTap: () {
                              // hit api to create unique ID
                              context
                                  .read<OnboardingCubit>()
                                  .createRoomSession();
                            },
                            text: 'Create Room',
                            isLoading: state.isLoading ?? false,
                          );
                        },
                      ),
                    ],
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
