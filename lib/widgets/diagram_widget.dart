import 'package:flutter/material.dart';
import '../models/topic_model.dart';
import '../theme/app_theme.dart';

class DiagramWidget extends StatefulWidget {
  final TopicModel topic;
  const DiagramWidget({super.key, required this.topic});

  @override
  State<DiagramWidget> createState() => _DiagramWidgetState();
}

class _DiagramWidgetState extends State<DiagramWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didUpdateWidget(DiagramWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topic != widget.topic) {
      _controller.dispose();
      _setupAnimations();
    }
  }

  void _setupAnimations() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _itemAnimations = List.generate(widget.topic.diagramItems.length, (i) {
      final start = i * 0.20;
      final end   = (start + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Interval(start, end, curve: Curves.elasticOut)),
      );
    });
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingLg),
      decoration: AppTheme.cardDecoration(accent: widget.topic.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_tree_outlined, color: widget.topic.primaryColor, size: 16),
              const SizedBox(width: 8),
              Text('Concept Diagram', style: AppTheme.headingSm),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              for (int i = 0; i < widget.topic.diagramItems.length; i++) ...[
                AnimatedBuilder(
                  animation: _itemAnimations[i],
                  builder: (_, __) => Transform.scale(
                    scale: _itemAnimations[i].value,
                    child: Opacity(
                      opacity: _itemAnimations[i].value.clamp(0.0, 1.0),
                      child: _buildNode(widget.topic.diagramItems[i]),
                    ),
                  ),
                ),
                if (i < widget.topic.diagramItems.length - 1)
                  AnimatedBuilder(
                    animation: _itemAnimations[i],
                    builder: (_, __) => Opacity(
                      opacity: _itemAnimations[i].value.clamp(0.0, 1.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Icon(Icons.keyboard_double_arrow_down,
                            color: widget.topic.primaryColor.withOpacity(0.45), size: 18),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNode(DiagramItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: AppTheme.tintedSection(item.color),
      child: Row(
        children: [
          Container(
            width: 9, height: 9,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
              boxShadow: AppTheme.glowShadow(item.color),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.label, style: TextStyle(color: item.color, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(item.description, style: AppTheme.caption),
            ],
          ),
        ],
      ),
    );
  }
}