import 'package:firebase_chat_app/service/user_service.dart';
import 'package:firebase_chat_app/theme/app_colors.dart';
import 'package:firebase_chat_app/widget/avatar.dart';
import 'package:firebase_chat_app/widget/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<UserService>().loadUserProfileImage());
  }

  @override
  Widget build(BuildContext context) {
    final userService = context.watch<UserService>();
    final imageUrl = userService.profileImagePath;
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Settings",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Profilbild aussuchen: ",
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          context.read<UserService>().uploadProfilePicture(),
                      child: Transform.scale(
                        scale: 1.5,
                        child: Avatar(imageUrl: imageUrl),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
