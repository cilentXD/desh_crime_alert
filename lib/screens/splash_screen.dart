import 'package:flutter/material.dart';
import 'package:desh_crime_alert/main_scaffold_screen.dart';
import 'package:desh_crime_alert/providers/app_state.dart';
import 'package:desh_crime_alert/screens/intro_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Use a post-frame callback to schedule navigation after the build is complete.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!appState.isLoading) {
            if (appState.currentUser != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainScaffoldScreen()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const IntroScreen()),
              );
            }
          }
        });
        // While loading, show a splash screen UI.
        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
  }
}