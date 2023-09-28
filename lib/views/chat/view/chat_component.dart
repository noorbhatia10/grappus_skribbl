import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_repository/game_repository.dart';
import 'package:grappus_skribbl/di/service_locator.dart';
import 'package:grappus_skribbl/l10n/l10n.dart';
import 'package:grappus_skribbl/views/chat/bloc/chat_bloc.dart';
import 'package:grappus_skribbl/views/game/bloc/game_bloc.dart';
import 'package:models/models.dart';

class ChatComponent extends StatelessWidget {
  const ChatComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(gameRepository: getIt<GameRepository>())
        ..add(
          const ConnectChatStream(),
        ),
      child: const ChatComponentView(),
    );
  }
}

class ChatComponentView extends StatefulWidget {
  const ChatComponentView({super.key});

  @override
  State<ChatComponentView> createState() => _ChatComponentViewState();
}

class _ChatComponentViewState extends State<ChatComponentView> {
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
            child: BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (prev, curr) => prev.messages != curr.messages,
              builder: (context, state) {
                final messages = state.messages;
                if (messages != null) {
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final newIndex = messages.length - index - 1;

                      final isMessageCorrectAnswer =
                          messages[newIndex].isCorrectWord;

                      final players = context.read<GameBloc>().state.players;
                      final player = players
                          .where(
                            (player) =>
                                player.userId == messages[newIndex].playerUid,
                          )
                          .first;

                      return Container(
                        padding: const EdgeInsets.all(8).responsive(context),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '''${player.name}: ''',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: Color(player.userNameColor),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                isMessageCorrectAnswer
                                    ? l10n.guessedTheAnswerLabel
                                    : messages[newIndex].message,
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isMessageCorrectAnswer
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
                print('dont know 1');

                if (_chatController.value.text.isEmpty) {
                  return;
                }
                print('dont know 2');

                final gameState = context.read<GameBloc>().state;
                final player = gameState.players
                    .where(
                      (player) => player.userId == gameState.currentPlayerUid,
                    )
                    .first;
                print('player is :$player');
                final isCorrectWord =
                    _chatController.text.trim().toLowerCase() ==
                            gameState.correctAnswer.trim().toLowerCase() &&
                        !player.hasAnsweredCorrectly;
                final chatModel = ChatModel(
                  playerUid: gameState.currentPlayerUid ?? '',
                  message: _chatController.text,
                  isCorrectWord: isCorrectWord,
                );
                print('chat model is: $chatModel');
                context
                    .read<ChatBloc>()
                    .add(SendChatsToLocal(message: chatModel));
                _chatController.clear();
                FocusScope.of(context).requestFocus(_focusNode);
                if (gameState.currentDrawingPlayerUid ==
                        gameState.currentPlayerUid ||
                    player.hasAnsweredCorrectly) {
                  return;
                }
                context
                    .read<ChatBloc>()
                    .add(SendChatsToServer(message: chatModel));
              },
            ),
          ),
        ],
      ),
    );
  }
}
