import 'package:firebase_chat_app/firebase_options.dart';
import 'package:firebase_chat_app/service/chat_service.dart';
import 'package:firebase_chat_app/service/user_auth_service.dart';
import 'package:firebase_chat_app/service/user_service.dart';
import 'package:firebase_chat_app/view/contacts_screen.dart';
import 'package:firebase_chat_app/view/login_screen.dart';
import 'package:firebase_chat_app/widget/gradient_background.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserService()),
        Provider<UserAuthService>(
          create: (context) => UserAuthService(context.read<UserService>()),
        ),
        Provider<ChatService>(
          create: (context) =>
              ChatService(userService: context.read<UserService>()),
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: context.read<UserAuthService>().currentUserStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GradientBackground(
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                  color: Colors.blue,
                  backgroundColor: Colors.grey[300],
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            return ContactsScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
