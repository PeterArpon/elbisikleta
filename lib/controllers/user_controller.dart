import 'package:elbisikleta/models/user_model.dart';
import 'package:elbisikleta/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController {

  static User? user = FirebaseAuth.instance.currentUser;

  static Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();

    final googleAuth = await googleAccount?.authentication;

    // sign in with firebase auth
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential
    );

    // save or update user data in Firestore
    if (userCredential.user != null) {
      // save user data
      final userService = UserService();
      await userService.saveUserData(userCredential.user!);
    }

    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  
  static Future<UserModel?> getUserData() async {
    if (user != null) {
      final userService = UserService();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final userData = await userService.getUserData(currentUser.uid);

        return userData;
      }
    } else {
      return null;
    }
  }

}