import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'pdf_viewer_page.dart';

class RasayilPage extends StatefulWidget {
  const RasayilPage({super.key});

  @override
  State<RasayilPage> createState() => _RasayilPageState();
}

class _RasayilPageState extends State<RasayilPage> {
  @override
  void initState() {
    super.initState();
    // PDF will be loaded automatically by PDFView widget
  }

  Future<void> _clearCachedPdf() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final String pdfFileName =
          'The_Epistle_of_Paul_the_Apostle_to_the_Philippians_2.pdf';
      final String pdfPath = '$tempPath/$pdfFileName';

      final File pdfFile = File(pdfPath);
      if (await pdfFile.exists()) {
        await pdfFile.delete();
      }
    } catch (e) {
      // print('Error clearing cached PDF: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
        title: const Text('درس الكتاب'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/WhatsApp Image 2025-06-19 at 17.43.17_56b32cef.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.75)),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => PDFViewerPage(
                          filePath:
                              'assets/rasayil/The_Epistle_of_Paul_the_Apostle_to_the_Philippians_2.pdf',
                          title:
                              'The Epistle of Paul the Apostle to the Philippians',
                        ),
                  ),
                );
              },
              child: const Text('عرض الرسالة'),
            ),
          ),
        ],
      ),
    );
  }
}
