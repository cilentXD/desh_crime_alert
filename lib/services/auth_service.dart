import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desh_crime_alert/models/database_schema.dart';
import 'package:desh_crime_alert/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _verificationId;

  // Send OTP
  Future<void> sendOTP(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+88$phoneNumber',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification completed, sign in the user
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw 'Verification Failed: ${e.message}';
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      throw 'Error sending OTP: $e';
    }
  }

  // Verify OTP
  Future<bool> verifyOTP(String otp, {String? name}) async {
    try {
      if (_verificationId == null) throw 'Verification ID not found.';

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      final userCredential = await _signInWithCredential(credential, name: name);
      return userCredential != null;
    } catch (e) {
      throw 'Error verifying OTP: $e';
    }
  }

  // Sign in with credential
  Future<UserCredential?> _signInWithCredential(
    PhoneAuthCredential credential, {
    String? name,
  }) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _createOrUpdateUser(userCredential.user!, name: name);
      }

      return userCredential;
    } catch (e) {
      throw 'Error signing in: $e';
    }
  }

  // Create or update user in Firestore
  Future<void> _createOrUpdateUser(User user, {String? name}) async {
    try {
      final userDocRef = _firestore.collection(FirestoreSchema.users).doc(user.uid);
      final docSnapshot = await userDocRef.get();

      if (docSnapshot.exists) {
        // Existing user, update last active time and online status
        await userDocRef.update({
          'lastActive': FieldValue.serverTimestamp(),
          'isOnline': true,
        });
      } else {
        // New user, create a new document
        final newUser = UserModel(
          userId: user.uid,
          phone: user.phoneNumber!,
          name: name ?? 'User', // Use provided name or a default
          isOnline: true,
          lastActive: DateTime.now(),
          lastLocation: {'latitude': 0.0, 'longitude': 0.0}, // Default location
        );
        await userDocRef.set(newUser.toFirestore());
      }
    } catch (e) {
      // It's better to rethrow the exception to be handled by the caller
      throw 'Error creating/updating user: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user data
  Future<UserModel> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw Exception('No user is currently signed in.');
    }

    final userDoc = await _firestore
        .collection(FirestoreSchema.users)
        .doc(firebaseUser.uid)
        .get();

    if (userDoc.exists) {
      return UserModel.fromFirestore(userDoc);
    } else {
      // This case should ideally not be reached if _createOrUpdateUser works correctly.
      // As a fallback, create a user document here.
      print('User document not found for ${firebaseUser.uid}, creating a new one as a fallback.');
      UserModel newUser = UserModel(
        userId: firebaseUser.uid,
        phone: firebaseUser.phoneNumber ?? 'N/A',
        name: 'User', // Default name
        lastActive: DateTime.now(),
        isOnline: true,
        lastLocation: {'latitude': 0.0, 'longitude': 0.0},
      );
      await _firestore
          .collection(FirestoreSchema.users)
          .doc(newUser.userId)
          .set(newUser.toFirestore());
      return newUser;
    }
  }
}
