import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmerFaq extends StatefulWidget {
  @override
  State<FarmerFaq> createState() => _FarmerFaqState();
}

class _FarmerFaqState extends State<FarmerFaq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: [
          FAQItem(
            question: 'How do I sign up for the AgriMart app?',
            answer:
                'You can sign up by downloading the app from the App Store or Play Store and following the registration process.',
          ),
          FAQItem(
            question: 'What type of produce can I sell through the app?',
            answer:
                'You can list any kind of farm produce, including fruits, vegetables, grains, and more. Make sure the produce complies with local regulations and is available for immediate sale.',
          ),
          FAQItem(
            question: 'How do I sign up for the AgriMart app?',
            answer:
                'You can sign up by downloading the app from the App Store or Play Store and following the registration process.',
          ),
          FAQItem(
            question: 'How do I sign up for the AgriMart app?',
            answer:
                'You can sign up by downloading the app from the App Store or Play Store and following the registration process.',
          ),
          FAQItem(
            question: 'How do I sign up for the AgriMart app?',
            answer:
                'You can sign up by downloading the app from the App Store or Play Store and following the registration process.',
          ),
          FAQItem(
            question: 'How do I sign up for the AgriMart app?',
            answer:
                'You can sign up by downloading the app from the App Store or Play Store and following the registration process.',
          ),
          FAQItem(
            question: 'How do I sign up for the AgriMart app?',
            answer:
                'You can sign up by downloading the app from the App Store or Play Store and following the registration process.',
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, top: 10),
      child: Flexible(
        // Allow ExpansionTile to be flexible in height
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
              title: Text(
                widget.question,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    widget.answer,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
              collapsedBackgroundColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              iconColor: Theme.of(context).colorScheme.primary,
              collapsedIconColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
