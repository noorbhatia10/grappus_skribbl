import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grappus_skribbl/views/game/cubit/game_cubit.dart';
import 'package:models/chat_model.dart';
import 'package:models/player.dart';

class ChatComponent extends StatefulWidget {
  const ChatComponent({super.key});

  @override
  State<ChatComponent> createState() => _ChatComponentState();
}

class _ChatComponentState extends State<ChatComponent> {
  final _chatController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _chatController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: 300.toResponsiveWidth(context),
            child: Card(
              color: AppColors.lightPurple,
              surfaceTintColor: AppColors.lightPurple,
              elevation: 10,
              child: BlocBuilder<GameCubit, GameState>(
                bloc: context.read<GameCubit>(),
                builder: (context, state) {
                  final sessionState = state.sessionState;
                  if (sessionState == null) {
                    return const SizedBox();
                  }
                  final messages = sessionState.messages;
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final newIndex = messages.length - index - 1;

                      final isMessageCorrectAnswer =
                          messages[newIndex].message ==
                                  sessionState.correctAnswer ||
                              messages[newIndex].player.hasAnsweredCorrectly;

                      final currentPlayer =
                          state.sessionState!.players[state.uid];

                      return isMessageCorrectAnswer &&
                              (!currentPlayer!.hasAnsweredCorrectly)
                          ? const SizedBox()
                          : Container(
                              padding:
                                  const EdgeInsets.all(8).responsive(context),
                              color:
                                  messages[newIndex].player.hasAnsweredCorrectly
                                      ? Colors.green
                                      : AppColors.lightPurple,
                              child: Row(
                                children: [
                                  Image.asset(
                                    messages[newIndex].player.imagePath,
                                    width: 45.toResponsiveWidth(context),
                                    height: 45.toResponsiveHeight(context),
                                  ),
                                  SizedBox(width: 5.toResponsiveWidth(context)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        messages[newIndex].player.name,
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                          color: AppColors.midnightBlue,
                                        ),
                                      ),
                                      Text(
                                        messages[newIndex]
                                                .player
                                                .hasAnsweredCorrectly
                                            ? '${messages[newIndex].player.name} has guessed the correct word'
                                            : messages[newIndex].message,
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppColors.midnightBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.toResponsiveHeight(context),
        ),
        SizedBox(
          width: 300.toResponsiveWidth(context),
          height: 48.toResponsiveHeight(context),
          child: Card(
            color: AppColors.lightPurple,
            surfaceTintColor: AppColors.lightPurple,
            elevation: 10,
            child: TextField(
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppColors.darkCharcoalGrey,
              ),
              focusNode: _focusNode,
              controller: _chatController,
              decoration: InputDecoration(
                hintText: 'Enter your guess...',
                filled: false,
                suffixText: '${_chatController.value.text.length}',
              ),
              onChanged: (value) => setState(() {}),
              onSubmitted: (value) {
                setState(() {});
                final gameState = context.read<GameCubit>().state;
                if (gameState.sessionState == null) {
                  throw Exception('null session');
                }
                final players = gameState.sessionState!.players;
                context.read<GameCubit>().addChats(
                      ChatModel(
                        player: players[gameState.uid] ??
                            Player(
                              name: 'err',
                              userId: 'err',
                              imagePath: 'err',
                            ),
                        message: _chatController.text,
                      ),
                    );
                _chatController.clear();
                FocusScope.of(context).requestFocus(_focusNode);
              },
            ),
          ),
        ),
      ],
    );
  }
}
