import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';
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
    final provider = Provider.of<AppProvider>(context);

    return MaterialApp(
      title: 'SaúdeFit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
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
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
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
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
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
  }
}
