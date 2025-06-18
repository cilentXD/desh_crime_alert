import 'package:flutter/material.dart';
import 'package:desh_crime_alert/profile_screen_new_improved.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  // Passing these values, though they are static for now.
  // In the future, they can be fetched from a service.
  final int notifications = 2341;
  final int nearbyUsers = 2321;

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildStatusBadge(),
            _buildMapSection(),
            _buildEmergencyServices(),
            _buildFeaturesGrid(),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          16, 40, 16, 16), // Adjust top padding for status bar
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2A3A4D), Color(0xFF1F2937)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Desh Crime Alert',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900, // Bolder
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'আপনার নিরাপত্তা আমাদের লক্ষ্য', // Using the correct tagline
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF9CA3AF),
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
                    builder: (context) => const ProfileScreenNewImproved()),
              );
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF97316), // Orange color from screenshot
                borderRadius: BorderRadius.circular(12), // Rounded square
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.shield_outlined, color: Color(0xFF10B981), size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Systems Operational',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15, // Increased size
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Last checked: Just now',
                    style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: AssetImage('assets/images/crime-background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dhaka, Bangladesh',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '15 nearby users active',
                  style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View Full Map'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyServices() {
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
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.0, // Adjusted aspect ratio for better spacing
            ),
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () {
                  // Define specific phone numbers for each service
                  String phoneNumber = '';
                  if (service['name'] == 'Police') {
                    phoneNumber = '999'; // Example Police number
                  } else if (service['name'] == 'Ambulance') {
                    phoneNumber = '102'; // Example Ambulance number
                  } else if (service['name'] == 'Fire Service') {
                    phoneNumber = '199'; // Example Fire Service number
                  } else if (service['name'] == 'Women Helpline') {
                    phoneNumber = '1098'; // Example Women Helpline number
                  }
                  if (phoneNumber.isNotEmpty) {
                    _makePhoneCall(phoneNumber);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50, // Reduced container size
                      height: 50,
                      decoration: BoxDecoration(
                        color: (service['color'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: service['color'] as Color, width: 1),
                      ),
                      child: Center(
                        child: Icon(service['icon'] as IconData,
                            color: Colors.white, size: 24), // Reduced icon size
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['name'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Widget _buildFeaturesGrid() {
    final features = [
      {
        'icon': Icons.visibility,
        'title': 'Watch My Back',
        'color': const Color(0xFFF59E0B)
      },
      {
        'icon': Icons.person_search,
        'title': 'Activate Missing',
        'color': const Color(0xFF8B5CF6)
      },
      {
        'icon': Icons.campaign,
        'title': 'Community Alert',
        'color': const Color(0xFFEC4899)
      },
      {
        'icon': Icons.policy,
        'title': 'Safety Policy',
        'color': const Color(0xFF10B981)
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Features',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two columns
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2, // Adjusted for new layout
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return Container(
                decoration: BoxDecoration(
                  color:
                      const Color(0xFF1F2937), // Background color for the item
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70, // Larger container for icon
                      height: 70,
                      decoration: BoxDecoration(
                        color: (feature['color'] as Color).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        feature['icon'] as IconData,
                        color: feature['color'] as Color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      feature['title'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
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
}
