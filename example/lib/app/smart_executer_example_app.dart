import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/routing/app_router.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';

class SmartExecuterExampleApp extends StatelessWidget {
  const SmartExecuterExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Executer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
