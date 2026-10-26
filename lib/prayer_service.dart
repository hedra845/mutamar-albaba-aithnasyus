import 'package:flutter/services.dart';

class PrayerService {
  static final PrayerService _instance = PrayerService._internal();
  factory PrayerService() => _instance;
  PrayerService._internal();

  // Cache for loaded prayers
  final Map<String, String> _prayerCache = {};

  /// Load prayer content from assets
  Future<String> loadPrayerContent(String prayerName) async {
    // Check cache first
    if (_prayerCache.containsKey(prayerName)) {
      return _prayerCache[prayerName]!;
    }

    try {
      // Load from assets
      final String content = await rootBundle.loadString(
        'assets/prayers/$prayerName.txt',
      );

      // Cache the content
      _prayerCache[prayerName] = content;

      return content;
    } catch (e) {
      // Return default content if file not found
      return 'محتوى الصلاة غير متوفر حالياً';
    }
  }

  /// Load all prayers
  Future<Map<String, Map<String, String>>> loadAllPrayers() async {
    final Map<String, Map<String, String>> prayers = {
      'morning': {
        'title': 'صلاة باكر',
        'time': '06:00',
        'prayer': await loadPrayerContent('bakr'),
      },
      'third_hour': {
        'title': 'صلاة الساعة الثالثة',
        'time': '09:00',
        'prayer': await loadPrayerContent('third_hour'),
      },
      'sixth_hour': {
        'title': 'صلاة الساعة السادسة',
        'time': '12:00',
        'prayer': await loadPrayerContent('sixth_hour'),
      },
      'ninth_hour': {
        'title': 'صلاة الساعة التاسعة',
        'time': '15:00',
        'prayer': await loadPrayerContent('ninth_hour'),
      },
      'evening': {
        'title': 'صلاة الغروب',
        'time': '18:00',
        'prayer': await loadPrayerContent('evening'),
      },
      'compline': {
        'title': 'صلاة النوم',
        'time': '21:00',
        'prayer': await loadPrayerContent('compline'),
      },
      'midnight': {
        'title': 'صلاة نصف الليل',
        'time': '00:00',
        'prayer': await loadPrayerContent('midnight'),
      },
    };

    return prayers;
  }

  /// Clear cache
  void clearCache() {
    _prayerCache.clear();
  }
}
