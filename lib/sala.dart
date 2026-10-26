import 'package:flutter/material.dart';
import 'dart:async';
import 'prayer_details_page.dart';
import 'prayer_service.dart';

class SalaPage extends StatefulWidget {
  const SalaPage({super.key});

  @override
  State<SalaPage> createState() => _SalaPageState();
}

class _SalaPageState extends State<SalaPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentHour = DateTime.now().hour;
  String _currentPrayer = '';
  Map<String, Map<String, String>> _prayers = {};
  bool _isLoading = true;
  String? _error;
  final PrayerService _prayerService = PrayerService();

  final List<Map<String, String>> _dailyPrayers = [
    {'title': 'صلاة الشكر', 'prayer': 'محتوى صلاة الشكر...'},
    {'title': 'صلاة التوبة', 'prayer': 'محتوى صلاة التوبة...'},
    // أضف المزيد من الصلوات اليومية هنا
  ];

  // List of Orthodox prayer hours and their Arabic descriptions
  final List<Map<String, String>> _prayerHoursInfo = [
    {
      'title': 'صلاة باكر',
      'desc':
          'توافق الساعة السادسة صباحًا، وهي تُقال بعد الاستيقاظ أو بعد تسبحة نصف الليل في اليوم السابق.',
    },
    {
      'title': 'صلاة الساعة الثالثة',
      'desc': 'تُصَلَّى في الساعة التاسعة صباحًا.',
    },
    {
      'title': 'صلاة الساعة السادسة',
      'desc':
          'تُصَلَّى الساعة الثانية عشر ظهرًا (وهي تُصلى مع صلاة الساعة الثالثة قبل كل قداس إلهي في رفع البخور).',
    },
    {
      'title': 'صلاة الساعة التاسعة',
      'desc': 'توافق الثالثة ظهرًا. تُصلى كذلك في أيام الأصوام في القداس.',
    },
    {
      'title': 'صلاة الغروب',
      'desc':
          'أو صلاة الساعة الحادية عشر، وموعدها في الخامسة بعد الظهر (قبل حلول الليل).',
    },
    {
      'title': 'صلاة النوم',
      'desc':
          'تُصَلَّى في الساعة السادسة مساءً، وهي تُصلى عند حلول المساء، ويتم تلاوتها هي وصلاة الغروب قبل قداسات الصوم الكبير وصوم يونان (النبي).',
    },
    {'title': 'صلاة نصف الليل', 'desc': 'تُصَلَّى عند حلول منتصف الليل.'},
    {
      'title': 'صلاة السِتار',
      'desc': 'هي صلاة خاصة بالأباء الكهنة و الأباء الرهبان.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadPrayers();
    _determineCurrentPrayer();
    _startTimer();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  void _determineCurrentPrayer() {
    if (_prayers.isEmpty) {
      return; // Don't set current prayer if prayers aren't loaded yet
    }

    setState(() {
      if (_currentHour >= 6 && _currentHour < 9) {
        _currentPrayer = 'morning';
      } else if (_currentHour >= 9 && _currentHour < 12) {
        _currentPrayer = 'third_hour';
      } else if (_currentHour >= 12 && _currentHour < 15) {
        _currentPrayer = 'sixth_hour';
      } else if (_currentHour >= 15 && _currentHour < 18) {
        _currentPrayer = 'ninth_hour';
      } else if (_currentHour >= 18 && _currentHour < 21) {
        _currentPrayer = 'evening';
      } else if (_currentHour >= 21 || _currentHour < 6) {
        _currentPrayer = 'compline';
      }
    });
  }

  Future<void> _loadPrayers() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final prayers = await _prayerService.loadAllPrayers();

      setState(() {
        _prayers = prayers;
        _isLoading = false;
      });

      _determineCurrentPrayer();
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ في تحميل الصلوات';
        _isLoading = false;
      });
    }
  }

  void _startTimer() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      if (now.hour != _currentHour) {
        setState(() {
          _currentHour = now.hour;
        });
        _determineCurrentPrayer();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SafeArea(
            child: Column(
              children: [
                // Header
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                'صلاة السواعي',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Main Content
                Expanded(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _fadeController,
                      _slideController,
                    ]),
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [

                                // Hourly Prayers
                                _buildHourlyPrayers(),
                                const SizedBox(height: 30),
                                                                // Current Time and Prayer
                                _buildCurrentPrayerCard(),
                                const SizedBox(height: 30),

                                // Daily Prayers
                                _buildDailyPrayers(),
                                const SizedBox(height: 30),

                                // Orthodox Prayer Hours Info
                                _buildPrayerHoursInfo(),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPrayerCard() {
    if (_isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF39C12), Color(0xFFE67E22)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'جاري تحميل الصلوات...',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPrayers,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_prayers.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF39C12), Color(0xFFE67E22)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'لا توجد صلوات متاحة',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    }

    final currentPrayerData = _prayers[_currentPrayer];
    if (currentPrayerData == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3498DB).withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.access_time, color: Colors.white, size: 24),
              Text(
                '${_currentHour.toString().padLeft(2, '0')}:00',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            currentPrayerData['title']!,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            currentPrayerData['prayer']!,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyPrayers() {
    if (_prayers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صلوات السواعي',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: _prayers.length,
          itemBuilder: (context, index) {
            final prayerKey = _prayers.keys.elementAt(index);
            final prayerData = _prayers[prayerKey]!;
            final isCurrent = prayerKey == _currentPrayer;

            return _PrayerCard(
              title: prayerData['title']!,
              time: prayerData['time']!,
              isCurrent: isCurrent,
              onTap: () {
                setState(() {
                  _currentPrayer = prayerKey;
                });
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => PrayerDetailsPage(
                          title: prayerData['title']!,
                          content: prayerData['prayer']!,
                        ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDailyPrayers() {
    if (_dailyPrayers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الصلوات اليومية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _dailyPrayers.length,
          itemBuilder: (context, index) {
            final prayer = _dailyPrayers[index];
            return _DailyPrayerCard(
              title: prayer['title']!,
              prayer: prayer['prayer']!,
            );
          },
        ),
      ],
    );
  }

  // Widget to display the Orthodox prayer hours info
  Widget _buildPrayerHoursInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'مواعيد الصلوات الساعية الأرثوذكسية',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _prayerHoursInfo.length,
          itemBuilder: (context, index) {
            final item = _prayerHoursInfo[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${item['title']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3498DB),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['desc']!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      height: 1.5,
                    ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PrayerCard extends StatelessWidget {
  final String title;
  final String time;
  final bool isCurrent;
  final VoidCallback? onTap;

  const _PrayerCard({
    required this.title,
    required this.time,
    required this.isCurrent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color:
              isCurrent
                  ? const Color(0xFF3498DB)
                  : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border:
              isCurrent
                  ? Border.all(color: const Color(0xFF3498DB), width: 2)
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isCurrent ? Colors.white : Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isCurrent ? Colors.white : Colors.grey[400],
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            if (isCurrent) ...[
              const SizedBox(height: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DailyPrayerCard extends StatelessWidget {
  final String title;
  final String prayer;

  const _DailyPrayerCard({required this.title, required this.prayer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => PrayerDetailsPage(title: title, content: prayer),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            Text(
              prayer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[300],
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}
