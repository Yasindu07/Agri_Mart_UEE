import 'package:agro_mart/model/transporter_model.dart';
import 'package:agro_mart/screens/transporter_screen.dart';
import 'package:agro_mart/screens/transpoter/TransporterForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools;

class FormOrHome extends StatefulWidget {
  @override
  _FormOrHomeState createState() => _FormOrHomeState();
}

class _FormOrHomeState extends State<FormOrHome> {
  bool? _isTransporterDetailsSubmitted;
  bool _isLoading = true;
  Transporter? transporterModel;

  @override
  void initState() {
    super.initState();
    _checkTransporterDetails();
  }

  // Fetch and check the transporter details from Firestore
  Future<void> _checkTransporterDetails() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      devtools.log('User UID: ${user.uid}');

      try {
        // Fetch the user's document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        devtools.log('User Document Data: ${userDoc.data().toString()}');

        // Check if the user role is 'transporter'
        if (userDoc.exists && userDoc['role'] == 'transporter') {
          // Fetch all documents from the 'transporter' collection
          QuerySnapshot transporterSnapshot =
              await FirebaseFirestore.instance.collection('transporter').get();

          devtools
              .log('Transporter Documents Found: ${transporterSnapshot.size}');

          if (transporterSnapshot.size > 0) {
            _isTransporterDetailsSubmitted = true;
          }

          // if (transporterSnapshot.docs.isNotEmpty) {
          //   // Map each document to a Transporter model and find the specific user
          //   transporterModel = transporterSnapshot.docs
          //       .map((doc) => Transporter.fromDocumentSnapshot(doc))
          //       .firstWhere((transporter) => transporter.id == user.uid,
          //           orElse: () => null);

          //   if (transporterSnapshot.size > 0) {
          //     _isTransporterDetailsSubmitted = true;
          //   }

          //   if (transporterModel != null) {
          //     devtools.log(
          //         'Transporter Document Exists: ${transporterModel.toString()}');

          //     setState(() {
          //       _isTransporterDetailsSubmitted = true;
          //     });
          //     devtools.log('$_isTransporterDetailsSubmitted');

          //     devtools.log(
          //         'Transporter Model Detail: ${transporterModel.toString()}');
          //   } else {
          //     devtools
          //         .log('No Transporter details found for user: ${user.uid}');
          //   }
          // } else {
          //   devtools.log('No transporter documents found.');
          // }
        } else {
          devtools.log(
              'User is not a transporter or user document does not exist.');
        }
      } catch (e) {
        devtools.log('Error fetching transporter details: $e');
      }
    } else {
      devtools.log('User is null.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // If transporter details are already submitted, navigate to the Transporter Home Page
    if (_isTransporterDetailsSubmitted == true) {
      return TransporterScreen(); // Transporter home page widget
    } else {
      return TransporterFormPage();
    }

    // Otherwise, show the form to submit transporter details
  }
}
