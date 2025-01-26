import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nestiq/screens/auth/login_screen.dart';
import 'package:nestiq/screens/dashboard/admin_dashboard.dart';
import 'package:nestiq/screens/dashboard/agent_dashboard.dart';
import 'package:nestiq/screens/dashboard/student_dashboard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nestiq/config/firebase_options.dart';
import 'package:nestiq/services/auth_service.dart';
import 'package:nestiq/services/theme_service.dart';
import 'package:nestiq/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Initialize services
  final themeService = ThemeService(prefs);
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<ThemeService>(
          create: (_) => themeService,
        ),
        Provider<NotificationService>(
          create: (_) => notificationService,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    final authService = context.watch<AuthService>();

    return MaterialApp(
      title: 'Nestiq',
      theme: themeService.getLightTheme(),
      darkTheme: themeService.getDarkTheme(),
      themeMode: themeService.getThemeMode(),
      home: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return FutureBuilder<UserRole>(
              future: authService.getUserRole(snapshot.data!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                switch (snapshot.data) {
                  case UserRole.student:
                    return const StudentDashboard();
                  case UserRole.agent:
                    return const AgentDashboard();
                  case UserRole.admin:
                    return const AdminDashboard();
                  default:
                    return const LoginScreen();
                }
              },
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}

