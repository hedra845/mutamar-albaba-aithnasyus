import 'package:flutter/material.dart';

class PrayerDetailsPage extends StatelessWidget {
  final String title;
  final String content;

  const PrayerDetailsPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.7,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
