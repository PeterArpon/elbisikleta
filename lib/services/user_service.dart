import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create or update user in Firestore
  Future<void> saveUserData(User firebaseUser) async {
    final userRef = _db.collection('users').doc(firebaseUser.uid);
    
    // Check if user exists
    final userDoc = await userRef.get();
    
    if (!userDoc.exists) {
      // Create new user
      final newUser = UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        displayName: firebaseUser.displayName ?? 'User',
        photoURL: firebaseUser.photoURL,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );
      
      await userRef.set(newUser.toMap());
    } else {
      // Update existing user's last login
      await userRef.update({
        'lastLogin': Timestamp.now(),
        'displayName': firebaseUser.displayName,
        'photoURL': firebaseUser.photoURL,
      });
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? UserModel.fromMap(doc.data()!) : null;
  }
}