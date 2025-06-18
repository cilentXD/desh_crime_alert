import 'package:desh_crime_alert/login_screen.dart';
import 'package:desh_crime_alert/main_scaffold_screen.dart';

import 'package:desh_crime_alert/screens/alerts_screen.dart';
import 'package:desh_crime_alert/screens/crime_map_screen.dart';
import 'package:desh_crime_alert/screens/report_crime_screen.dart';
import 'package:desh_crime_alert/screens/splash_screen.dart'; // This should now be DeshCrimeAlertScreen
import 'package:flutter/material.dart';
import 'package:desh_crime_alert/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desh Crime Alert',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF111827),
          selectedItemColor: Color(0xFF22D3EE),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home:
          const DeshCrimeAlertScreen(), // Set DeshCrimeAlertScreen as the initial screen
      routes: {
        '/home': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const MainScaffoldScreen();
                  } else {
                    return const LoginScreen();
                  }
                }
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
            ),

        '/report': (context) => const ReportCrimeScreen(),
        '/alerts': (context) => const AlertsScreen(),
        '/map': (context) => const CrimeMapScreen(),
        // '/welcome': (context) => const WelcomeScreen(), // Uncomment if needed
      },
    );
  }
}
