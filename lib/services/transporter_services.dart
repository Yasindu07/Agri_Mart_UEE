import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransporterService {
  final CollectionReference transporterCollection =
      FirebaseFirestore.instance.collection('transporter');

  User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentReference> addTranspoterDetails(
      String id,
      String licensePlate,
      String licenseNumber,
      String licenseImageUrl,
      String insuranceImageUrl,
      String bankName,
      String accountNumber) async {
    return await transporterCollection.add({
      'id': user!.uid,
      'licensePlate': licensePlate,
      'licenseNumber': licenseNumber,
      'licenseImageUrl': licenseImageUrl,
      'insuranceImageUrl': insuranceImageUrl,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'isTransporterDetailsSubmitted': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
