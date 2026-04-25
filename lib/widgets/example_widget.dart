import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/topic_model.dart';
import '../theme/app_theme.dart';

class ExampleWidget extends StatefulWidget {
  final TopicModel topic;
  const ExampleWidget({super.key, required this.topic});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> with SingleTickerProviderStateMixin {
  bool _copied = false;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.topic.example.code));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.cardDecoration(accent: widget.topic.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header bar ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingMd, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceHigh,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                Row(children: [
                  _dot(const Color(0xFFFF6058)),
                  const SizedBox(width: 6),
                  _dot(const Color(0xFFFFBD2E)),
                  const SizedBox(width: 6),
                  _dot(const Color(0xFF27C840)),
                ]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(widget.topic.example.title, style: AppTheme.caption),
                ),
                AnimatedBuilder(
                  animation: _pulse,
                  builder: (_, __) => Transform.scale(
                    scale: _pulse.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: AppTheme.pillBadge(const Color(0xFF27C840)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Color(0xFF27C840), size: 6),
                          SizedBox(width: 4),
                          Text('LIVE', style: TextStyle(color: Color(0xFF27C840), fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _copyCode,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _copied ? const Color(0xFF27C840).withOpacity(0.12) : AppTheme.surface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      border: Border.all(color: _copied ? const Color(0xFF27C840) : AppTheme.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_copied ? Icons.check : Icons.copy,
                            color: _copied ? const Color(0xFF27C840) : AppTheme.textMuted, size: 12),
                        const SizedBox(width: 4),
                        Text(_copied ? 'Copied!' : 'Copy',
                            style: TextStyle(
                                color: _copied ? const Color(0xFF27C840) : AppTheme.textMuted,
                                fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Code block ──────────────────────────────────────────────────
          Container(
            color: const Color(0xFF1A2235),
            padding: const EdgeInsets.all(AppTheme.paddingMd),
            child: _buildCode(widget.topic.example.code),
          ),

          // ── Explanation ─────────────────────────────────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(AppTheme.paddingMd),
            padding: const EdgeInsets.all(12),
            decoration: AppTheme.tintedSection(widget.topic.primaryColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: widget.topic.primaryColor, size: 15),
                const SizedBox(width: 8),
                Expanded(child: Text(widget.topic.example.explanation, style: AppTheme.body)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
    width: 11,
    height: 11,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );

  Widget _buildCode(String code) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: code.split('\n').asMap().entries.map((e) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '${e.key + 1}',
                  style: TextStyle(
                      color: AppTheme.textMuted.withOpacity(0.5),
                      fontSize: 11,
                      fontFamily: 'monospace'),
                ),
              ),
              _colorLine(e.value),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _colorLine(String line) {
    final t = line.trimLeft();
    Color color;
    if (t.startsWith('//')) {
      color = const Color(0xFF6A9955);
    } else if (RegExp(
        r'^(class|extends|@override|return|void|final|late|int|String|bool|super|this|const|Widget|State|Animation|Tween|Color|import)\b')
        .hasMatch(t)) {
      color = AppTheme.accentBlue;
    } else if (t.startsWith('@')) {
      color = AppTheme.accentAmber;
    } else if (RegExp(r"'[^']*'").hasMatch(line)) {
      color = AppTheme.accentCoral;
    } else {
      color = AppTheme.textPrimary;
    }
    return Text(
      line,
      style: TextStyle(color: color, fontSize: 11.5, fontFamily: 'monospace', height: 1.7),
    );
  }
}