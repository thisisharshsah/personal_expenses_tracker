import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/models.dart';

class AuthenticationRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserModel?> get user async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final userData = await firestore.collection('users').doc(user.uid).get();
      return UserModel(
        uid: user.uid,
        name: userData.get('name'),
        email: user.email!,
        walletAmount: userData.get('walletAmount'),
        primaryVariables: userData.get('primaryVariables')?.cast<String>(),
        secondaryVariables: userData.get('secondaryVariables')?.cast<String>(),
      );
    }
    return null;
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'name': name,
      'email': email,
      'walletAmount': '0',
      'primaryVariables': [],
      'secondaryVariables': [],
    });
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
