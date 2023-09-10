import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grappus_skribbl/l10n/l10n.dart';
import 'package:grappus_skribbl/views/views.dart';
import 'package:lottie/lottie.dart';
import 'package:models/models.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    required this.leaderBoard,
    super.key,
  });
  final List<Player> leaderBoard;
  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  final celebrationAnimation = Assets.celebrationAnimtaion;
  late final AnimationController _controller;
  final ValueNotifier<bool> visibleNotifier = ValueNotifier<bool>(true);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        visibleNotifier.value = false;
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
    final l10n = context.l10n;
    return Stack(
      children: [
        BaseBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.gameResultsTitle,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontFamily: paytoneOne,
                    color: AppColors.pastelPink,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.theWinnersAreLabel,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if ((widget.leaderBoard.length) > 2)
                      _ResultCard(
                        player: widget.leaderBoard[2],
                        rank: 3,
                      ),
                    ...List.generate(
                      (widget.leaderBoard.length) > 2
                          ? (widget.leaderBoard.length) - 1
                          : widget.leaderBoard.length,
                      (index) => _ResultCard(
                        player: widget.leaderBoard[index],
                        rank: index + 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                SkribblButton(
                  onTap: () => context.pushReplacement(const OnboardingPage()),
                  text: l10n.continueLabel,
                ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: visibleNotifier,
          builder: (context, isVisible, child) {
            return Visibility(
              visible: isVisible,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Lottie.asset(
                  celebrationAnimation,
                  repeat: false,
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
              ),
            );
          },
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
    final l10n = context.l10n;
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
                  '${player.score} ${l10n.pointsLabel}',
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
