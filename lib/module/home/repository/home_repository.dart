import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/models.dart';

class HomeRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserModel?> get loggedInUser async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final userData = await firestore.collection('users').doc(user.uid).get();
      return UserModel(
        uid: user.uid,
        name: userData.get('name'),
        email: user.email!,
        walletAmount: userData.get('walletAmount'),
      );
    }
    return null;
  }

  Future<void> addAmountToWallet({
    required String amount,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final userData = await firestore.collection('users').doc(user.uid).get();
      await firestore.collection('users').doc(user.uid).update({
        'walletAmount':
            '${int.parse(userData.get('walletAmount')) + int.parse(amount)}',
      });
    }
  }
}
