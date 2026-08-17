import 'package:firebase_chat_app/model/appuser.dart';
import 'package:firebase_chat_app/service/user_service.dart';
import 'package:firebase_chat_app/theme/app_colors.dart';
import 'package:firebase_chat_app/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopInformationBar extends StatefulWidget {
  final AppUser receiver;
  const TopInformationBar({super.key, required this.receiver});

  @override
  State<TopInformationBar> createState() => _TopInformationBarState();
}

class _TopInformationBarState extends State<TopInformationBar> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<UserService>().loadChatPartnerProfileImage(
        widget.receiver.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatPartnerImageUrl = context
        .watch<UserService>()
        .chatPartnerProfileImagePath;
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Avatar(imageUrl: chatPartnerImageUrl),
          Text(
            widget.receiver.name,
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
