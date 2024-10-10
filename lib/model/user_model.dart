class UserModel {
  final String? uid;
  final String? email;
  final String name; // Required parameter
  final String address; // Required parameter

  final String phoneNo; // Required parameter

  //final String? profileImageUrl; // Optional parameter
  final String? profilePicture;

  UserModel({
    this.uid,
    this.email,
    required this.name,
    required this.address,
    required this.phoneNo,
    this.profilePicture,
  });

  // Convert UserModel instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'address': address,
      'phoneNo': phoneNo,
      'profileImageUrl': profilePicture,
    };
  }
}
