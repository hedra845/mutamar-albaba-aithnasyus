import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class PDFViewerPage extends StatefulWidget {
  final String filePath;
  final String title;

  const PDFViewerPage({super.key, required this.filePath, required this.title});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localPath;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    try {
      // Load PDF from assets and write to temp file
      final bytes = await rootBundle.load(widget.filePath);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.filePath.split('/').last}');
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      setState(() {
        localPath = file.path;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'حدث خطأ في تحميل ملف PDF: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : _errorMessage != null
              ? Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : localPath != null
              ? PDFView(
                filePath: localPath!,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: true,
                pageFling: true,
              )
              : const Center(
                child: Text(
                  'لم يتم العثور على الملف',
                  style: TextStyle(color: Colors.white),
                ),
              ),
    );
  }
}
