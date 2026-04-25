import 'package:flutter/material.dart';
import '../models/topic_model.dart';
import '../widgets/animated_info_card.dart';
import '../widgets/diagram_widget.dart';
import '../widgets/example_widget.dart';
import '../widgets/topic_showcase_animation.dart';
import '../theme/app_theme.dart';

class TopicScreen extends StatefulWidget {
  final TopicModel topic;
  const TopicScreen({super.key, required this.topic});
  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> with TickerProviderStateMixin {
  late AnimationController _headerCtrl;
  late AnimationController _cardsCtrl;
  late Animation<Offset>   _headerSlide;
  late Animation<double>   _headerFade;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didUpdateWidget(TopicScreen old) {
    super.didUpdateWidget(old);
    if (old.topic != widget.topic) {
      _headerCtrl.dispose();
      _cardsCtrl.dispose();
      _setupAnimations();
    }
  }

  void _setupAnimations() {
    _headerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _cardsCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 950));

    _headerSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));
    _headerFade  = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);

    _headerCtrl.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _cardsCtrl.forward();
    });
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _cardsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color  = widget.topic.primaryColor;
    final color2 = widget.topic.secondaryColor;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Hero Header ───────────────────────────────────────────────
          SlideTransition(
            position: _headerSlide,
            child: FadeTransition(
              opacity: _headerFade,
              child: _buildHeroHeader(color, color2),
            ),
          ),

          const SizedBox(height: 16),

          // ── Showcase Animation ────────────────────────────────────────
          FadeTransition(
            opacity: _headerFade,
            child: TopicShowcaseAnimation(topic: widget.topic, topicTitle: widget.topic.title),
          ),

          const SizedBox(height: 4),

          // ── Section label ─────────────────────────────────────────────
          _sectionLabel('Key Concepts', color),
          const SizedBox(height: 8),

          // ── Info Cards ────────────────────────────────────────────────
          ...widget.topic.cards.asMap().entries.map((e) => AnimatedInfoCard(
            controller: _cardsCtrl,
            delay: e.key * 0.15,
            cardData: e.value,
            accentColor: color,
          )),

          const SizedBox(height: 16),

          // ── Section label ─────────────────────────────────────────────
          _sectionLabel('Concept Diagram', color),
          const SizedBox(height: 8),

          // ── Diagram ───────────────────────────────────────────────────
          FadeTransition(
            opacity: _headerFade,
            child: DiagramWidget(topic: widget.topic),
          ),

          const SizedBox(height: 16),

          // ── Section label ─────────────────────────────────────────────
          _sectionLabel('Code Example', color),
          const SizedBox(height: 8),

          // ── Code Example ──────────────────────────────────────────────
          ExampleWidget(topic: widget.topic),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(Color color, Color color2) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: color.withOpacity(0.20), width: 1),
        boxShadow: AppTheme.cardShadow(color),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Stack(
          children: [
            // Subtle gradient wash in top-right corner
            Positioned(
              top: -30, right: -30,
              child: Container(
                width: 160, height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [color.withOpacity(0.12), Colors.transparent],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon badge
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          boxShadow: AppTheme.glowShadow(color),
                        ),
                        child: Icon(widget.topic.icon, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.topic.title, style: AppTheme.headingLg),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _badge(widget.topic.level, color),
                                const SizedBox(width: 8),
                                _badge('Flutter', AppTheme.textMuted),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Gradient divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.6), color2.withOpacity(0.2), Colors.transparent],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(widget.topic.description, style: AppTheme.body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 3, height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)],
          ),
        ),
        const SizedBox(width: 8),
        Text(text.toUpperCase(),
            style: AppTheme.caption.copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
            )),
      ],
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w600, letterSpacing: 0.2)),
    );
  }
}