import 'dart:convert';

class UserModel {
  final String email;
  final String name;
  final String typeuser;
  UserModel({
    this.email,
    this.name,
    this.typeuser,
  });

  UserModel copyWith({
    String email,
    String name,
    String typeuser,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      typeuser: typeuser ?? this.typeuser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'typeuser': typeuser,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return UserModel(
      email: map['email'],
      name: map['name'],
      typeuser: map['typeuser'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserModel(email: $email, name: $name, typeuser: $typeuser)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserModel &&
      o.email == email &&
      o.name == name &&
      o.typeuser == typeuser;
  }

  @override
  int get hashCode => email.hashCode ^ name.hashCode ^ typeuser.hashCode;
}
