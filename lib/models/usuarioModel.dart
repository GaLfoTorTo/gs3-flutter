// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gs3_flutter/models/perfilModel.dart';

class UsuarioModel {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final PerfilModel? perfil;
  final String? token;

  UsuarioModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.perfil,
    this.token
  });

  UsuarioModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    PerfilModel? perfil,
    String? token,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      perfil: perfil ?? this.perfil,
      token: token ?? this.token,
    );
  }

  UsuarioModel copyWithMap({
    Map<String, dynamic>? updates,
  }) {
    return UsuarioModel(
      id: updates?['id'] ?? id,
      name: updates?['name'] ?? name,
      email: updates?['email'] ?? email,
      password: updates?['password'] ?? password,
      perfil: updates?['perfil'] ?? perfil,
      token: updates?['token'] ?? token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'perfil': perfil?.toMap(),
      'token': token,
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      perfil: map['perfil'] != null ? PerfilModel.fromMap(map['perfil'] as Map<String,dynamic>) : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioModel.fromJson(String source) => UsuarioModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UsuarioModel(id: $id, name: $name, email: $email, password: $password, perfil: $perfil, token: $token)';
  }

  @override
  bool operator ==(covariant UsuarioModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.password == password &&
      other.perfil == perfil &&
      other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      perfil.hashCode ^
      token.hashCode;
  }
}
