import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  String? id;
  String? username;
  String? phoneNumber;
  String? email;

  UserProfile({
    this.id,
    this.username,
    this.phoneNumber,
    this.email,
  });

  toJson() {
    return {
      "accountUid": username,
      "phoneNumber": phoneNumber,
      "email": email,
    };
  }

  factory UserProfile.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserProfile(
      id: document.id,
      username: data["username"],
      phoneNumber: data["phoneNumber"],
      email: data["email"],
    );
  }
}
