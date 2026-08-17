import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_chat_app/service/user_auth_service.dart';
import 'package:firebase_chat_app/theme/app_colors.dart';
import 'package:firebase_chat_app/widget/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(() => setState(() {}));
    mailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<UserAuthService>();
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          title: Text(
            "Registrieren",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _key,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  spacing: 12,
                  children: [
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      cursorColor: AppColors.accent,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.glassSurface,
                        hintText: "Name",
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
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
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim() == "") {
                          return "Name sollte Zeichen enthalten";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: mailController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      cursorColor: AppColors.accent,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.glassSurface,
                        hintText: "email@gmail.com",
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
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
                      ),
                      validator: (value) {
                        if (!EmailValidator.validate(value!)) {
                          return "Email erfüllt nicht das Schema: email@gmail.com";
                        }
                        return null;
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: passwordController,
                          style: const TextStyle(color: AppColors.textPrimary),
                          cursorColor: AppColors.accent,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.glassSurface,
                            hintText: "Passwort",
                            hintStyle: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
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
                          ),
                        ),
                        FlutterPwValidator(
                          controller: passwordController,
                          width: 300,
                          height: 100,
                          minLength: 6,
                          uppercaseCharCount: 1,
                          numericCharCount: 2,
                          specialCharCount: 1,
                          onSuccess: () => isPasswordValid = true,
                          onFail: () => isPasswordValid = false,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
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
                          await _submitForm(authService);
                        },
                        child: const Text(
                          "Registrieren",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm(UserAuthService authService) async {
    if (_key.currentState!.validate() && isPasswordValid) {
      try {
        log("Registrierung erfolgreich");
        log(
          "${mailController.text.trim()} ${nameController.text.trim()}",
          name: "RegisterScreen",
        );
        await authService.registerUser(
          name: nameController.text.trim(),
          email: mailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pop(context);
      } catch (e) {
        Exception(e);
      }
    } else {
      log("Nicht alle Felder korrekt ausgefüllt!");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Felder nicht korrekt")));
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    mailController.dispose();
    passwordController.dispose();
  }
}
