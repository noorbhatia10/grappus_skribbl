import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grappus_skribbl/views/game/cubit/game_cubit.dart';
import 'package:models/models.dart';

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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.ravenBlack,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Answers',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.pastelPink,
              fontFamily: 'PaytoneOne',
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14.toResponsiveHeight(context)),
          Expanded(
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

                    final isMessageCorrectAnswer = messages[newIndex].message ==
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
                            child: Row(
                              children: [
                                Text(
                                  '${messages[newIndex].player.name}: ',
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: AppColors.goldenOrange,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  messages[newIndex].player.hasAnsweredCorrectly
                                      ? 'Guessed the Answer!'
                                      : messages[newIndex].message,
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: messages[newIndex]
                                            .player
                                            .hasAnsweredCorrectly
                                        ? AppColors.emeraldGreen
                                        : AppColors.butterCreamYellow,
                                  ),
                                ),
                              ],
                            ),
                          );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 10.toResponsiveHeight(context)),
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
              controller: _chatController,
              decoration: InputDecoration(
                hintText: 'Answer here',
                filled: false,
                hintStyle: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.butterCreamYellow.withOpacity(0.3),
                ),
                suffixText: '${_chatController.value.text.length}',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (value) => setState(() {}),
              onSubmitted: (value) {
                setState(() {});
                final gameState = context.read<GameCubit>().state;
                if (gameState.sessionState == null) {
                  throw Exception('null session');
                }
                final players2 = gameState.sessionState!.players;
                context.read<GameCubit>().addChats(
                      ChatModel(
                        player: players2[gameState.uid] ??
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
        ],
      ),
    );
  }
}
