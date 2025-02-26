import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with Google using Firebase
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the GoogleSignInAccount
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential for Firebase with the Google account
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user; // Return the signed-in user
    } on FirebaseAuthException catch (e) {
      print("Error signing in with Google: ${e.message}");
      return null;
    }
  }

  // Sign out from Google and Firebase
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
