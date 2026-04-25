import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'topic_detail_screen.dart';
import '../models/topic_model.dart';
import '../data/topics_data.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  final List<TopicModel> topics = TopicsData.getAllTopics();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final topic = topics[_selectedIndex];
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(topic),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: topics.length,
        itemBuilder: (_, i) => TopicScreen(topic: topics[i]),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar(TopicModel topic) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(68),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppTheme.surfaceHigh,
          border: Border(
            bottom: BorderSide(color: topic.primaryColor.withOpacity(0.20), width: 1),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 2)),
            BoxShadow(color: topic.primaryColor.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 4)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Left — icon badge
                Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeInOut,
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [topic.primaryColor, topic.secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      boxShadow: AppTheme.glowShadow(topic.primaryColor),
                    ),
                    child: const Icon(Icons.flutter_dash, color: Colors.white, size: 19),
                  ),
                ),

                // Center — title + animated topic name
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Flutter Learn',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
                              .animate(anim),
                          child: child,
                        ),
                      ),
                      child: Text(
                        topic.shortTitle,
                        key: ValueKey(_selectedIndex),
                        style: AppTheme.caption.copyWith(
                          color: topic.primaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),

                // Right — dot progress indicators
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(topics.length, (i) {
                      final isActive = i == _selectedIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                        margin: const EdgeInsets.only(left: 4),
                        width: isActive ? 16 : 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isActive ? topic.primaryColor : AppTheme.border,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: isActive
                              ? [BoxShadow(color: topic.primaryColor.withOpacity(0.55), blurRadius: 6)]
                              : [],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceHigh,
        border: Border(top: BorderSide(color: AppTheme.surfaceBorder, width: 1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, -6)),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 62,
          child: Row(
            children: topics.asMap().entries.map((entry) {
              final i = entry.key;
              final t = entry.value;
              final isSelected = i == _selectedIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onTabTapped(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Top glow line
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                        height: 2,
                        width: isSelected ? 24 : 0,
                        margin: const EdgeInsets.only(bottom: 7),
                        decoration: BoxDecoration(
                          color: t.primaryColor,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: isSelected
                              ? [BoxShadow(color: t.primaryColor.withOpacity(0.7), blurRadius: 8)]
                              : [],
                        ),
                      ),

                      // Icon
                      AnimatedScale(
                        scale: isSelected ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutBack,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 320),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? t.primaryColor.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            t.icon,
                            size: 20,
                            color: isSelected ? t.primaryColor : AppTheme.textMuted,
                          ),
                        ),
                      ),

                      const SizedBox(height: 3),

                      // Label
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 320),
                        style: TextStyle(
                          color: isSelected ? t.primaryColor : AppTheme.textMuted,
                          fontSize: 9.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          letterSpacing: isSelected ? 0.2 : 0,
                        ),
                        child: Text(t.shortTitle),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}