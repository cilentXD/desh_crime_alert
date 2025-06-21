import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:desh_crime_alert/screens/intro_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _contactController = TextEditingController();
  String? _profilePicUrl;
  bool _isUploadingPic = false;

  @override
  void initState() {
    super.initState();
    _loadProfilePic();
  }

  Future<void> _loadProfilePic() async {
    if (user == null) return;
    final snap = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    setState(() {
      _profilePicUrl = snap.data()?['profilePic'];
    });
  }

  Future<void> _pickProfileImage() async {
    if (user == null) return;
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    File imageFile = File(picked.path);
    setState(() => _isUploadingPic = true);
    final ref = FirebaseStorage.instance.ref().child('users/${user!.uid}/profile.jpg');
    await ref.putFile(imageFile);
    final url = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'profilePic': url});
    setState(() {
      _profilePicUrl = url;
      _isUploadingPic = false;
    });
  }

  Future<void> _addContact() async {
    if (user == null) return;
    if (_contactController.text.trim().isEmpty) return;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'contacts': FieldValue.arrayUnion([_contactController.text.trim()])
    }, SetOptions(merge: true));
    _contactController.clear();
    setState(() {});
  }

  Future<void> _removeContact(String contact) async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'contacts': FieldValue.arrayRemove([contact])
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: user == null
          ? const Center(child: Text("Not logged in"))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                final contacts = List<String>.from(data['contacts'] ?? []);
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _profilePicUrl != null && _profilePicUrl!.isNotEmpty
                                ? NetworkImage(_profilePicUrl!)
                                : null,
                            child: _profilePicUrl == null
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _isUploadingPic ? null : _pickProfileImage,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(user!.displayName ?? "No name",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Center(
                      child: Text(user!.email ?? "", style: const TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _contactController,
                      decoration: const InputDecoration(
                          labelText: 'Add Emergency Contact', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: _addContact, child: const Text("Add")),
                    const SizedBox(height: 16),
                    const Text("Emergency Contacts:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...contacts.map((c) => ListTile(
                          title: Text(c),
                          trailing:
                              IconButton(icon: const Icon(Icons.delete), onPressed: () => _removeContact(c)),
                        )),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const IntroScreen()),
                            (route) => false,
                          );
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
