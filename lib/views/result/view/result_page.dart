import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grappus_skribbl/views/views.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Results',
              style: context.textTheme.headline5?.copyWith(
                fontFamily: paytoneOne,
                color: AppColors.pastelPink,
                fontSize: 40,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'The winners are',
              style: context.textTheme.headline5?.copyWith(
                fontFamily: outFit,
                color: AppColors.white.withOpacity(0.7),
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ResultCard(
                  name: 'Snarffyy',
                  avatar: Assets.avatar01,
                  points: 169,
                  rank: 2,
                ),
                const SizedBox(width: 67),
                _ResultCard(
                  name: 'Snarffyy',
                  avatar: Assets.avatar02,
                  points: 169,
                  rank: 0,
                ),
                const SizedBox(width: 67),
                _ResultCard(
                  name: 'Snarffyy',
                  avatar: Assets.avatar03,
                  points: 169,
                  rank: 1,
                ),
              ],
            ),
            const SizedBox(height: 50),
            SkribblButton(
              onTap: () {},
              text: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  _ResultCard({
    this.name,
    this.avatar,
    this.points,
    this.rank,
  });

  final String? name;
  final String? avatar;
  final double? points;
  final int? rank;

  final rankDataList = [
    {
      'medalImagePath': Assets.imgGoldMedal,
      'nameTextColor': AppColors.tangerineOrange,
    },
    {
      'medalImagePath': Assets.imgSilverMedal,
      'nameTextColor': AppColors.ceruleanBlue,
    },
    {
      'medalImagePath': Assets.imgBronzeMedal,
      'nameTextColor': AppColors.goldenOrange,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.ravenBlack,
          padding: const EdgeInsets.all(20),
          margin: EdgeInsets.only(top: rank! > 0 ? 40 : 0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: AppColors.backgroundBlack,
                ),
                padding: const EdgeInsets.only(
                  left: 29,
                  right: 29,
                  top: 29,
                ),
                width: context.screenWidth * 0.16,
                height: context.screenHeight * 0.28,
                child: SvgPicture.asset(
                  avatar ?? '',
                  height: 150,
                  width: 200,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                name ?? '',
                style: context.textTheme.headline1?.copyWith(
                  fontFamily: outFit,
                  color: rankDataList[rank ?? 0]['nameTextColor'] as Color,
                  fontSize: 33,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$points Points',
                style: context.textTheme.headline3?.copyWith(
                  fontFamily: outFit,
                  color: AppColors.white.withOpacity(0.3),
                  fontSize: 23,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: rank! > 0 ? 30 : -5,
          right: -18,
          child: SvgPicture.asset(
            rankDataList[rank ?? 0]['medalImagePath'] as String,
          ),
        )
      ],
    );
  }
}
