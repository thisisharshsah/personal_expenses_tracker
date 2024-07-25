class UserModel {
  final String uid;
  final String name;
  final String email;
  final String walletAmount;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.walletAmount,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? walletAmount,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      walletAmount: walletAmount ?? this.walletAmount,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, walletAmount: $walletAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.walletAmount == walletAmount;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        walletAmount.hashCode;
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
