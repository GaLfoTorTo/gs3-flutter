// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PerfilModel {
  final int? id;
  final String? perfil;

  PerfilModel({
    this.id, 
    this.perfil
  });


  PerfilModel copyWith({
    int? id,
    String? perfil,
  }) {
    return PerfilModel(
      id: id ?? this.id,
      perfil: perfil ?? this.perfil,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'perfil': perfil,
    };
  }

  factory PerfilModel.fromMap(Map<String, dynamic> map) {
    return PerfilModel(
      id: map['id'] != null ? map['id'] as int : null,
      perfil: map['perfil'] != null ? map['perfil'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PerfilModel.fromJson(String source) => PerfilModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PerfilModel(id: $id, perfil: $perfil)';

  @override
  bool operator ==(covariant PerfilModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.perfil == perfil;
  }

  @override
  int get hashCode => id.hashCode ^ perfil.hashCode;
}
