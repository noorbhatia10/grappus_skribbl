import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grappus_skribbl/views/views.dart';
import 'package:lottie/lottie.dart';
import 'package:models/models.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  final celebrationAnimation = Assets.celebrationAnimtaion;
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(
          const Duration(milliseconds: 500),
        ).then((value) => Navigator.pop(context));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Lottie.asset(
          celebrationAnimation,
          repeat: false,
          controller: _controller,
          onLoaded: (composition) {
            // Configure the AnimationController with the duration of the
            // Lottie file and start the animation.
            _controller
              ..duration = composition.duration
              ..forward();
          },
        ),
        BaseBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Game Results',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontFamily: paytoneOne,
                    color: AppColors.pastelPink,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'The winners are',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 50),
                BlocBuilder<GameCubit, GameState>(
                  builder: (context, state) {
                    if (state.sessionState == null) return const SizedBox();
                    final leaderBoard = state.sessionState?.leaderboard;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if ((leaderBoard?.length ?? 0) > 2)
                          _ResultCard(
                            player: leaderBoard![2],
                            rank: 3,
                          ),
                        ...List.generate(
                          (leaderBoard?.length ?? 0) > 2
                              ? (leaderBoard?.length ?? 0) - 1
                              : leaderBoard?.length ?? 0,
                          (index) => _ResultCard(
                            player: leaderBoard![index],
                            rank: index + 1,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 50),
                SkribblButton(
                  onTap: () {
                    context.read<GameCubit>().close();
                    Navigator.of(context).pushAndRemoveUntil<Widget>(
                      MaterialPageRoute(
                        builder: (context) => const OnboardingPage(),
                      ),
                      (_) => false,
                    );
                  },
                  text: 'Continue',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  _ResultCard({
    required this.player,
    required this.rank,
  });

  final Player player;
  final int rank;

  final rankDataMap = {
    1: Assets.imgGoldMedal,
    2: Assets.imgSilverMedal,
    3: Assets.imgBronzeMedal,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        children: [
          Container(
            color: AppColors.ravenBlack,
            padding: const EdgeInsets.all(20),
            margin: EdgeInsets.only(top: rank > 1 ? 40 : 0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: AppColors.backgroundBlack,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30)
                      .copyWith(top: 30),
                  width: context.screenWidth * 0.16,
                  height: context.screenHeight * 0.28,
                  child: SvgPicture.asset(
                    player.imagePath,
                    height: 150,
                    width: 200,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  player.name,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Color(player.userNameColor),
                    fontSize: 33,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${player.score} Points',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white.withOpacity(0.3),
                    fontSize: 23,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: rank > 1 ? 30 : -5,
            right: -18,
            child: SvgPicture.asset(
              rankDataMap[rank] ?? '',
            ),
          )
        ],
      ),
    );
  }
}
