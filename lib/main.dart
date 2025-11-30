import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'providers/subscription_provider.dart';
import 'services/notification_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
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
import 'screens/ai_chat_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/plans_screen.dart';
import 'screens/nutritional_analysis_screen.dart';
import 'screens/manage_users_screen.dart';
import 'screens/add_challenge_screen.dart';
import 'screens/admin_notifications_screen.dart';
import 'screens/herbalife_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/coach_screen.dart';
import 'screens/share_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppProvider()..initializeApp(),
        ),
        ChangeNotifierProvider(
          create: (context) => SubscriptionProvider()..initialize(),
        ),
      ],
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
          title: 'Nudge',
          theme: ThemeData(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
              ),
            ),
          ),
          themeMode: provider.themeMode,
          home: homeScreen,
          routes: {
            '/home': (context) => const HomeScreen(),
            '/register': (context) => const RegisterScreen(),
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
            '/ai_chat': (context) => const AIChatScreen(),
            '/reports': (context) => const ReportsScreen(),
            '/plans': (context) => const PlansScreen(),
            '/nutritional_analysis': (context) => const NutritionalAnalysisScreen(),
            '/manage_users': (context) => const ManageUsersScreen(),
            '/add_challenge': (context) => const AddChallengeScreen(),
            '/admin_notifications': (context) => const AdminNotificationsScreen(),
            '/herbalife': (context) => const HerbalifeScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/coach': (context) => const CoachScreen(),
            '/share': (context) => const ShareScreen(),
          },
        );
      },
    );
  }
}
