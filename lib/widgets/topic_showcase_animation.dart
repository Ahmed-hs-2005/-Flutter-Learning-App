import 'dart:math';
import 'package:flutter/material.dart';
import '../models/topic_model.dart';
import '../theme/app_theme.dart';

class TopicShowcaseAnimation extends StatefulWidget {
  final TopicModel topic;
  final String topicTitle;
  const TopicShowcaseAnimation({super.key, required this.topic, required this.topicTitle});

  @override
  State<TopicShowcaseAnimation> createState() => _TopicShowcaseAnimationState();
}

class _TopicShowcaseAnimationState extends State<TopicShowcaseAnimation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration(accent: widget.topic.primaryColor, elevated: true),
      child: Column(
        children: [
          // Label bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingMd, vertical: 10),
            decoration: BoxDecoration(
              color: widget.topic.primaryColor.withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
              border: Border(bottom: BorderSide(color: widget.topic.primaryColor.withOpacity(0.15))),
            ),
            child: Row(
              children: [
                Icon(Icons.play_circle_outline, color: widget.topic.primaryColor, size: 15),
                const SizedBox(width: 6),
                Text('Live Animation  ·  ${widget.topicTitle}',
                    style: TextStyle(color: widget.topic.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 230, child: _buildShowcase()),
        ],
      ),
    );
  }

  Widget _buildShowcase() {
    switch (widget.topicTitle) {
      case 'Widgets':          return const _WidgetTreeShowcase();
      case 'Layouts':          return const _LayoutShowcase();
      case 'Navigation':       return const _NavigationShowcase();
      case 'State Management': return const _StateShowcase();
      case 'Animations':       return const _AnimationsShowcase();
      default:                 return const SizedBox();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SHARED HELPERS
// ─────────────────────────────────────────────────────────────────────────────

Widget _label(String text, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
  decoration: BoxDecoration(
    color: color.withOpacity(0.12),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: color.withOpacity(0.35)),
  ),
  child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
);

Widget _card(String title, Color color, {double width = 90, double height = 110}) =>
    Container(
      width: width, height: height,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.45), width: 1.5),
        boxShadow: [BoxShadow(color: color.withOpacity(0.18), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 28, height: 4, decoration: BoxDecoration(color: color.withOpacity(0.5), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 6),
          Container(width: 44, height: 4, decoration: BoxDecoration(color: color.withOpacity(0.25), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 4),
          Container(width: 36, height: 4, decoration: BoxDecoration(color: color.withOpacity(0.25), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 10),
          Text(title, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );

// ─────────────────────────────────────────────────────────────────────────────
//  TOPIC 1 — WIDGETS
//  Clean widget tree that draws itself top-down, node by node.
//  Lines animate in before each node appears. Simple, clear, beautiful.
// ─────────────────────────────────────────────────────────────────────────────

class _WidgetTreeShowcase extends StatefulWidget {
  const _WidgetTreeShowcase();
  @override State<_WidgetTreeShowcase> createState() => _WidgetTreeShowcaseState();
}

class _WidgetTreeShowcaseState extends State<_WidgetTreeShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Each node: [label, depth, xFraction (0=left, 0.5=center, 1=right)]
  static const _nodes = [
    ['MaterialApp', 0, 0.5],
    ['Scaffold',    1, 0.5],
    ['AppBar',      2, 0.25],
    ['Column',      2, 0.75],
    ['Text',        3, 0.60],
    ['Button',      3, 0.90],
  ];

  static const _colors = [
    Color(0xFFFFB347), Color(0xFFFFCA76), Color(0xFF38D9C0),
    Color(0xFF7B9FFF), Color(0xFFB57BFF), Color(0xFFFF7E7E),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => CustomPaint(
        painter: _TreePainter(_nodes, _colors, _ctrl.value),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _TreePainter extends CustomPainter {
  final List<List<dynamic>> nodes;
  final List<Color> colors;
  final double t;
  _TreePainter(this.nodes, this.colors, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Compute positions
    final positions = <Offset>[];
    final rowCount = 4; // max depth + 1
    for (var n in nodes) {
      final depth = n[1] as int;
      final xFrac = n[2] as double;
      final x = size.width * (0.1 + xFrac * 0.8);
      final y = 18.0 + depth * (size.height - 30) / rowCount;
      positions.add(Offset(x, y));
    }

    // Parent map
    const parents = [-1, 0, 1, 1, 3, 3];
    final totalSteps = nodes.length * 2; // line then node per step

    for (int i = 0; i < nodes.length; i++) {
      final nodeProgress = ((t * totalSteps) - i * 2).clamp(0.0, 1.0);
      final lineProgress = ((t * totalSteps) - (i * 2 - 1)).clamp(0.0, 1.0);
      if (lineProgress <= 0) continue;

      final p = parents[i];
      final pos = positions[i];
      final color = colors[i];

      // Draw line from parent
      if (p >= 0) {
        final parentPos = positions[p];
        final endX = parentPos.dx + (pos.dx - parentPos.dx) * lineProgress;
        final endY = parentPos.dy + (pos.dy - parentPos.dy) * lineProgress;
        canvas.drawLine(parentPos, Offset(endX, endY),
            Paint()..color = color.withOpacity(0.35)..strokeWidth = 1.5..style = PaintingStyle.stroke);
      }

      if (nodeProgress <= 0) continue;

      // Node glow
      canvas.drawCircle(pos, 14 * nodeProgress,
          Paint()..color = color.withOpacity(0.08 * nodeProgress));

      // Node circle
      canvas.drawCircle(pos, 11 * nodeProgress,
          Paint()..color = color.withOpacity(0.9 * nodeProgress));

      // Node border
      canvas.drawCircle(pos, 11 * nodeProgress,
          Paint()..color = Colors.white.withOpacity(0.18)..style = PaintingStyle.stroke..strokeWidth = 1);

      // Label
      if (nodeProgress > 0.5) {
        final label = nodes[i][0] as String;
        final tp = TextPainter(
          text: TextSpan(text: label,
              style: TextStyle(color: color, fontSize: 8.5, fontWeight: FontWeight.bold)),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, pos + Offset(-tp.width / 2, 13));
      }
    }
  }

  @override bool shouldRepaint(_TreePainter old) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
//  TOPIC 2 — LAYOUTS
//  Three labeled boxes animate cleanly between Row → Column → Stack.
//  A centered badge shows the current layout name. Smooth and readable.
// ─────────────────────────────────────────────────────────────────────────────

class _LayoutShowcase extends StatefulWidget {
  const _LayoutShowcase();
  @override State<_LayoutShowcase> createState() => _LayoutShowcaseState();
}

class _LayoutShowcaseState extends State<_LayoutShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _mode = 0;
  final _modes = ['Row', 'Column', 'Stack'];
  final _colors = [AppTheme.accentTeal, AppTheme.accentBlue, AppTheme.accentViolet];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1400), () {
          if (!mounted) return;
          setState(() => _mode = (_mode + 1) % _modes.length);
          _ctrl.forward(from: 0);
        });
      }
    });
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final boxes = List.generate(3, (i) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        width:  _mode == 1 ? 120.0 : 52.0,
        height: _mode == 0 ? 52.0  : (_mode == 1 ? 36.0 : 52.0),
        margin: EdgeInsets.all(_mode == 2 ? 0 : 5),
        decoration: BoxDecoration(
          color: _colors[i].withOpacity(0.82),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: _colors[i].withOpacity(0.30), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Center(
          child: Text(['A', 'B', 'C'][i],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      );
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _label(_modes[_mode], _colors[_mode]),
        const SizedBox(height: 18),
        SizedBox(
          height: 110,
          child: Center(
            child: _mode == 0
                ? Row(mainAxisSize: MainAxisSize.min, children: boxes)
                : _mode == 1
                ? Column(mainAxisSize: MainAxisSize.min, children: boxes)
                : Stack(children: [
              boxes[0],
              Positioned(left: 14, top: 14, child: boxes[1]),
              Positioned(left: 28, top: 28, child: boxes[2]),
            ]),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TOPIC 3 — NAVIGATION
//  Left: live route stack growing/shrinking with push/pop.
//  Right: phone mockup showing the active screen sliding in/out.
//  Bottom: code snippet updates to show the exact call being made.
// ─────────────────────────────────────────────────────────────────────────────

class _NavigationShowcase extends StatefulWidget {
  const _NavigationShowcase();
  @override State<_NavigationShowcase> createState() => _NavigationShowcaseState();
}

class _NavigationShowcaseState extends State<_NavigationShowcase>
    with TickerProviderStateMixin {
  late AnimationController _slideCtrl;
  late AnimationController _stackCtrl;

  // Route stack state
  final _routes = [
    _RouteInfo('/',        'Home',     Icons.home_rounded,          Color(0xFF2DD4BF)),
    _RouteInfo('/profile', 'Profile',  Icons.person_rounded,        Color(0xFF79C0FF)),
    _RouteInfo('/settings','Settings', Icons.settings_rounded,      Color(0xFFD2A8FF)),
  ];

  int  _stackDepth = 1;   // how many routes are currently on the stack
  bool _isPushing  = true;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _stackCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _loop();
  }

  void _loop() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;

      if (_isPushing) {
        if (_stackDepth < _routes.length) {
          // Push next route
          _slideCtrl.forward(from: 0);
          await Future.delayed(const Duration(milliseconds: 300));
          if (!mounted) return;
          setState(() => _stackDepth++);
          _stackCtrl.forward(from: 0);
          if (_stackDepth == _routes.length) {
            // Pause at top, then start popping
            await Future.delayed(const Duration(milliseconds: 900));
            if (!mounted) return;
            setState(() => _isPushing = false);
          }
        }
      } else {
        if (_stackDepth > 1) {
          // Pop current route
          _slideCtrl.reverse();
          await Future.delayed(const Duration(milliseconds: 300));
          if (!mounted) return;
          setState(() => _stackDepth--);
          _stackCtrl.forward(from: 0);
          if (_stackDepth == 1) {
            await Future.delayed(const Duration(milliseconds: 900));
            if (!mounted) return;
            setState(() => _isPushing = true);
          }
        }
      }
    }
  }

  @override
  void dispose() { _slideCtrl.dispose(); _stackCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final activeRoute = _routes[_stackDepth - 1];
    final activeColor = activeRoute.color;
    final callText    = _isPushing
        ? "Navigator.push('${_routes[min(_stackDepth, _routes.length-1)].path}')"
        : "Navigator.pop()";

    return AnimatedBuilder(
      animation: Listenable.merge([_slideCtrl, _stackCtrl]),
      builder: (_, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // ── LEFT: Route Stack ───────────────────────────────────────
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // "Route Stack" label
                    Row(children: [
                      Container(width: 2, height: 10,
                          decoration: BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(1))),
                      const SizedBox(width: 5),
                      Text('Route Stack',
                          style: TextStyle(color: activeColor, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                    ]),
                    const SizedBox(height: 8),

                    // Stack items — reversed so bottom of stack is at bottom
                    ...List.generate(_routes.length, (i) {
                      final isOnStack = i < _stackDepth;
                      final isActive  = i == _stackDepth - 1;
                      final route     = _routes[i];

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 380),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(bottom: 5),
                        height: isOnStack ? 32 : 0,
                        child: isOnStack ? AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: isOnStack ? 1.0 : 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isActive
                                  ? route.color.withOpacity(0.18)
                                  : AppTheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isActive ? route.color.withOpacity(0.6) : AppTheme.border,
                                width: isActive ? 1.5 : 1,
                              ),
                              boxShadow: isActive
                                  ? [BoxShadow(color: route.color.withOpacity(0.25), blurRadius: 8)]
                                  : [],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Icon(route.icon, color: route.color, size: 12),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(route.path,
                                      style: TextStyle(
                                        color: isActive ? route.color : AppTheme.textMuted,
                                        fontSize: 9.5,
                                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                                        fontFamily: 'monospace',
                                      )),
                                ),
                                if (isActive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: route.color.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text('TOP',
                                        style: TextStyle(color: route.color, fontSize: 7, fontWeight: FontWeight.w800)),
                                  ),
                              ],
                            ),
                          ),
                        ) : const SizedBox.shrink(),
                      );
                    }),

                    const SizedBox(height: 8),

                    // Code call badge
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: Container(
                        key: ValueKey(callText),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: _isPushing
                              ? AppTheme.accentTeal.withOpacity(0.08)
                              : AppTheme.accentCoral.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: _isPushing
                                ? AppTheme.accentTeal.withOpacity(0.30)
                                : AppTheme.accentCoral.withOpacity(0.30),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isPushing ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                              color: _isPushing ? AppTheme.accentTeal : AppTheme.accentCoral,
                              size: 10,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                _isPushing ? 'push()' : 'pop()',
                                style: TextStyle(
                                  color: _isPushing ? AppTheme.accentTeal : AppTheme.accentCoral,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // ── RIGHT: Phone Mockup ─────────────────────────────────────
              Expanded(
                flex: 4,
                child: Center(
                  child: _PhoneMockup(
                    route: activeRoute,
                    slideCtrl: _slideCtrl,
                    isPushing: _isPushing,
                    stackDepth: _stackDepth,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RouteInfo {
  final String path, name;
  final IconData icon;
  final Color color;
  const _RouteInfo(this.path, this.name, this.icon, this.color);
}

class _PhoneMockup extends StatelessWidget {
  final _RouteInfo route;
  final AnimationController slideCtrl;
  final bool isPushing;
  final int stackDepth;

  const _PhoneMockup({
    required this.route,
    required this.slideCtrl,
    required this.isPushing,
    required this.stackDepth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, height: 148,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: route.color.withOpacity(0.45), width: 1.5),
        boxShadow: [
          BoxShadow(color: route.color.withOpacity(0.20), blurRadius: 14, offset: const Offset(0, 4)),
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Column(
          children: [
            // Status bar
            Container(
              height: 20,
              color: route.color.withOpacity(0.15),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  if (stackDepth > 1)
                    Icon(Icons.arrow_back_ios_rounded, color: route.color, size: 9),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(route.name,
                        style: TextStyle(color: route.color, fontSize: 8.5, fontWeight: FontWeight.w700),
                        textAlign: stackDepth > 1 ? TextAlign.left : TextAlign.center),
                  ),
                ],
              ),
            ),

            // Screen content slides in
            Expanded(
              child: AnimatedBuilder(
                animation: slideCtrl,
                builder: (_, __) {
                  final offset = isPushing
                      ? (1.0 - slideCtrl.value) * 80
                      : -slideCtrl.value * 80;
                  return Transform.translate(
                    offset: Offset(offset, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon
                          Container(
                            width: 26, height: 26,
                            decoration: BoxDecoration(
                              color: route.color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(route.icon, color: route.color, size: 14),
                          ),
                          const SizedBox(height: 8),
                          // Fake content lines
                          ...List.generate(4, (i) => Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            height: 5,
                            width: i == 0 ? 60 : i == 2 ? 50 : 70,
                            decoration: BoxDecoration(
                              color: route.color.withOpacity(i == 0 ? 0.35 : 0.12),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TOPIC 4 — STATE MANAGEMENT
//  Three clear boxes: Event → Provider → UI.
//  A glowing dot travels along the arrow path, and the UI box updates a counter.
//  Simple, professional, instantly understood.
// ─────────────────────────────────────────────────────────────────────────────

class _StateShowcase extends StatefulWidget {
  const _StateShowcase();
  @override State<_StateShowcase> createState() => _StateShowcaseState();
}

class _StateShowcaseState extends State<_StateShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _count = 0;
  int _activeStep = -1; // 0=event, 1=provider, 2=ui

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _loop();
  }

  void _loop() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 800));
      for (int step = 0; step < 3; step++) {
        if (!mounted) return;
        setState(() => _activeStep = step);
        _ctrl.forward(from: 0);
        await Future.delayed(const Duration(milliseconds: 520));
      }
      if (!mounted) return;
      setState(() { _count++; _activeStep = -1; });
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final steps = [
      ['Event', Icons.touch_app_outlined, AppTheme.accentViolet],
      ['Provider', Icons.hub_outlined, AppTheme.accentBlue],
      ['UI', Icons.phone_android_outlined, AppTheme.accentTeal],
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(5, (i) {
            if (i.isOdd) {
              // Arrow between boxes
              final arrowActive = _activeStep > i ~/ 2;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 28,
                child: Icon(Icons.arrow_forward_rounded,
                    color: arrowActive
                        ? (steps[i ~/ 2][2] as Color)
                        : AppTheme.border,
                    size: 18),
              );
            }
            final idx = i ~/ 2;
            final isActive = _activeStep == idx;
            final color = steps[idx][2] as Color;
            final icon  = steps[idx][1] as IconData;
            final title = steps[idx][0] as String;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 72, height: 78,
              decoration: BoxDecoration(
                color: isActive ? color.withOpacity(0.18) : AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: isActive ? color : AppTheme.border,
                  width: isActive ? 2 : 1,
                ),
                boxShadow: isActive
                    ? [BoxShadow(color: color.withOpacity(0.28), blurRadius: 12)]
                    : AppTheme.subtleShadow,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: isActive ? color : AppTheme.textMuted, size: 20),
                  const SizedBox(height: 5),
                  Text(title,
                      style: TextStyle(
                          color: isActive ? color : AppTheme.textSecondary,
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
                  if (idx == 2)
                    Text('$_count',
                        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 14),
        _label('setState()  →  notifyListeners()  →  rebuild', AppTheme.accentViolet),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  TOPIC 5 — ANIMATIONS
//  6 live animation tiles: Rotation, Wave, Morph, Pulse, Orbit, Shimmer
//  Each tile uses CustomPainter or rich Flutter animations — professional & unique
// ─────────────────────────────────────────────────────────────────────────────

class _AnimationsShowcase extends StatefulWidget {
  const _AnimationsShowcase();
  @override State<_AnimationsShowcase> createState() => _AnimationsShowcaseState();
}

class _AnimationsShowcaseState extends State<_AnimationsShowcase>
    with TickerProviderStateMixin {
  late AnimationController _rotCtrl;
  late AnimationController _waveCtrl;
  late AnimationController _morphCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _orbitCtrl;
  late AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();
    _rotCtrl     = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _waveCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat();
    _morphCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
    _pulseCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _orbitCtrl   = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _rotCtrl.dispose(); _waveCtrl.dispose(); _morphCtrl.dispose();
    _pulseCtrl.dispose(); _orbitCtrl.dispose(); _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotCtrl, _waveCtrl, _morphCtrl, _pulseCtrl, _orbitCtrl, _shimmerCtrl]),
      builder: (_, __) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tile('Rotation', AppTheme.accentAmber,
                      CustomPaint(painter: _RotationPainter(_rotCtrl.value), child: const SizedBox(width: 44, height: 44))),
                  _tile('Wave', AppTheme.accentTeal,
                      CustomPaint(painter: _WavePainter(_waveCtrl.value), child: const SizedBox(width: 44, height: 44))),
                  _tile('Morph', AppTheme.accentViolet,
                      CustomPaint(painter: _MorphPainter(_morphCtrl.value), child: const SizedBox(width: 44, height: 44))),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _tile('Pulse', AppTheme.accentCoral,
                      CustomPaint(painter: _PulsePainter(_pulseCtrl.value), child: const SizedBox(width: 44, height: 44))),
                  _tile('Orbit', AppTheme.accentBlue,
                      CustomPaint(painter: _OrbitPainter(_orbitCtrl.value), child: const SizedBox(width: 44, height: 44))),
                  _tile('Shimmer', const Color(0xFFFFD700),
                      CustomPaint(painter: _ShimmerPainter(_shimmerCtrl.value), child: const SizedBox(width: 44, height: 44))),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tile(String label, Color color, Widget painter) {
    return Container(
      width: 96,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: color.withOpacity(0.22), width: 1),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.10), blurRadius: 10, offset: const Offset(0, 3)),
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            painter,
            const SizedBox(height: 5),
            Text(label,
                style: TextStyle(
                    color: color, fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
          ],
        ),
      ),
    );
  }
}

// ── CustomPainter: Rotation ───────────────────────────────────────────────────
// Spinning square with gradient fill and rounded corners, trailing arc glow
class _RotationPainter extends CustomPainter {
  final double t;
  _RotationPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final angle = t * 2 * pi;

    // Trailing glow arc
    final arcPaint = Paint()
      ..color = AppTheme.accentAmber.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: 14),
        angle - 1.8, 1.8, false, arcPaint);

    // Rotating square
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    final rrect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(-10, -10, 20, 20), const Radius.circular(4));
    canvas.drawRRect(rrect, Paint()
      ..shader = LinearGradient(
        colors: [AppTheme.accentAmber, const Color(0xFFFFE08A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(const Rect.fromLTWH(-10, -10, 20, 20))
      ..style = PaintingStyle.fill);
    canvas.restore();
  }

  @override bool shouldRepaint(_RotationPainter o) => true;
}

// ── CustomPainter: Wave ────────────────────────────────────────────────────────
// Smooth sine wave scrolling left with a glowing fill beneath it
class _WavePainter extends CustomPainter {
  final double t;
  _WavePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 + sin((x / size.width * 2 * pi) - t * 2 * pi) * 10;
      x == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Gradient fill under wave
    canvas.drawPath(path, Paint()
      ..shader = LinearGradient(
        colors: [AppTheme.accentTeal.withOpacity(0.5), AppTheme.accentTeal.withOpacity(0.05)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    // Wave line
    final wavePath = Path();
    for (double x = 0; x <= size.width; x++) {
      final y = size.height / 2 + sin((x / size.width * 2 * pi) - t * 2 * pi) * 10;
      x == 0 ? wavePath.moveTo(x, y) : wavePath.lineTo(x, y);
    }
    canvas.drawPath(wavePath, Paint()
      ..color = AppTheme.accentTeal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round);
  }

  @override bool shouldRepaint(_WavePainter o) => true;
}

// ── CustomPainter: Morph ───────────────────────────────────────────────────────
// Shape smoothly morphs between a circle and a rounded square
class _MorphPainter extends CustomPainter {
  final double t;
  _MorphPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final curve = Curves.easeInOutCubic.transform(t);
    final radius = lerpDouble(14.0, 5.0, curve)!;
    final side   = lerpDouble(14.0, 10.0, curve)!;

    final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: side * 2, height: side * 2),
        Radius.circular(radius));

    // Glow
    canvas.drawRRect(rrect, Paint()
      ..color = AppTheme.accentViolet.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));

    // Shape
    canvas.drawRRect(rrect, Paint()
      ..shader = LinearGradient(
        colors: [AppTheme.accentViolet, const Color(0xFFE5C8FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCenter(center: Offset(cx, cy), width: 28, height: 28)));
  }

  @override bool shouldRepaint(_MorphPainter o) => true;
}

double? lerpDouble(double a, double b, double t) => a + (b - a) * t;

// ── CustomPainter: Pulse ───────────────────────────────────────────────────────
// Concentric rings that expand and fade out like a heartbeat pulse
class _PulsePainter extends CustomPainter {
  final double t;
  _PulsePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    for (int i = 0; i < 3; i++) {
      final phase = (t - i * 0.33).clamp(0.0, 1.0);
      if (phase <= 0) continue;
      final r = phase * 20;
      canvas.drawCircle(Offset(cx, cy), r, Paint()
        ..color = AppTheme.accentCoral.withOpacity((1 - phase) * 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 * (1 - phase));
    }

    // Core dot with glow
    canvas.drawCircle(Offset(cx, cy), 6, Paint()
      ..color = AppTheme.accentCoral.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    canvas.drawCircle(Offset(cx, cy), 6, Paint()..color = AppTheme.accentCoral);
  }

  @override bool shouldRepaint(_PulsePainter o) => true;
}

// ── CustomPainter: Orbit ───────────────────────────────────────────────────────
// Two dots orbit a glowing center core at different speeds with trails
class _OrbitPainter extends CustomPainter {
  final double t;
  _OrbitPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Core
    canvas.drawCircle(Offset(cx, cy), 5, Paint()
      ..color = AppTheme.accentBlue.withOpacity(0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
    canvas.drawCircle(Offset(cx, cy), 5, Paint()..color = AppTheme.accentBlue);

    // Two orbiting dots
    final orbits = [
      (14.0, 1.0,  AppTheme.accentTeal,   4.0),
      (20.0, -0.6, AppTheme.accentViolet, 3.0),
    ];

    for (var o in orbits) {
      final angle = t * 2 * pi * o.$2;
      final px = cx + cos(angle) * o.$1;
      final py = cy + sin(angle) * o.$1;

      // Trail
      for (int i = 1; i <= 5; i++) {
        final ta = angle - i * 0.18 * o.$2.abs();
        final tx = cx + cos(ta) * o.$1;
        final ty = cy + sin(ta) * o.$1;
        canvas.drawCircle(Offset(tx, ty), 1.5 * (1 - i * 0.15),
            Paint()..color = o.$3.withOpacity(0.12 * (6 - i)));
      }

      // Dot glow + dot
      canvas.drawCircle(Offset(px, py), o.$4 + 2, Paint()
        ..color = o.$3.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
      canvas.drawCircle(Offset(px, py), o.$4, Paint()..color = o.$3);
    }
  }

  @override bool shouldRepaint(_OrbitPainter o) => true;
}

// ── CustomPainter: Shimmer ────────────────────────────────────────────────────
// A horizontal shimmer sweep across a rounded bar — like a loading skeleton
class _ShimmerPainter extends CustomPainter {
  final double t;
  _ShimmerPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const gold = Color(0xFFFFD700);

    final bars = [
      Rect.fromCenter(center: Offset(cx, cy - 10), width: 38, height: 5),
      Rect.fromCenter(center: Offset(cx, cy),      width: 28, height: 5),
      Rect.fromCenter(center: Offset(cx, cy + 10), width: 32, height: 5),
    ];

    // Sweep position: moves from left edge to right edge of canvas
    final sweepX = t * (size.width + 60) - 30;

    for (var bar in bars) {
      final rrect = RRect.fromRectAndRadius(bar, const Radius.circular(3));

      // 1. Draw base bar
      canvas.drawRRect(rrect, Paint()..color = gold.withOpacity(0.12));

      // 2. Clip to bar shape so shimmer never leaks outside
      canvas.save();
      canvas.clipRRect(rrect);

      // 3. Draw shimmer using the full bar rect as shader bounds — no artifacts
      canvas.drawRect(
        bar,
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.transparent,
              gold.withOpacity(0.75),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(Rect.fromLTWH(sweepX - 20, bar.top, 40, bar.height)),
      );

      canvas.restore();
    }
  }

  @override bool shouldRepaint(_ShimmerPainter o) => true;
}