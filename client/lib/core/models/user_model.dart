// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:soptify_mvvm_riverpod/features/auth/model/fav_song_model.dart';

// data class a class can hold data

class UserModel {
  final String id;
  final String name;
  final String email;
  final String token;
  final List<FavSongModel> favorites;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.favorites,
  });

  // copy with
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    List<FavSongModel>? favorites,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      favorites: favorites ?? this.favorites,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      favorites: List<FavSongModel>.from((map['favorites'] ?? []).map<FavSongModel>((x) => FavSongModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  // to string
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, token: $token, favorites: $favorites)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'favorites': favorites.map((x) => x.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.token == token &&
      listEquals(other.favorites, favorites);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      token.hashCode ^
      favorites.hashCode;
  }
}
