import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_app/model/appuser.dart';
import 'package:firebase_chat_app/service/chat_service.dart';
import 'package:firebase_chat_app/service/user_service.dart';
import 'package:firebase_chat_app/theme/app_colors.dart';
import 'package:firebase_chat_app/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatCard extends StatefulWidget {
  final AppUser chatPartner;
  final ChatSide side;
  final String message;
  final Timestamp? timeStamp;
  const ChatCard({
    super.key,
    required this.side,
    required this.message,
    required this.chatPartner,
    required this.timeStamp,
  });

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<UserService>().loadUserProfileImage());
    Future.microtask(
      () => context.read<UserService>().loadChatPartnerProfileImage(
        widget.chatPartner.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = context.read<UserService>().profileImagePath;
    final chatPartnerImageUrl = context
        .read<UserService>()
        .chatPartnerProfileImagePath;
    if (widget.side == ChatSide.left) {
      return Container(
        margin: EdgeInsetsDirectional.only(top: 12),
        child: Row(
          children: [
            Transform.scale(
              scale: 0.8,
              child: Avatar(imageUrl: chatPartnerImageUrl),
            ),
            Card(
              color: AppColors.bubbleOther,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 80,
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.message,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF0A4F4F),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.timeStamp != null
                            ? context.read<ChatService>().getDateTimeOfMessage(
                                widget.timeStamp!,
                              )
                            : "senden...",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF0A4F4F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsetsDirectional.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Card(
              color: AppColors.bubbleMine,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 80,
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.message,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.timeStamp != null
                            ? context.read<ChatService>().getDateTimeOfMessage(
                                widget.timeStamp!,
                              )
                            : "senden...",
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Transform.scale(scale: 0.8, child: Avatar(imageUrl: imageUrl)),
          ],
        ),
      );
    }
  }
}

enum ChatSide { left, right }
