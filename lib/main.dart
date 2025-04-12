import 'package:ac_2425/core/core_dashboard.dart';
import 'package:ac_2425/member/member_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:ac_2425/login.dart';
import 'package:ac_2425/register.dart';
import 'package:ac_2425/wrapper.dart';
import 'dashboard.dart';
import 'placeholder.dart';
import 'profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // <- Fix for web
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Club App',
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardScreen(role: 'Member'), // fallback
        '/events': (_) => PlaceholderScreen(title: "Events"),
        '/directory': (_) => PlaceholderScreen(title: "Directory"),
        '/profile': (_) => ProfilePage(),
        '/contributions': (_) => PlaceholderScreen(title: "Contributions"),
        '/tasks': (_) => PlaceholderScreen(title: "Tasks"),
        '/revenue': (_) => PlaceholderScreen(title: "Revenue"),
        '/announcements': (_) => PlaceholderScreen(title: "Announcements"),
        '/coreHome': (context) => CoreDashboardPage(),
        '/memberHome': (context) => MemberDashboardPage(),
        '/boardHome': (context) => CoreDashboardPage(),
      },
    );
  }
}
