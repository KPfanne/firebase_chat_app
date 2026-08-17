import 'package:firebase_chat_app/model/appuser.dart';
import 'package:firebase_chat_app/service/user_auth_service.dart';
import 'package:firebase_chat_app/service/user_service.dart';
import 'package:firebase_chat_app/theme/app_colors.dart';
import 'package:firebase_chat_app/view/chat_screen.dart';
import 'package:firebase_chat_app/view/settings_screen.dart';
import 'package:firebase_chat_app/widget/avatar.dart';
import 'package:firebase_chat_app/widget/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  TextEditingController newContactController = TextEditingController();
  late Future<List<AppUser>> contactsFuture;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<UserService>().loadUserProfileImage());
    contactsFuture = context.read<UserService>().getAllContacts();

    newContactController.addListener(() => {});
  }

  void _refreshContacts() {
    setState(() {
      contactsFuture = context.read<UserService>().getAllContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = context.watch<UserService>().profileImagePath;

    return Stack(
      children: [
        GradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                "Kontakte",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(color: AppColors.textPrimary),
              leading: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await context.read<UserAuthService>().logOut();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Erfolgreich ausgeloggt")),
                      );
                    },
                    icon: Icon(Icons.logout),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: Avatar(imageUrl: imageUrl),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.more_vert),
                    ),
                  ],
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      spacing: 4,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: newContactController,
                            style: TextStyle(color: AppColors.textPrimary),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.glassSurface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.glassBorder,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.glassBorder,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppColors.accent,
                                  width: 1.5,
                                ),
                              ),
                              hintText:
                                  "Bitte Email des neuen Kontakts eingeben",
                              hintStyle: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              try {
                                await context
                                    .read<UserService>()
                                    .addContactByMail(
                                      newContactController.text,
                                    );
                                newContactController.clear();
                                _refreshContacts();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Falsche Email oder existiert nicht",
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<List<AppUser>>(
                      future: contactsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            "Fehler beim Laden",
                            style: TextStyle(color: AppColors.textPrimary),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            color: AppColors.accent,
                          );
                        }

                        final contacts = snapshot.data ?? [];

                        return Expanded(
                          child: ListView.builder(
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (context) => ChatScreen(
                                            receiver: contacts[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.glassSurface,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: AppColors.glassBorder,
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: Avatar(
                                          imageUrl: contacts[index].imageUrl,
                                        ),
                                        title: Text(
                                          contacts[index].name,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
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
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    newContactController.dispose();
  }
}
