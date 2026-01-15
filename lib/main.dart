import 'package:flutter/material.dart';
import 'package:phenoxx/login_screen.dart';
import 'package:phenoxx/theme_provider.dart';
import 'package:phenoxx/study_groups_screen.dart';
import 'package:phenoxx/ai_group_matcher_screen.dart';
import 'package:phenoxx/data_rewards_screen.dart';
import 'package:phenoxx/ai_debugger_screen.dart';
import 'package:phenoxx/my_portfolio_screen.dart';
import 'package:phenoxx/micro_tasks_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Phenoxx',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFEAF2F8),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4285F4),
          surface: Colors.white,
          onSurface: Color(0xFF1E232C),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111827),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4285F4),
          surface: Color(0xFF1F2937),
          onSurface: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/study-groups': (context) => const StudyGroupsScreen(),
        '/ai-matcher': (context) => const AIGroupMatcherScreen(),
        '/data-rewards': (context) => const DataRewardsScreen(),
        '/ai-debugger': (context) => const AIDebuggerScreen(),
        '/my-portfolio': (context) => const MyPortfolioScreen(),
        '/micro-tasks': (context) => const MicroTasksScreen(),
      },
    );
  }
}
