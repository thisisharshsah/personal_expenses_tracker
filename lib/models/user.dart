class UserModel {
  final String uid;
  final String name;
  final String email;
  final String walletAmount;
  final List<String>? primaryVariables;
  final List<String>? secondaryVariables;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.walletAmount,
    this.primaryVariables,
    this.secondaryVariables,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? walletAmount,
    List<String>? primaryVariables,
    List<String>? secondaryVariables,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      walletAmount: walletAmount ?? this.walletAmount,
      primaryVariables: primaryVariables ?? this.primaryVariables,
      secondaryVariables: secondaryVariables ?? this.secondaryVariables,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, walletAmount: $walletAmount, primaryVariables: $primaryVariables, secondaryVariables: $secondaryVariables)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.walletAmount == walletAmount &&
        other.primaryVariables == primaryVariables &&
        other.secondaryVariables == secondaryVariables;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        walletAmount.hashCode ^
        primaryVariables.hashCode ^
        secondaryVariables.hashCode;
  }
}

class Variables {
  final String id;
  final String name;
  final String icon;

  Variables({
    required this.id,
    required this.name,
    required this.icon,
  });

  Variables copyWith({
    String? id,
    String? name,
    String? icon,
  }) {
    return Variables(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  @override
  String toString() {
    return 'Variables(id: $id, name: $name, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Variables &&
        other.id == id &&
        other.name == name &&
        other.icon == icon;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ icon.hashCode;
  }
}

class TransactionRecord {
  final String id;
  final String variableId;
  final String amount;
  final String createdAt;

  TransactionRecord({
    required this.id,
    required this.variableId,
    required this.amount,
    required this.createdAt,
  });

  TransactionRecord copyWith({
    String? id,
    String? variableId,
    String? amount,
    String? createdAt,
  }) {
    return TransactionRecord(
      id: id ?? this.id,
      variableId: variableId ?? this.variableId,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'TransactionRecord(id: $id, variableId: $variableId, amount: $amount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransactionRecord &&
        other.id == id &&
        other.variableId == variableId &&
        other.amount == amount &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        variableId.hashCode ^
        amount.hashCode ^
        createdAt.hashCode;
  }
}
