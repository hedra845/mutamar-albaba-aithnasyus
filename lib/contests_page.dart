import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContestsPage extends StatelessWidget {
  final List<Map<String, String>> contests = [
    {
      'title': 'المسابقة الأولى',
      'description': 'شارك في المسابقة الأولى واربح جوائز قيمة!',
      'url':
          'https://docs.google.com/forms/d/e/1FAIpQLSdVliirneZUVLh366Gplfg70HbiD6jSgPRriLMal05DHFCDsg/viewform?usp=header', // ضع هنا رابط Google Form الحقيقي
    },
    {
      'title': 'المسابقة الثانية',
      'description': 'اختبر معلوماتك في المسابقة الثانية.',
      'url':
          'https://docs.google.com/forms/d/e/1FAIpQLScaMTkoeTZXMKBtcUYLZR6C8N4kzVNp40bkU8ZhshuLh9l4NA/viewform?usp=header',
    },
    {
      'title': 'المسابقة الثالثة',
      'description': 'شارك في المسابقة الثالثة وكن من الفائزين!',
      'url':
          'https://docs.google.com/forms/d/e/1FAIpQLScnsE-3ssTByrkt0XKrC-OP6HqPkRK0FD_ZETPxku-lqnfI9g/viewform?usp=header',
    },
  ];

  ContestsPage({super.key});

  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('لا يمكن فتح الرابط: $url'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء فتح الرابط: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المسابقات'),
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF1E1E1E),
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
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contests.length,
            itemBuilder: (context, index) {
              final contest = contests[index];
              return Card(
                color: Colors.white.withValues(alpha: 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contest['title']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        contest['description']!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _openUrl(context, contest['url']!),
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('فتح نموذج المسابقة'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
