import 'package:flutter/material.dart';
import 'package:phenoxx/community_screen.dart';
import 'package:phenoxx/dashboard_screen.dart';
import 'package:phenoxx/earn_screen.dart';
import 'package:phenoxx/learn_screen.dart';
import 'package:phenoxx/profile_screen.dart';
import 'package:phenoxx/chats_screen.dart';
import 'package:phenoxx/services/chat_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0; // Current page index (0-5)
  int _navBarIndex = 0;   // Current nav bar selection (0-5)
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ChatService _chatService = ChatService();

  final List<Widget> _pages = const [
    DashboardScreen(),
    LearnScreen(),
    EarnScreen(),
    ChatsScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      _animationController.reset();
      setState(() {
        _selectedIndex = index;
        _navBarIndex = index;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        height: 70,
        selectedIndex: _navBarIndex,
        onDestinationSelected: _onItemTapped,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        indicatorColor: Colors.blue.withOpacity(0.1),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.blue),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school, color: Colors.blue),
            label: 'Learn',
          ),
          const NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag, color: Colors.blue),
            label: 'Earn',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text(_chatService.getTotalUnreadCount().toString()),
              isLabelVisible: _chatService.getTotalUnreadCount() > 0,
              child: const Icon(Icons.chat_bubble_outline),
            ),
            selectedIcon: Badge(
              label: Text(_chatService.getTotalUnreadCount().toString()),
              isLabelVisible: _chatService.getTotalUnreadCount() > 0,
              child: const Icon(Icons.chat_bubble, color: Colors.blue),
            ),
            label: 'Chats',
          ),
          const NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups, color: Colors.blue),
            label: 'Community',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Colors.blue),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
