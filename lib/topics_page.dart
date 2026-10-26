import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  // Sample topics data - you can replace with your actual topics
  final List<Map<String, dynamic>> _topics = [
    {
      'title': 'الموضوع PDF',
      'subtitle': 'عرض ملف PDF',
      'description': 'مثال على عرض ملف PDF',
      'filePath': 'assets/topics/topics3.pdf',
      'fileType': 'pdf',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
        title: const Text(
          'المواضيع',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
          Column(
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.library_books,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'استكشف المواضيع المتاحة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'اختر موضوعاً لقراءة المحتوى',
                      style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Topics list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _topics.length,
                  itemBuilder: (context, index) {
                    final topic = _topics[index];
                    return _TopicCard(
                      title: topic['title'],
                      subtitle: topic['subtitle'],
                      description: topic['description'],
                      icon: topic['icon'],
                      color: topic['color'],
                      onTap:
                          () => _openFile(
                            topic['filePath'],
                            topic['title'],
                            topic['fileType'],
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openFile(String filePath, String title, String fileType) {
    // Show a dialog indicating file viewing
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF2C3E50),
            title: Text(
              'عرض الملف',
              style: const TextStyle(color: Colors.white),
            ),
            content: Text(
              'سيتم فتح ملف $fileType للموضوع: $title',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showFileViewer(filePath, title, fileType);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('فتح', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _showFileViewer(String filePath, String title, String fileType) {
    // Load and display the actual file content
    if (fileType == 'pdf') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PDFViewerPage(filePath: filePath, title: title),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => FileViewerPage(filePath: filePath, title: title),
        ),
      );
    }
  }
}

class _TopicCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TopicCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<_TopicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.withValues(alpha: 0.8),
                    widget.color.withValues(alpha: 0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  onTapDown: (_) {
                    _controller.forward();
                  },
                  onTapUp: (_) {
                    _controller.reverse();
                  },
                  onTapCancel: () {
                    _controller.reverse();
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.icon,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.subtitle,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Arrow icon
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FileViewerPage extends StatefulWidget {
  final String filePath;
  final String title;

  const FileViewerPage({
    super.key,
    required this.filePath,
    required this.title,
  });

  @override
  State<FileViewerPage> createState() => _FileViewerPageState();
}

class _FileViewerPageState extends State<FileViewerPage> {
  bool _isLoading = true;
  String? _errorMessage;
  String? _fileContent;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    try {
      // Load the actual file content
      final String content = await DefaultAssetBundle.of(
        context,
      ).loadString(widget.filePath);
      setState(() {
        _isLoading = false;
        _fileContent = content;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'حدث خطأ في تحميل الملف: $e';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C3E50), Color(0xFF34495E), Color(0xFF1E1E1E)],
          ),
        ),
        child: Center(
          child:
              _isLoading
                  ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'جاري تحميل الملف...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  )
                  : _errorMessage != null
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'إعادة المحاولة',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.article,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Text(
                            _fileContent ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}

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
