import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desh_crime_alert/constants/model_constants.dart';
import 'package:desh_crime_alert/services/emergency_service.dart';

import 'models/alert_model.dart';
import 'profile_screen_new_improved.dart';
import 'providers/app_state.dart';
import 'services/alert_service.dart';
import 'services/auth_service.dart';
import 'services/location_service.dart';
import 'screens/crime_map_screen.dart';
import 'screens/report_crime_screen.dart';

// Data for the features grid
final List<Map<String, dynamic>> features = [
  {
    'icon': Icons.report_problem,
    'title': 'Report Incident',
    'subtitle': 'Share what you see',
    'color': const Color(0xFFEF4444), // Red
  },
  {
    'icon': Icons.travel_explore,
    'title': 'Crime Map',
    'subtitle': 'View nearby alerts',
    'color': const Color(0xFF3B82F6), // Blue
  },
  {
    'icon': Icons.campaign,
    'title': 'Live Alerts',
    'subtitle': 'Real-time updates',
    'color': const Color(0xFFF97316), // Orange
  },
  {
    'icon': Icons.security,
    'title': 'Safety Tips',
    'subtitle': 'Stay informed & safe',
    'color': const Color(0xFF10B981), // Green
  },
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, appState),
                _buildEmergencyButton(context),
                _buildStatusBadge(),
                _buildMapSection(appState),
                _buildEmergencyServices(context),
                _buildFeaturesGrid(),
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppState appState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E40AF).withOpacity(0.95),
            const Color(0xFF1E3A8A).withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E40AF).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${appState.currentUser?.name ?? 'Guest'}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'আপনার নিরাপত্তা আমাদের লক্ষ্য',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreenNewImproved(),
                    ),
                  );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF97316).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: (appState.currentUser?.name?.isNotEmpty ?? false)
                      ? Center(
                          child: Text(
                            appState.currentUser!.name![0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: Color(0xFF4ADE80),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'আপডেট সময়',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const Text(
                      '১৮ জুন, ২০২৫ - ২০:২৭',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Color(0xFF4ADE80),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'আপডেটেড',
                        style: TextStyle(
                          color: Color(0xFF4ADE80),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: () async {
          try {
            // Get current user and location
            final user = await AuthService().getCurrentUser();
            final position = await LocationService().getCurrentLocation();

            // Generate a new alert ID
            final alertId = FirebaseFirestore.instance
                .collection(ModelConstants.alertsCollection)
                .doc()
                .id;

            // Create an AlertModel
            final alert = AlertModel(
              alertId: alertId,
              userId: user.userId,
                            type: ModelConstants.typeEmergency,
              description: 'Emergency SOS button pressed.',
              location: {
                'latitude': position.latitude,
                'longitude': position.longitude,
              },
              status: ModelConstants.statusActive,
              createdAt: DateTime.now(),
            );

            // Send the alert
            await AlertService().createAlert(
              type: 'sos',
              description: 'Emergency SOS',
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('SOS Alert Sent Successfully!')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to send alert: $e')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD32F2F),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emergency,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'জরুরি সাহায্য',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'টিপুন এখনই',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Updated status badge design
  Widget _buildStatusBadge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1F2937).withOpacity(0.95),
              const Color(0xFF111827).withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF4ADE80).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Status icon container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF4ADE80).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF4ADE80),
                    size: 24,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF1F2937),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Status text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'সিস্টেম স্ট্যাটাস',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ADE80).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'সক্রিয়',
                          style: TextStyle(
                            color: Color(0xFF4ADE80),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white.withOpacity(0.7),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'সর্বশেষ চেক: এইমাত্র',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'সব সিস্টেম কাজ করছে',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(AppState appState) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background map/placeholder
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/images/crime-background.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black45,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'আপনার বর্তমান অবস্থান',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            appState.currentAddress ?? 'Loading address...',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF4ADE80).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.group,
                                  color: Color(0xFF4ADE80),
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${appState.nearbyAlerts.length} জন',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'নিকটবর্তী ব্যবহারকারী',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // TODO: Navigate to full map view
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.map,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'পূর্ণ ম্যাপ দেখুন',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyServices(BuildContext context) {
    final services = [
      {
        'name': 'Police',
        'icon': Icons.local_police,
        'color': const Color(0xFF3B82F6)
      },
      {
        'name': 'Ambulance',
        'icon': Icons.local_hospital,
        'color': const Color(0xFF10B981)
      },
      {
        'name': 'Fire Service',
        'icon': Icons.whatshot,
        'color': const Color(0xFFF59E0B)
      },
      {
        'name': 'Women Helpline',
        'icon': Icons.female,
        'color': const Color(0xFFEC4899)
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emergency Services',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8, // Reduced spacing
              crossAxisSpacing: 8, // Reduced spacing
              childAspectRatio: 0.85, // Adjusted ratio
            ),
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () async {
                  try {
                    await EmergencyService().makeEmergencyCall(service['name'] as String);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not make call: $e')),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (service['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: service['color'] as Color, width: 1),
                      ),
                      child: Center(
                        child: Icon(service['icon'] as IconData,
                            color: Colors.white, size: 24),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Text(
                        service['name'] as String,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 11),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    final features = [
      {
        'icon': Icons.visibility,
        'title': 'পিছনে দেখুন',
        'subtitle': 'আপনার নিরাপত্তা',
        'color': const Color(0xFFF59E0B)
      },
      {
        'icon': Icons.person_search,
        'title': 'নিখোঁজ রিপোর্ট',
        'subtitle': 'খুঁজে পেতে সহায়তা',
        'color': const Color(0xFF8B5CF6)
      },
      {
        'icon': Icons.campaign,
        'title': 'কমিউনিটি সতর্কতা',
        'subtitle': 'জরুরি বিজ্ঞপ্তি',
        'color': const Color(0xFFEC4899)
      },
      {
        'icon': Icons.policy,
        'title': 'নিরাপত্তা নীতি',
        'subtitle': 'গাইডলাইন',
        'color': const Color(0xFF10B981)
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.dashboard_customize,
                  color: Color(0xFF6366F1),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'প্রয়োজনীয় সুবিধাসমূহ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.8,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    switch (feature['title']) {
                      case 'Report Incident':
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ReportCrimeScreen()),
                        );
                        break;
                      case 'Crime Map':
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CrimeMapScreen()),
                        );
                        break;
                      default:
                        // placeholder for other features
                        break;
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (feature['color'] as Color).withOpacity(0.2),
                          (feature['color'] as Color).withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (feature['color'] as Color).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color:
                                  (feature['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              feature['icon'] as IconData,
                              color: feature['color'] as Color,
                              size: 20,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            feature['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            feature['subtitle'] as String,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
