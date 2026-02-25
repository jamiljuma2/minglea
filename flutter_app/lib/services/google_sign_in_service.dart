import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GoogleSignInService {
  static Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      // Use Google Identity Services button for web
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId:
              '505667338617-oopiqor2l6o00t7kcescqenrc906as1i.apps.googleusercontent.com',
        );
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) return null; // User canceled

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } catch (e) {
        rethrow;
      }
    }
  }
}
