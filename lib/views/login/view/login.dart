import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game_repository/game_repository.dart';
import 'package:grappus_skribbl/di/service_locator.dart';
import 'package:grappus_skribbl/views/login/bloc/login_bloc.dart';
import 'package:grappus_skribbl/views/views.dart';
import 'package:services/services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        gameService: GameService(),
        gameRepository: getIt.get<GameRepository>(),
      ),
      child: const LoginPageView(),
    );
  }
}

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  static const String routeName = '/rd-login';

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  final TextEditingController _nameController = TextEditingController();

  final FocusNode _focusNode = FocusNode();
  List<String> avatars = [
    Assets.avatar01,
    Assets.avatar02,
    Assets.avatar03,
    Assets.avatar04,
    Assets.avatar05,
    Assets.avatar06,
    Assets.avatar07,
    Assets.avatar08,
  ];
  int selectedIndex = 0;

  int generateUserNameColor() {
    final colorList = [
      AppColors.antiqueIvory,
      AppColors.goldenYellow,
      AppColors.goldenOrange,
      AppColors.pastelPink,
      AppColors.ceruleanBlue,
      AppColors.lavenderPurple,
      AppColors.tangerineOrange,
      AppColors.lavenderPurple,
    ];
    return colorList.randomItem().value;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessFullState) {
          context.pushNamedReplacement(
            GameMainPage(
              playerUid: state.playerUid,
            ),
            GameMainPage.routeName,
          );
        }
        if (state is ErrorState) {
          context.showSnackBar(message: state.error);
        }
      },
      child: BaseBackground(
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
                    fontFamily: paytoneOne,
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
                const Spacer(),
                Text(
                  'Select your Avatar',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.butterCreamYellow,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  runSpacing: 12,
                  spacing: 12,
                  children: List.generate(
                    avatars.length,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundBlack,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: (selectedIndex == index)
                                ? AppColors.butterCreamYellow
                                : AppColors.backgroundBlack,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SvgPicture.asset(
                            avatars[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SkribblButton(
                  onTap: () {
                    if (_nameController.value.text.trim().isEmpty) {
                      context.showSnackBar(message: 'Enter Name');
                    } else {
                      context.read<LoginBloc>().add(
                            AddPlayer(
                              playerName: _nameController.value.text,
                              imagePath: avatars[selectedIndex],
                              color: generateUserNameColor(),
                            ),
                          );
                      // context.pushNamedReplacement(
                      //   GameMainPage(
                      //     url: Endpoints.webSocketUrl,
                      //     name: _nameController.value.text,
                      //     selectedImagePath: avatars[selectedIndex],
                      //   ),
                      //   GameMainPage.routeName,
                      // );
                    }
                  },
                  text: 'Play Game',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
