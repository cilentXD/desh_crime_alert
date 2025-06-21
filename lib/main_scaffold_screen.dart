import 'package:desh_crime_alert/providers/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen_new.dart';
import 'screens/incident_map_screen.dart';
import 'news_screen.dart';
import 'live_screen.dart';
import 'screens/alerts_screen.dart';
import 'package:desh_crime_alert/widgets/incident_report_form.dart';

class MainScaffoldScreen extends StatefulWidget {
  const MainScaffoldScreen({super.key});

  @override
  MainScaffoldScreenState createState() => MainScaffoldScreenState();
}

class MainScaffoldScreenState extends State<MainScaffoldScreen> {
  int _currentIndex = 3; // Default to Desh Alert tab (which is HomeScreen)

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const IncidentMapScreen(),
      const NewsScreen(),
      const LiveScreen(),
      const HomeScreen(),
      const AlertsScreen(),
    ];

    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          body: SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
          ),
          floatingActionButton: _currentIndex == 0
              ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const IncidentReportForm(),
                    );
                  },
                  backgroundColor: const Color(0xFF22D3EE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: const Icon(Icons.add_location_alt_outlined,
                      color: Colors.white),
                )
              : null,
          bottomNavigationBar: _buildBottomNavBar(appState),
        );
      },
    );
  }

  Widget _buildBottomNavBar(AppState appState) {
    final alertCount = appState.nearbyAlerts.length;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Color(0xFF374151))), // gray-700
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF6B7280), // gray-500
        selectedFontSize: 12.0,
        unselectedFontSize: 10.0,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'News',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.sensors_outlined),
            activeIcon: Icon(Icons.sensors),
            label: 'Go Live',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            activeIcon: Icon(Icons.shield),
            label: 'Desh Alert',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined),
                if (alertCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$alertCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications),
                if (alertCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$alertCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }
}
