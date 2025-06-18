import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class IncidentReportForm extends StatefulWidget {
  const IncidentReportForm({super.key});

  @override
  IncidentReportFormState createState() => IncidentReportFormState();
}

class IncidentReportFormState extends State<IncidentReportForm> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = 'Warning';
  String _description = '';
  String _location = '';
  File? _selectedImage;
  bool _isSubmitting = false;

  final Map<String, Map<String, dynamic>> _incidentTypes = {
    'Warning': {'emoji': '⚠️', 'color': const Color(0xFFF59E0B)},
    'Fire': {'emoji': '🔥', 'color': const Color(0xFFEF4444)},
    'Police': {'emoji': '🚨', 'color': const Color(0xFF3B82F6)},
    'Robbery': {'emoji': '💰', 'color': const Color(0xFFF59E0B)},
    'Accident': {'emoji': '💥', 'color': const Color(0xFF8B5CF6)},
    'Other': {'emoji': '❓', 'color': const Color(0xFF9CA3AF)},
  };

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        String? imageUrl;
        if (_selectedImage != null) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(99999)}.jpg';
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('incident_reports')
              .child(fileName);
          await storageRef.putFile(_selectedImage!);
          imageUrl = await storageRef.getDownloadURL();
        }

        final currentUser = FirebaseAuth.instance.currentUser;
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final topPadding = MediaQuery.of(context).padding.top;
        final appBarHeight = AppBar().preferredSize.height;
        final availableHeight = screenHeight - topPadding - appBarHeight;

        final reportData = {
          'type': _selectedType,
          'description': _description,
          'location': _location,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': currentUser?.uid ?? 'anonymous',
          'userName': currentUser?.displayName ?? 'Anonymous',
          'imageUrl': imageUrl,
          'top': Random().nextDouble() * (availableHeight - 100) + 20,
          'left': Random().nextDouble() * (screenWidth - 60) + 20,
        };

        await FirebaseFirestore.instance.collection('crimeReports').add(reportData);

        if (!mounted) return;
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: const Color(0xFF1F2937),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text('Incident Reported', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            content: const Text('আপনার ঘটনাটি সফলভাবে রিপোর্ট করা হয়েছে।', style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // Pop the dialog
                  Navigator.pop(context); // Pop the form
                },
                child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF06B6D4))),
              ),
            ],
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to report incident. Please try again.')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
            _selectedImage = null;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF111827),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Report an Incident',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Incident Type',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF1F2937),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownColor: const Color(0xFF1F2937),
                style: const TextStyle(color: Colors.white),
                items: _incidentTypes.keys.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Row(
                      children: [
                        Text(_incidentTypes[type]!['emoji']),
                        const SizedBox(width: 8),
                        Text(type),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF1F2937),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                onChanged: (value) => _description = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: const Color(0xFF1F2937),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) => _location = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2937),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[700]!),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _selectedImage == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt, color: Colors.white70, size: 40),
                              SizedBox(height: 8),
                              Text('Tap to add a photo', style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF06B6D4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _isSubmitting ? null : _submitReport,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Submit Report'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
