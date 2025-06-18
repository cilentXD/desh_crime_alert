import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desh_crime_alert/follow_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  State<UserProfileScreen> createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isFollowing = false;
  bool _isLoading = true;
  bool _isFollowButtonLoading = false;
  Map<String, dynamic>? _userData;
  int _reportCount = 0;
  int _followersCount = 0;
  int _followingCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    // Fetch user data
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    _userData = userDoc.data();

    // Fetch stats
    final reportsQuery = await FirebaseFirestore.instance.collection('crimeReports').where('userId', isEqualTo: widget.userId).get();
    _reportCount = reportsQuery.docs.length;

    final followersQuery = await FirebaseFirestore.instance.collection('followings').where('followingId', isEqualTo: widget.userId).get();
    _followersCount = followersQuery.docs.length;

    final followingQuery = await FirebaseFirestore.instance.collection('followings').where('followerId', isEqualTo: widget.userId).get();
    _followingCount = followingQuery.docs.length;

    // Check if current user is following this user
    if (_currentUser != null) {
      final followDoc = await FirebaseFirestore.instance
          .collection('followings')
          .where('followerId', isEqualTo: _currentUser.uid)
          .where('followingId', isEqualTo: widget.userId)
          .get();
      _isFollowing = followDoc.docs.isNotEmpty;
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFollow() async {
    if (_currentUser == null) return;

    setState(() {
      _isFollowButtonLoading = true;
    });

    final followRef = FirebaseFirestore.instance.collection('followings');
    final currentUserUid = _currentUser.uid;
    final profileUserUid = widget.userId;

    try {
      if (_isFollowing) {
        // Unfollow logic
        final querySnapshot = await followRef
            .where('followerId', isEqualTo: currentUserUid)
            .where('followingId', isEqualTo: profileUserUid)
            .get();
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
        setState(() {
          _isFollowing = false;
          _followersCount--;
        });
      } else {
        // Follow logic
        await followRef.add({
          'followerId': currentUserUid,
          'followingId': profileUserUid,
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          _isFollowing = true;
          _followersCount++;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isFollowButtonLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(_userData?['displayName'] ?? 'User Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? const Center(child: Text('User not found', style: TextStyle(color: Colors.white)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _userData!['photoURL'] != null
                            ? NetworkImage(_userData!['photoURL'])
                            : null,
                        child: _userData!['photoURL'] == null
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _userData!['displayName'] ?? 'No Name',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _userData!['email'] ?? 'No Email',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn('Reports', _reportCount.toString()),
                          InkWell(
                            onTap: () {
                              if (_followersCount > 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowListScreen(
                                      userId: widget.userId,
                                      listType: 'Followers',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: _buildStatColumn('Followers', _followersCount.toString()),
                          ),
                          InkWell(
                            onTap: () {
                              if (_followingCount > 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowListScreen(
                                      userId: widget.userId,
                                      listType: 'Following',
                                    ),
                                  ),
                                );
                              }
                            },
                            child: _buildStatColumn('Following', _followingCount.toString()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (_currentUser != null && _currentUser.uid != widget.userId)
                        ElevatedButton(
                          onPressed: _isFollowButtonLoading ? null : _toggleFollow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFollowing ? Colors.grey[700] : Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                          ),
                          child: _isFollowButtonLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : Text(_isFollowing ? 'Following' : 'Follow'),
                        ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStatColumn(String label, String count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }
}
