import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'services/notification_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/meals_screen.dart';
import 'screens/drinks_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/add_meal_screen.dart';
import 'screens/add_drink_screen.dart';
import 'screens/add_friend_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider()..initializeApp(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        Widget homeScreen;
        if (!provider.isLoggedIn) {
          homeScreen = const LoginScreen();
        } else if (provider.isAdmin) {
          homeScreen = const AdminDashboardScreen();
        } else {
          homeScreen = const HomeScreen();
        }

        return MaterialApp(
          title: 'SaúdeFit',
      theme: ThemeData(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
          ),
        ),
      ),
          themeMode: provider.themeMode,
          home: homeScreen,
          routes: {
            '/home': (context) => const HomeScreen(),
            '/admin': (context) => const AdminDashboardScreen(),
            '/meals': (context) => const MealsScreen(),
            '/drinks': (context) => const DrinksScreen(),
            '/progress': (context) => const ProgressScreen(),
            '/friends': (context) => const FriendsScreen(),
            '/calendar': (context) => const CalendarScreen(),
            '/notifications': (context) => const NotificationsScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/add_meal': (context) => const AddMealScreen(),
            '/add_drink': (context) => const AddDrinkScreen(),
            '/add_friend': (context) => const AddFriendScreen(),
          },
        );
      },
    );
  }
}
