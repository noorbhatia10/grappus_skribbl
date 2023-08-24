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
  final message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 576,
          width: 356,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: BlocBuilder<GameCubit, GameState>(
                bloc: context.read<GameCubit>(),
                builder: (context, state) {
                  final chatState = state.sessionState;
                  if (chatState == null) {
                    return const SizedBox();
                  }
                  final messages = chatState.messages;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          children: [
                            const CircleAvatar(),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(messages[index].player.name),
                                Text(messages[index].message)
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
        Card(
          child: Container(
            height: 60,
            width: 356,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 356,
                    height: 60,
                    child: TextField(
                      controller: message,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final gameState = context.read<GameCubit>().state;
                    if (gameState.sessionState == null) {
                      throw Exception('null session');
                    }
                    final players2 = gameState.sessionState!.players;
                    context.read<GameCubit>().addChats(
                          ChatModel(
                            player: players2.firstWhere(
                              (element) =>
                                  element.userId ==
                                  gameState.sessionState!.currentPlayerId,
                              orElse: () => Player(name: 'err', userId: 'err'),
                            ),
                            message: message.text,
                          ),
                        );
                    message.clear();
                  },
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
