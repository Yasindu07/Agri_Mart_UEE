import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
class PriceReportsPage extends StatefulWidget {
  @override
  _PriceReportsPageState createState() => _PriceReportsPageState();
}

class _PriceReportsPageState extends State<PriceReportsPage> {
  final String baseUrl = "https://www.cbsl.gov.lk/sites/default/files/cbslweb_documents/statistics/pricerpt/price_report_";
  DateTime? selectedDate;

  List<String> getPast7Dates() {
    List<String> dates = [];
    DateTime today = DateTime.now();

    for (int i = 1; i < 8; i++) {
      DateTime pastDate = today.subtract(Duration(days: i));
      String formattedDate = "${pastDate.year}${pastDate.month.toString().padLeft(2, '0')}${pastDate.day.toString().padLeft(2, '0')}";
      dates.add(formattedDate);
    }

    return dates;
  }

Future<void> downloadPDF(String date) async {
  final String pdfUrl = "$baseUrl${date}_e.pdf";
  final Uri url = Uri.parse(pdfUrl);

  try {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication, // Ensure external browser or app is used
    )) {
      throw 'Could not launch $pdfUrl';
    }
  } catch (e) {
    // Show error message if the URL cannot be launched
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error launching PDF: $e')),
    );
    print('Error launching URL: $e');
  }
}

  Future<void> _selectDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime initialDate = selectedDate ?? today;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today.subtract(Duration(days: 30)),
      lastDate: today,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> dates = getPast7Dates();
    DateFormat formatter = DateFormat('EEE, d MMM yyyy');
    //"Daily Price Reports"
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("  Daily Price Reports",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF055A2F),
                  ),
                  
                ),
          
          SizedBox(height: 8.0),
         Container(
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(25.0), // Rounded corners
  ),
  child: Row(
    children: [
      // Select Date Button
      Expanded(
        flex: 2,
        child: ElevatedButton(
          onPressed: () => _selectDate(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(25.0)), // Rounded left side
            ),
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
            elevation: 0, // Remove shadow
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: Colors.black),
              SizedBox(width: 8.0), // Space between icon and text
              Expanded(
                child: Text(
                  selectedDate == null
                      ? "Select a date"
                      : DateFormat('EEE, d MMM yyyy').format(selectedDate!),
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      // Download Button
      Expanded(
        flex: 1,
        child: ElevatedButton(
          onPressed: selectedDate == null
              ? null
              : () {
                  String date = "${selectedDate!.year}${selectedDate!.month.toString().padLeft(2, '0')}${selectedDate!.day.toString().padLeft(2, '0')}";
                  downloadPDF(date);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF28A745),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(25.0)), // Rounded right side
            ),
            padding: EdgeInsets.symmetric(vertical: 12.0),
            elevation: 0, // Remove shadow
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.download, color: Colors.white),
              SizedBox(width: 4),
              Text(
                "Download",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: dates.length,
              itemBuilder: (context, index) {
                String date = dates[index];
                DateTime dateTime = DateTime.parse(
                    '${date.substring(0, 4)}-${date.substring(4, 6)}-${date.substring(6, 8)}');
                String formattedDate = formatter.format(dateTime);

                return Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: ElevatedButton(
    onPressed: () => downloadPDF(date),
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF28A745), // Background color
      padding: EdgeInsets.symmetric(horizontal: 33.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Border radius
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the content
      children: [
        Icon(Icons.download, color: Colors.white),
        SizedBox(width: 8), // Space between icon and text
        Text(
          formattedDate,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600, // Semibold
            color: Colors.white,
          ),
        ),
      ],
    ),
  ),
);
              },
            ),
          ),
        ],
      ),
    );
  }
}