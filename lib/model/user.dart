import 'package:flutter/material.dart';

class User {
  String? user;
  String? email;
  String? pass;
  String? id;
  DateTime? createAt;

  User({
    required this.user,
    required this.email,
    this.pass,
    this.id,
    this.createAt,
  });

  @override
  String toString() {
    return 'User{id: $id, name: $user, email: $email, create: $createAt}';
  }
}
