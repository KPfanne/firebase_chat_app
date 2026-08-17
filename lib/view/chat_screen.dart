import 'package:firebase_chat_app/model/appuser.dart';
import 'package:firebase_chat_app/service/chat_service.dart';
import 'package:firebase_chat_app/service/user_service.dart';
import 'package:firebase_chat_app/theme/app_colors.dart';
import 'package:firebase_chat_app/widget/bottom_message_bar.dart';
import 'package:firebase_chat_app/widget/chat_card.dart';
import 'package:firebase_chat_app/widget/gradient_background.dart';
import 'package:firebase_chat_app/widget/top_information_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final AppUser receiver;
  const ChatScreen({super.key, required this.receiver});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<void> _key = GlobalKey();
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              children: [
                TopInformationBar(receiver: widget.receiver),
                Divider(thickness: 1, color: AppColors.textPrimary),
                SizedBox(height: 15),
                StreamBuilder(
                  stream: context.read<ChatService>().getChatHistory(
                    widget.receiver.id,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        "Fehler beim Laden",
                        style: TextStyle(color: AppColors.textPrimary),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(color: AppColors.accent);
                    }

                    final docs = snapshot.data!.docs;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data =
                              docs[index].data() as Map<String, dynamic>;
                          bool isCurrentUser =
                              data['senderId'] ==
                              context.read<UserService>().currentUserId;

                          return ChatCard(
                            side: isCurrentUser
                                ? ChatSide.right
                                : ChatSide.left,
                            message: data['message'],
                            timeStamp: data['time_stamp'],
                            chatPartner: widget.receiver,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomMessageBar(
          globalKey: _key,
          messageController: messageController,
          onPressed: () async {
            await context.read<ChatService>().sendMessage(
              messageController.text,
              widget.receiver.id,
            );
          },
        ),
      ),
    );
  }
}
