import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desh_crime_alert/user_profile_screen.dart';
import 'package:flutter/material.dart';

class FollowListScreen extends StatefulWidget {
  final String userId;
  final String listType; // 'Followers' or 'Following'

  const FollowListScreen({
    super.key,
    required this.userId,
    required this.listType,
  });

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  late Future<List<DocumentSnapshot>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUserList();
  }

  Future<List<DocumentSnapshot>> _fetchUserList() async {
    QuerySnapshot followQuery;
    String fieldToFetch;

    if (widget.listType == 'Followers') {
      // Find documents where the current user is being followed
      followQuery = await FirebaseFirestore.instance
          .collection('followings')
          .where('followingId', isEqualTo: widget.userId)
          .get();
      fieldToFetch = 'followerId';
    } else { // 'Following'
      // Find documents where the current user is the follower
      followQuery = await FirebaseFirestore.instance
          .collection('followings')
          .where('followerId', isEqualTo: widget.userId)
          .get();
      fieldToFetch = 'followingId';
    }

    if (followQuery.docs.isEmpty) {
      return [];
    }

    final userIds = followQuery.docs.map((doc) => doc[fieldToFetch] as String).toList();

    if (userIds.isEmpty) {
      return [];
    }

    final userDocs = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();

    return userDocs.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(widget.listType),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.', style: TextStyle(color: Colors.white70)));
          }

          final userDocs = snapshot.data!;

          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              final userData = userDocs[index].data() as Map<String, dynamic>;
              final userId = userDocs[index].id;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: userData['photoURL'] != null
                      ? NetworkImage(userData['photoURL'])
                      : null,
                  child: userData['photoURL'] == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(userData['displayName'] ?? 'No Name', style: const TextStyle(color: Colors.white)),
                subtitle: Text(userData['email'] ?? 'No Email', style: const TextStyle(color: Colors.white70)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(userId: userId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
