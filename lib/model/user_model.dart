// import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid; // Firebase Auth User ID
  String name;
  String email;
  String address;
  String phoneNo;

  // Constructor
  UserModel({
    this.uid,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNo,
  });

  // Convert UserModel to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
      'phoneNo': phoneNo,
    };
  }

  // Convert a Firebase document snapshot to a UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
    );
  }
}
