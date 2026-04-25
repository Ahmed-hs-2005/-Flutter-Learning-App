import 'package:flutter/material.dart';
import '../models/topic_model.dart';
import '../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
//  All topic content. Colors are driven by AppTheme.topicColors —
//  change colors in app_theme.dart, they update here automatically.
// ════════════════════════════════════════════════════════════════════════════

class TopicsData {
  static List<TopicModel> getAllTopics() {
    return [

      // ── Topic 0: Widgets ────────────────────────────────────────────────
      TopicModel(
        title: 'Widgets', shortTitle: 'Widgets',
        description: 'In Flutter, everything is a widget! Widgets are the basic building blocks of the UI. They describe what the view should look like given their current configuration and state.',
        level: 'Beginner', icon: Icons.widgets_outlined,
        primaryColor: AppTheme.topicPrimary(0), secondaryColor: AppTheme.topicSecondary(0),
        cards: const [
          CardData(title: 'What is a Widget?', icon: Icons.account_tree_outlined,
              content: 'A widget is an immutable description of part of the UI. It can be a button, text, image, layout, or even the entire app. Widgets form a tree structure called the Widget Tree.'),
          CardData(title: 'StatelessWidget', icon: Icons.lock_outline,
              content: 'A StatelessWidget does not change over time. It is built once and stays the same. Use it for static UI elements like Text, Icon, or Image that do not depend on dynamic data.'),
          CardData(title: 'StatefulWidget', icon: Icons.change_circle_outlined,
              content: 'A StatefulWidget can change its appearance based on user interactions or data changes. It maintains a State object that can call setState() to rebuild the UI when data changes.'),
          CardData(title: 'Widget Lifecycle', icon: Icons.loop,
              content: 'Widgets go through: createState → initState → build → setState → dispose. Understanding lifecycle helps manage resources and side effects properly in Flutter apps.'),
        ],
        diagramItems: [
          DiagramItem(label: 'App',        description: 'Root Widget',    color: Color(0xFFFFB347)),
          DiagramItem(label: 'Scaffold',   description: 'Page Structure', color: Color(0xFFFFCA76)),
          DiagramItem(label: 'Column/Row', description: 'Layout',         color: Color(0xFFFFD78A)),
          DiagramItem(label: 'Text/Button',description: 'Leaf Widgets',   color: Color(0xFFFFE4A8)),
        ],
        example: CodeExample(
          title: 'Stateful Counter Widget',
          code: '''class MyWidget extends StatefulWidget {
  const MyWidget({super.key});
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: \$count',
          style: TextStyle(fontSize: 24)),
        ElevatedButton(
          onPressed: () => setState(() => count++),
          child: Text('Tap Me!'),
        ),
      ],
    );
  }
}''',
          explanation: 'This StatefulWidget increments a counter. setState() triggers a rebuild whenever the count changes — the core of local state in Flutter.',
        ),
      ),

      // ── Topic 1: Layouts ────────────────────────────────────────────────
      TopicModel(
        title: 'Layouts', shortTitle: 'Layouts',
        description: 'Flutter provides powerful layout widgets to arrange children in rows, columns, stacks, and grids. Mastering layouts helps you build responsive and beautiful UIs.',
        level: 'Beginner', icon: Icons.dashboard_outlined,
        primaryColor: AppTheme.topicPrimary(1), secondaryColor: AppTheme.topicSecondary(1),
        cards: const [
          CardData(title: 'Row & Column', icon: Icons.view_column_outlined,
              content: 'Row arranges widgets horizontally. Column arranges them vertically. Both support mainAxisAlignment and crossAxisAlignment to control spacing and alignment of children.'),
          CardData(title: 'Stack', icon: Icons.layers_outlined,
              content: 'Stack allows widgets to overlap each other. Use Positioned widget inside Stack to place children at specific coordinates. Great for overlay effects and badges.'),
          CardData(title: 'Expanded & Flexible', icon: Icons.open_in_full,
              content: 'Expanded fills available space along the main axis. Flexible is similar but does not force the child to fill the space. Use flex property to distribute space proportionally.'),
          CardData(title: 'Container', icon: Icons.crop_square_outlined,
              content: 'Container combines padding, margin, decoration, width, height, and alignment in one widget. It is the Swiss army knife of Flutter — extremely versatile for styling.'),
        ],
        diagramItems: [
          DiagramItem(label: 'Row',      description: 'Horizontal axis',   color: Color(0xFF38D9C0)),
          DiagramItem(label: 'Column',   description: 'Vertical axis',     color: Color(0xFF5EE2CB)),
          DiagramItem(label: 'Stack',    description: 'Overlapping layers', color: Color(0xFF6EEEDD)),
          DiagramItem(label: 'GridView', description: '2D grid layout',    color: Color(0xFF90EEE4)),
        ],
        example: CodeExample(
          title: 'Profile Card Layout',
          code: '''Widget buildProfileCard() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(
        color: Colors.black26, blurRadius: 8)],
    ),
    child: Row(
      children: [
        CircleAvatar(radius: 30),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('John Doe',
                style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Flutter Developer'),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios),
      ],
    ),
  );
}''',
          explanation: 'This profile card uses Row, Column, Expanded, and Container together — a very common Flutter layout pattern for list tiles and cards.',
        ),
      ),

      // ── Topic 2: Navigation ─────────────────────────────────────────────
      TopicModel(
        title: 'Navigation', shortTitle: 'Navigate',
        description: 'Flutter uses a Navigator widget and a stack of routes to manage screen transitions. Understanding navigation is essential for building multi-screen applications.',
        level: 'Intermediate', icon: Icons.navigation_outlined,
        primaryColor: AppTheme.topicPrimary(2), secondaryColor: AppTheme.topicSecondary(2),
        cards: const [
          CardData(title: 'Navigator Push & Pop', icon: Icons.swap_horiz,
              content: 'Navigator.push() adds a new route on top of the stack, navigating to a new screen. Navigator.pop() removes the top route, going back to the previous screen.'),
          CardData(title: 'Named Routes', icon: Icons.label_outline,
              content: 'Named routes allow navigation by string names like "/home" or "/profile". Define routes in MaterialApp and use Navigator.pushNamed() for cleaner, maintainable navigation.'),
          CardData(title: 'Passing Data', icon: Icons.send_outlined,
              content: 'Pass data to new screens as constructor arguments. To return data back, use Navigator.pop(context, result) and await the future from Navigator.push().'),
          CardData(title: 'Go Router', icon: Icons.route_outlined,
              content: 'GoRouter is the recommended routing package. It supports deep links, URL-based navigation, nested routes, and redirect logic — perfect for large Flutter apps.'),
        ],
        diagramItems: [
          DiagramItem(label: 'Screen A', description: 'Initial Route',    color: Color(0xFF7B9FFF)),
          DiagramItem(label: 'Push',     description: 'Navigate forward', color: Color(0xFF96B4FF)),
          DiagramItem(label: 'Screen B', description: 'New Route',        color: Color(0xFFAAC0FF)),
          DiagramItem(label: 'Pop',      description: 'Go back',          color: Color(0xFFBFCEFF)),
        ],
        example: CodeExample(
          title: 'Screen Navigation Example',
          code: '''// Navigate to DetailScreen
ElevatedButton(
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          title: 'Flutter Navigation',
        ),
      ),
    );
    print('Returned: \$result');
  },
  child: Text('Go to Detail'),
)

// In DetailScreen — go back with data
ElevatedButton(
  onPressed: () {
    Navigator.pop(context, 'Done!');
  },
  child: Text('Go Back'),
)''',
          explanation: 'push() navigates to a new screen passing data as arguments. pop() returns with a result. The await keyword waits for the result when the user navigates back.',
        ),
      ),

      // ── Topic 3: State Management ───────────────────────────────────────
      TopicModel(
        title: 'State Management', shortTitle: 'State',
        description: 'State management is how Flutter handles and shares data across widgets. From simple setState to Provider and Riverpod, choosing the right approach is key to scalable apps.',
        level: 'Intermediate', icon: Icons.storage_outlined,
        primaryColor: AppTheme.topicPrimary(3), secondaryColor: AppTheme.topicSecondary(3),
        cards: const [
          CardData(title: 'setState()', icon: Icons.refresh,
              content: 'The simplest form of state management. Call setState() inside a StatefulWidget to notify Flutter that the UI needs rebuilding. Best for local, simple widget state.'),
          CardData(title: 'Provider', icon: Icons.hub_outlined,
              content: 'Provider is a recommended state management solution. It uses InheritedWidget under the hood. A ChangeNotifier holds the state and notifyListeners() updates the UI.'),
          CardData(title: 'Riverpod', icon: Icons.water_drop_outlined,
              content: 'Riverpod is an improved version of Provider, offering compile-time safety, testability, and no context dependency. StateNotifierProvider and ref.watch() are core concepts.'),
          CardData(title: 'BLoC Pattern', icon: Icons.schema_outlined,
              content: 'BLoC (Business Logic Component) separates UI from business logic using Streams or Cubits. Events are dispatched, processed by the BLoC, and states are emitted to update UI.'),
        ],
        diagramItems: [
          DiagramItem(label: 'Event',      description: 'User action triggers', color: Color(0xFFB57BFF)),
          DiagramItem(label: 'BLoC/Provider',description: 'Logic layer',        color: Color(0xFFC490FF)),
          DiagramItem(label: 'State',      description: 'New data state',       color: Color(0xFFD4AAFF)),
          DiagramItem(label: 'UI Rebuild', description: 'Widget re-renders',    color: Color(0xFFE0C2FF)),
        ],
        example: CodeExample(
          title: 'Provider Counter Example',
          code: '''// 1. Counter model
class CounterModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // Rebuild UI
  }
}

// 2. Wrap app with Provider
ChangeNotifierProvider(
  create: (_) => CounterModel(),
  child: MyApp(),
)

// 3. Consume in widget
Consumer<CounterModel>(
  builder: (context, model, child) {
    return Column(children: [
      Text('\${model.count}'),
      ElevatedButton(
        onPressed: model.increment,
        child: Text('Increment'),
      ),
    ]);
  },
)''',
          explanation: 'Provider separates state from UI. CounterModel holds data, Consumer listens for changes and rebuilds automatically when notifyListeners() is called.',
        ),
      ),

      // ── Topic 4: Animations ─────────────────────────────────────────────
      TopicModel(
        title: 'Animations', shortTitle: 'Animations',
        description: 'Flutter has a rich animation API. From implicit animations that auto-animate property changes, to explicit AnimationController-based animations for complete control.',
        level: 'Advanced', icon: Icons.animation,
        primaryColor: AppTheme.topicPrimary(4), secondaryColor: AppTheme.topicSecondary(4),
        cards: const [
          CardData(title: 'Implicit Animations', icon: Icons.auto_awesome,
              content: 'Implicit animations automatically animate between values using AnimatedContainer, AnimatedOpacity, AnimatedPadding, etc. Just change the value and Flutter handles the transition.'),
          CardData(title: 'Explicit Animations', icon: Icons.tune,
              content: 'AnimationController gives full control. You define duration, curve, and range. Use Tween to interpolate values and AnimatedBuilder or AnimatedWidget to rebuild efficiently.'),
          CardData(title: 'Hero Animation', icon: Icons.flight_takeoff,
              content: 'Hero widgets create shared element transitions between screens. Wrap widgets with the same Hero tag on both screens, and Flutter smoothly animates the transition.'),
          CardData(title: 'Curves & Tweens', icon: Icons.show_chart,
              content: 'Curves define the rate of animation (easeIn, bounceOut, elasticInOut). Tweens define the range (ColorTween, SizeTween). Combine them for expressive, custom animations.'),
        ],
        diagramItems: [
          DiagramItem(label: 'Controller', description: 'Drives animation',       color: Color(0xFFFF7E7E)),
          DiagramItem(label: 'Tween',      description: 'Value interpolation',    color: Color(0xFFFF9595)),
          DiagramItem(label: 'Curve',      description: 'Easing function',        color: Color(0xFFFFABAB)),
          DiagramItem(label: 'Animation',  description: 'Animated value output',  color: Color(0xFFFFBEBE)),
        ],
        example: CodeExample(
          title: 'Spinning Icon (Explicit Animation)',
          code: '''class SpinWidget extends StatefulWidget {
  const SpinWidget({super.key});
  @override
  State<SpinWidget> createState() => _SpinWidgetState();
}

class _SpinWidgetState extends State<SpinWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    _rotation = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(
        parent: _ctrl,
        curve: Curves.linear,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotation,
      child: Icon(Icons.flutter_dash, size: 80),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}''',
          explanation: 'AnimationController drives the animation. Tween maps 0.0→1.0 to a full rotation. RotationTransition rebuilds efficiently without calling setState().',
        ),
      ),

    ];
  }
}