import 'package:flutter/material.dart';
import '../models/topic_model.dart';
import '../theme/app_theme.dart';

class AnimatedInfoCard extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final CardData cardData;
  final Color accentColor;

  const AnimatedInfoCard({
    super.key,
    required this.controller,
    required this.delay,
    required this.cardData,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final start = delay.clamp(0.0, 0.85);
    final end   = (delay + 0.3).clamp(0.1, 1.0);

    final slideAnim = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: controller, curve: Interval(start, end, curve: Curves.easeOutCubic)),
    );
    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Interval(start, end, curve: Curves.easeOut)),
    );

    return SlideTransition(
      position: slideAnim,
      child: FadeTransition(opacity: fadeAnim, child: _ExpandableCard(cardData: cardData, accentColor: accentColor)),
    );
  }
}

class _ExpandableCard extends StatefulWidget {
  final CardData cardData;
  final Color accentColor;
  const _ExpandableCard({required this.cardData, required this.accentColor});

  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<_ExpandableCard> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _ctrl;
  late Animation<double>   _expandAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _expandAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      _expanded ? _ctrl.forward() : _ctrl.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor;

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: _expanded ? AppTheme.surfaceHigh : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: _expanded ? color.withOpacity(0.30) : AppTheme.surfaceBorder,
            width: 1,
          ),
          boxShadow: _expanded
              ? [BoxShadow(color: color.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 6))]
              : AppTheme.subtleShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon with animated tint
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 320),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: _expanded ? color.withOpacity(0.15) : AppTheme.surfaceHigh,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(
                        color: _expanded ? color.withOpacity(0.25) : AppTheme.border,
                        width: 1,
                      ),
                    ),
                    child: Icon(widget.cardData.icon,
                        color: _expanded ? color : AppTheme.textSecondary, size: 15),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(widget.cardData.title,
                        style: AppTheme.headingSm.copyWith(
                          color: _expanded ? AppTheme.textPrimary : AppTheme.textSecondary,
                        )),
                  ),

                  // Chevron
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeInOutCubic,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _expanded ? color : AppTheme.textMuted,
                      size: 20,
                    ),
                  ),
                ],
              ),

              // Expanded content
              SizeTransition(
                sizeFactor: _expandAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withOpacity(0.4), Colors.transparent],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(widget.cardData.content, style: AppTheme.body),
                  ],
                ),
              ),

              if (!_expanded) ...[
                const SizedBox(height: 5),
                Text('Tap to expand',
                    style: AppTheme.caption.copyWith(fontSize: 10)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}