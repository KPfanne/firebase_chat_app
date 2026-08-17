import 'package:firebase_chat_app/service/user_auth_service.dart';
import 'package:firebase_chat_app/theme/app_colors.dart';
import 'package:firebase_chat_app/view/register_screen.dart';
import 'package:firebase_chat_app/widget/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<void> _key = GlobalKey();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Login", style: TextStyle(color: AppColors.textPrimary)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Form(
              key: _key,
              child: Column(
                spacing: 12,
                children: [
                  TextFormField(
                    controller: mailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
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
                      hintText: "Email",
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      fillColor: AppColors.glassSurface,
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
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
                      hintText: "Passwort",
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      fillColor: AppColors.glassSurface,
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        try {
                          await context.read<UserAuthService>().login(
                            email: mailController.text,
                            password: passwordController.text,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Falsche Daten eingegeben"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                    ),
                    child: const Text("Hier registrieren!"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    mailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    mailController.dispose();
    passwordController.dispose();
  }
}
