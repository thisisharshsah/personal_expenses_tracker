import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../global/utils/utils.dart';
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
        primaryVariables: List<String>.from(
          userData.get('primaryVariables'),
        ),
        secondaryVariables: List<String>.from(
          userData.get('secondaryVariables'),
        ),
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

  Future<void> addRecord({
    required String variableId,
    required String amount,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final userData = await firestore.collection('users').doc(user.uid).get();
      final walletAmount = int.parse(userData.get('walletAmount'));
      final recordAmount = int.parse(amount);
      if (walletAmount >= recordAmount) {
        await firestore.collection('records').add({
          'userId': user.uid,
          'variableId': variableId,
          'amount': amount,
          'createdAt': Timestamp.now(),
        });
        await firestore.collection('users').doc(user.uid).update({
          'walletAmount': '${walletAmount - recordAmount}',
        });
      } else {
        throw Exception('Insufficient balance');
      }
    }
  }

  Future<int> getAmountSpentThisMonth() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final records = await firestore
          .collection('records')
          .where('userId', isEqualTo: user.uid)
          .get();
      final currentMonth = DateTime.now().month;
      return records.docs.fold<int>(
        0,
        (previousValue, record) {
          final recordDate = record.get('createdAt').toDate();
          if (recordDate.month == currentMonth) {
            return previousValue + int.parse(record.get('amount'));
          }
          return previousValue;
        },
      );
    }
    return 0;
  }

  Future<int> getAmountByVariableId({
    required String variableId,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final records = await firestore
          .collection('records')
          .where('userId', isEqualTo: user.uid)
          .where('variableId', isEqualTo: variableId)
          .get();
      return records.docs.fold<int>(
        0,
        (previousValue, record) =>
            previousValue + int.parse(record.get('amount')),
      );
    }
    return 0;
  }

  Future<List<TransactionRecord>> getRecords() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final records = await firestore
          .collection('records')
          .where('userId', isEqualTo: user.uid)
          .get();
      return records.docs
          .map(
            (record) => TransactionRecord(
              id: record.id,
              variableId: record.get('variableId'),
              amount: record.get('amount'),
              createdAt: convertTimestamp(record.get('createdAt')),
            ),
          )
          .toList();
    }
    return [];
  }



  Future<List<Variables>> getVariables() async {
    final variables = await firestore.collection('variables').get();
    return variables.docs
        .map((variable) => Variables(
              id: variable.id,
              name: variable.get('name'),
              icon: variable.get('icon'),
            ))
        .toList();
  }

  Future<void> updatePrimaryVariables({
    required List<String> primaryVariables,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      await firestore.collection('users').doc(user.uid).update({
        'primaryVariables': primaryVariables,
      });
    }
  }

  Future<void> updateSecondaryVariables({
    required List<String> secondaryVariables,
  }) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      await firestore.collection('users').doc(user.uid).update({
        'secondaryVariables': secondaryVariables,
      });
    }
  }
}
