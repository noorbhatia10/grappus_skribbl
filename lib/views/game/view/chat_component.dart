import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grappus_skribbl/l10n/l10n.dart';
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
    final l10n = context.l10n;
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
            l10n.answersLabel,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.pastelPink,
              fontFamily: paytoneOne,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 14.toResponsiveHeight(context)),
          Expanded(
            child: BlocBuilder<GameCubit, GameState>(
              buildWhen: (prev, curr) => prev.sessionState != curr.sessionState,
              builder: (context, state) {
                final sessionState = state.sessionState;
                final players = sessionState?.players ?? {};
                if (sessionState == null) {
                  return const SizedBox();
                }
                final messages = state.messages;
                if (messages != null) {
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final newIndex = messages.length - index - 1;

                      final isMessageCorrectAnswer =
                          messages[newIndex].message ==
                                  sessionState.correctAnswer ||
                              players[messages[newIndex].playerUid]!
                                  .hasAnsweredCorrectly;

                      final currentPlayer =
                          state.sessionState!.players[state.uid];

                      return isMessageCorrectAnswer &&
                              (!currentPlayer!.hasAnsweredCorrectly)
                          ? const SizedBox()
                          : Container(
                              padding:
                                  const EdgeInsets.all(8).responsive(context),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '''${players[messages[newIndex].playerUid]?.name}: ''',
                                    style:
                                        context.textTheme.bodyLarge?.copyWith(
                                      color: Color(
                                        players[messages[index].playerUid]
                                                ?.userNameColor ??
                                            0xff000000,
                                      ),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      players[messages[newIndex].playerUid]
                                                  ?.hasAnsweredCorrectly ??
                                              false
                                          ? l10n.guessedTheAnswerLabel
                                          : messages[newIndex].message,
                                      style:
                                          context.textTheme.bodyLarge?.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: players[messages[newIndex]
                                                        .playerUid]
                                                    ?.hasAnsweredCorrectly ??
                                                false
                                            ? AppColors.emeraldGreen
                                            : AppColors.butterCreamYellow,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    },
                  );
                }
                return const SizedBox();
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
                hintText: l10n.answerHereLabel,
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
                if (_chatController.value.text.isEmpty) {
                  return;
                }
                final gameState = context.read<GameCubit>().state;
                if (gameState.sessionState == null) {
                  throw Exception('null session');
                }
                final newPlayer = gameState.sessionState!.players;
                if (newPlayer[gameState.uid] == null) {
                  throw Exception('Player not in game:${gameState.uid}');
                }
                final chatModel = ChatModel(
                  playerUid: gameState.uid ?? '',
                  message: _chatController.text,
                );
                context.read<GameCubit>()
                  ..addChatsToLocal(chatModel)
                  ..addChats(chatModel);
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
