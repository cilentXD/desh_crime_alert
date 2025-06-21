import 'package:desh_crime_alert/config/app_config.dart';
import 'package:desh_crime_alert/providers/app_state.dart';
import 'package:desh_crime_alert/screens/intro_screen.dart';
import 'package:desh_crime_alert/features/help_group_join/help_group_join_screen.dart';
import 'package:desh_crime_alert/main_scaffold_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConfig.appName,
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
      ),
      routes: {
        '/help-group-join': (context) => const HelpGroupJoinScreen(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // Not signed-in → show intro/auth flow
          if (!snapshot.hasData) return const IntroScreen();

          // Signed-in → main application
          return const MainScaffoldScreen();
        },
      ),
    );
  }
}
