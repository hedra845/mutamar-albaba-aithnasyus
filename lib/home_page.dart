import 'package:flutter/material.dart';
import 'sala.dart';
import 'topics_page.dart';
import 'contests_page.dart';
import 'rasayil.dart';
import 'image_gallery_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Button data with icons and colors
  final List<Map<String, dynamic>> _buttons = [
    {
      'title': 'الصلاة',
      'icon': Icons.church,
      'color': Colors.blue,
      'gradient': [Colors.blue, Colors.blueAccent],
      'route': 'prayers',
    },
    {
      'title': 'المواضيع',
      'icon': Icons.message,
      'color': Colors.red,
      'gradient': [Colors.red, Colors.redAccent],
      'route': 'messages',
    },
    {
      'title': 'المسابقات',
      'icon': Icons.emoji_events,
      'color': Colors.green,
      'gradient': [Colors.green, Colors.lightGreen],
      'route': 'contests',
    },
    {
      'title': 'درس الكتاب',
      'icon': Icons.book,
      'color': Colors.brown,
      'gradient': [Colors.brown, Colors.orange],
      'route': 'rasayil',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }

  void _handleButtonTap(String route) {
    switch (route) {
      case 'prayers':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const SalaPage()));
        break;
      case 'messages':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const TopicsPage()));
        break;
      case 'contests':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => ContestsPage()));
        break;
      case 'rasayil':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const RasayilPage()));
        break;
      default:
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Coming Soon'),
                content: const Text('This feature is coming soon!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Mutamar Alianiba Antwnius',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                      _scaleController,
                    ]),
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                // Section Title
                                const Text(
                                  'ازيك يا صديقي',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'تقدر من هنا تدوس علي الحاجة الي انت عايزها',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // Button Grid
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 16,
                                          mainAxisSpacing: 16,
                                          childAspectRatio: 1.2,
                                        ),
                                    itemCount: _buttons.length,
                                    itemBuilder: (context, index) {
                                      return _AnimatedButton(
                                        title: _buttons[index]['title'],
                                        icon: _buttons[index]['icon'],
                                        gradient: _buttons[index]['gradient'],
                                        onTap:
                                            () => _handleButtonTap(
                                              _buttons[index]['route'],
                                            ),
                                      );
                                    },
                                  ),
                                ),

                                // Add the image gallery button
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.photo_library),
                                    label: const Text('جدول المواعيد'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(48),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ImageGalleryPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
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
}

class _AnimatedButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _AnimatedButton({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _elevationAnimation = Tween<double>(
      begin: 8.0,
      end: 16.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient[0].withValues(alpha: 0.3),
                    blurRadius: _elevationAnimation.value,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.gradient,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with animation
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          transform:
                              _isHovered
                                  ? (Matrix4.identity()..scale(1.2))
                                  : Matrix4.identity(),
                          child: Icon(
                            widget.icon,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Title
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Hover indicator
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: _isHovered ? 30 : 0,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
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
