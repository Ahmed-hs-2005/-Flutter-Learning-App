import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {

  // Orchestration controller — drives the entire entry sequence
  late AnimationController _entryCtrl;

  // Floating particles background
  late AnimationController _particleCtrl;

  // Button pulse
  late AnimationController _pulseCtrl;

  // Individual animations
  late Animation<double>  _logoScale;
  late Animation<double>  _logoFade;
  late Animation<Offset>  _titleSlide;
  late Animation<double>  _titleFade;
  late Animation<Offset>  _subtitleSlide;
  late Animation<double>  _subtitleFade;
  late Animation<double>  _chipsFade;
  late Animation<Offset>  _chipsSlide;
  late Animation<double>  _btnFade;
  late Animation<Offset>  _btnSlide;
  late Animation<double>  _pulse;

  final _topics = [
    _TopicChip('Widgets',          AppTheme.accentAmber,  Icons.widgets_outlined),
    _TopicChip('Layouts',          AppTheme.accentTeal,   Icons.dashboard_outlined),
    _TopicChip('Navigation',       AppTheme.accentBlue,   Icons.route_outlined),
    _TopicChip('State Management', AppTheme.accentViolet, Icons.hub_outlined),
    _TopicChip('Animations',       AppTheme.accentCoral,  Icons.animation_outlined),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200));
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);

    // ── Logo: 0–30%
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.0, 0.35, curve: Curves.elasticOut)));
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.0, 0.25, curve: Curves.easeOut)));

    // ── Title: 25–55%
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
        CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.25, 0.55, curve: Curves.easeOutCubic)));
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.25, 0.50, curve: Curves.easeOut)));

    // ── Subtitle: 40–65%
    _subtitleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.40, 0.65, curve: Curves.easeOutCubic)));
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.40, 0.62, curve: Curves.easeOut)));

    // ── Chips: 55–80%
    _chipsSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.55, 0.82, curve: Curves.easeOutCubic)));
    _chipsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.55, 0.78, curve: Curves.easeOut)));

    // ── Button: 72–100%
    _btnSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
        CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.72, 1.0, curve: Curves.easeOutCubic)));
    _btnFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.72, 0.95, curve: Curves.easeOut)));

    _pulse = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // Start the sequence after a brief pause
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _particleCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _goToHome() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: AnimatedBuilder(
        animation: Listenable.merge([_entryCtrl, _particleCtrl, _pulseCtrl]),
        builder: (_, __) {
          return Stack(
            children: [

              // ── Background particles ─────────────────────────────────
              CustomPaint(
                painter: _ParticlePainter(_particleCtrl.value),
                child: const SizedBox.expand(),
              ),

              // ── Radial glow center ───────────────────────────────────
              Positioned(
                top: size.height * 0.18,
                left: size.width / 2 - 140,
                child: Container(
                  width: 280, height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.accentBlue.withOpacity(0.10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Main content ─────────────────────────────────────────
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),

                        // ── Logo ───────────────────────────────────────
                        FadeTransition(
                          opacity: _logoFade,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: _buildLogo(),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ── Title ──────────────────────────────────────
                        FadeTransition(
                          opacity: _titleFade,
                          child: SlideTransition(
                            position: _titleSlide,
                            child: _buildTitle(),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ── Subtitle ───────────────────────────────────
                        FadeTransition(
                          opacity: _subtitleFade,
                          child: SlideTransition(
                            position: _subtitleSlide,
                            child: _buildSubtitle(),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ── Topic chips ────────────────────────────────
                        FadeTransition(
                          opacity: _chipsFade,
                          child: SlideTransition(
                            position: _chipsSlide,
                            child: _buildChips(),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // ── CTA Button ─────────────────────────────────
                        FadeTransition(
                          opacity: _btnFade,
                          child: SlideTransition(
                            position: _btnSlide,
                            child: _buildButton(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Footer ─────────────────────────────────────
                        FadeTransition(
                          opacity: _btnFade,
                          child: Text(
                            '5 topics  ·  Live animations  ·  Code examples',
                            style: AppTheme.caption.copyWith(letterSpacing: 0.4),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Logo Widget ─────────────────────────────────────────────────────────────
  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 110, height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.accentBlue.withOpacity(0.15), width: 1),
          ),
        ),
        // Inner glow ring
        Container(
          width: 90, height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.accentBlue.withOpacity(0.25), width: 1),
          ),
        ),
        // Logo badge
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2D3FE0), Color(0xFF54C5F8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(color: const Color(0xFF54C5F8).withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 8)),
              BoxShadow(color: const Color(0xFF2D3FE0).withOpacity(0.40), blurRadius: 14, offset: const Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.flutter_dash, color: Colors.white, size: 38),
        ),
      ],
    );
  }

  // ── Title ───────────────────────────────────────────────────────────────────
  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Flutter Learn',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 36,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
            height: 1.1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        // Accent underline
        Center(
          child: Container(
            width: 48, height: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2D3FE0), Color(0xFF54C5F8)],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [BoxShadow(color: AppTheme.accentBlue.withOpacity(0.5), blurRadius: 8)],
            ),
          ),
        ),
      ],
    );
  }

  // ── Subtitle ────────────────────────────────────────────────────────────────
  Widget _buildSubtitle() {
    return Text(
      'Learn Flutter concepts through\nlive animations and real code examples.',
      style: AppTheme.body.copyWith(
        fontSize: 15,
        height: 1.6,
        color: AppTheme.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }

  // ── Topic Chips ─────────────────────────────────────────────────────────────
  Widget _buildChips() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: _topics.map((t) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: t.color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: t.color.withOpacity(0.25), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(t.icon, color: t.color, size: 13),
              const SizedBox(width: 6),
              Text(t.label,
                  style: TextStyle(
                    color: t.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── CTA Button ──────────────────────────────────────────────────────────────
  Widget _buildButton() {
    return ScaleTransition(
      scale: _pulse,
      child: GestureDetector(
        onTap: _goToHome,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2D3FE0), Color(0xFF54C5F8)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: const Color(0xFF2D3FE0).withOpacity(0.45), blurRadius: 20, offset: const Offset(0, 8)),
              BoxShadow(color: const Color(0xFF54C5F8).withOpacity(0.20), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Start Learning',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Floating Particles Background ───────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final double t;
  static final _rng = Random(42);
  static final _particles = List.generate(28, (_) => [
    _rng.nextDouble(), // x
    _rng.nextDouble(), // y
    _rng.nextDouble(), // speed
    _rng.nextDouble(), // size
    _rng.nextInt(5),   // color index
  ]);

  static const _colors = [
    AppTheme.accentAmber,
    AppTheme.accentTeal,
    AppTheme.accentBlue,
    AppTheme.accentViolet,
    AppTheme.accentCoral,
  ];

  _ParticlePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in _particles) {
      final x  = (p[0] as double) * size.width;
      final yBase = (p[1] as double) * size.height;
      final speed = 0.3 + (p[2] as double) * 0.7;
      final sz    = 1.5 + (p[3] as double) * 2.5;
      final ci    = p[4] as int;

      // Float upward slowly
      final y = (yBase - t * speed * size.height * 0.25) % size.height;
      final opacity = 0.08 + sin(t * 2 * pi * speed + yBase) * 0.06;

      canvas.drawCircle(
        Offset(x, y),
        sz,
        Paint()..color = _colors[ci].withOpacity(opacity.clamp(0.04, 0.18)),
      );
    }
  }

  @override bool shouldRepaint(_ParticlePainter o) => true;
}

// ── Topic Chip Model ─────────────────────────────────────────────────────────
class _TopicChip {
  final String label;
  final Color color;
  final IconData icon;
  const _TopicChip(this.label, this.color, this.icon);
}