import 'package:cloud_firestore/cloud_firestore.dart';

class Transporter {
  final String id;
  final String licensePlate;
  final String licenseNumber;
  final String licenseImageUrl;
  final String insuranceImageUrl;
  final String bankName;
  final String accountNumber;
  bool isTransporterDetailsSubmitted = false;
  final Timestamp timestamp;

  Transporter(
      {required this.id,
      required this.licensePlate,
      required this.licenseNumber,
      required this.licenseImageUrl,
      required this.insuranceImageUrl,
      required this.bankName,
      required this.accountNumber,
      required this.isTransporterDetailsSubmitted,
      required this.timestamp});

  static fromDocumentSnapshot(DocumentSnapshot<Object?> transporterDoc) {}
}
