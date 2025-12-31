import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

import 'pages/basic_usage_page.dart';
import 'pages/exception_handling_page.dart';
import 'pages/loading_dialogs_page.dart';
import 'pages/status_cards_page.dart';

void main() {
  // Initialize SmartExecuter configuration
  SmartExecuterConfig.initialize(
    enableLogging: kDebugMode,
    defaultErrorMessage: 'Something went wrong. Please try again.',
    noConnectionMessage: 'No internet connection. Please check your network.',
    sessionExpiredMessage: 'Your session has expired. Please sign in again.',
    sessionExpiredTitle: 'Session Expired',
    maxRetries: 2,
    retryDelay: const Duration(seconds: 1),
    checkConnectionByDefault: false,
    globalErrorHandler: (exception) async {
      debugPrint('Global error: ${exception.message}');
      if (exception.metadata.hasData) {
        debugPrint('Metadata: ${exception.metadata.toMap()}');
      }
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Executer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainNavigationPage(),
    );
  }
}

/// Main navigation page with bottom navigation bar.
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    BasicUsagePage(),
    StatusCardsPage(),
    LoadingDialogsPage(),
    ExceptionHandlingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Basic',
          ),
          NavigationDestination(
            icon: Icon(Icons.credit_card_outlined),
            selectedIcon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
          NavigationDestination(
            icon: Icon(Icons.hourglass_empty),
            selectedIcon: Icon(Icons.hourglass_full),
            label: 'Loading',
          ),
          NavigationDestination(
            icon: Icon(Icons.bug_report_outlined),
            selectedIcon: Icon(Icons.bug_report),
            label: 'Errors',
          ),
        ],
      ),
    );
  }
}
