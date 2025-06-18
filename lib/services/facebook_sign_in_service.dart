import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
        
        // Once signed in, return the UserCredential
        final UserCredential userCredential = await _auth.signInWithCredential(facebookAuthCredential);
        return userCredential.user;
      } else {
        throw Exception('Facebook login failed: ${loginResult.status}');
      }
    } catch (e) {
      throw Exception('Facebook sign-in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
