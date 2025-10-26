import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/meal.dart';
import '../models/body_metrics.dart';
import '../models/auth_user.dart';
import '../services/mock_data_service.dart';

class AppProvider with ChangeNotifier {
  final MockDataService _dataService = MockDataService();

  AuthUser? _currentAuthUser;
  AuthUser? get currentAuthUser => _currentAuthUser;

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentAuthUser != null;
  bool get isAdmin => _currentAuthUser?.role == 'admin';

  List<Meal> _todayMeals = [];
  List<Meal> get todayMeals => _todayMeals;

  double _waterIntake = 0.0;
  double get waterIntake => _waterIntake;
  double get waterGoal => _dataService.waterGoal;

  List<BodyMetrics> _bodyMetricsHistory = [];
  List<BodyMetrics> get bodyMetricsHistory => _bodyMetricsHistory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Theme mode
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Diet streak tracking
  int _dietStreak = 7; // Mock streak
  int get dietStreak => _dietStreak;

  void incrementDietStreak() {
    _dietStreak++;
    notifyListeners();
  }

  void resetDietStreak() {
    _dietStreak = 0;
    notifyListeners();
  }

  // Initialize app
  Future<void> initializeApp() async {
    _isLoading = true;
    notifyListeners();

    await _dataService.loadMockFoods();
    _dataService.initializeMockAuthData();

    // No longer auto-create user; wait for login

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final authUser = _dataService.authenticate(username, password);
    if (authUser != null) {
      _currentAuthUser = authUser;
      _currentUser = _dataService.getUserById(authUser.userId);
      await loadTodayData();
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentAuthUser = null;
    _currentUser = null;
    _todayMeals = [];
    _waterIntake = 0.0;
    _bodyMetricsHistory = [];
    notifyListeners();
  }

  Future<void> loadTodayData() async {
    final today = DateTime.now();
    _todayMeals = _dataService.getMealsForDate(today);
    _waterIntake = _dataService.waterIntakeToday;
    _bodyMetricsHistory = _dataService.getBodyMetricsHistory();
    notifyListeners();
  }

  Future<void> loadDataForDate(DateTime date) async {
    _todayMeals = _dataService.getMealsForDate(date);
    // TODO: Load water and metrics for specific date
    notifyListeners();
  }

  void setCurrentUser(User user) {
    _currentUser = user;
    _dataService.setCurrentUser(user);
    notifyListeners();
  }

  void addMeal(Meal meal) {
    _dataService.addMeal(meal);
    loadTodayData(); // Reload today data
  }

  void updateMeal(Meal meal) {
    _dataService.updateMeal(meal);
    loadTodayData();
  }

  void deleteMeal(String mealId) {
    _dataService.deleteMeal(mealId);
    loadTodayData();
  }

  void addWater(double amount) {
    _dataService.addWater(amount);
    _waterIntake = _dataService.waterIntakeToday;
    notifyListeners();
  }

  void resetWaterIntake() {
    _dataService.resetWaterIntake();
    _waterIntake = 0.0;
    notifyListeners();
  }

  void addBodyMetrics(BodyMetrics metrics) {
    _dataService.addBodyMetrics(metrics);
    _bodyMetricsHistory = _dataService.getBodyMetricsHistory();
    notifyListeners();
  }

  // Calculate daily totals
  int get todayTotalCalories {
    return _todayMeals.fold(0, (sum, meal) => sum + meal.totalCalories);
  }

  Map<String, double> get todayTotalMacros {
    double protein = 0;
    double carbs = 0;
    double fat = 0;

    for (var meal in _todayMeals) {
      protein += meal.totalMacros['protein'] ?? 0;
      carbs += meal.totalMacros['carbs'] ?? 0;
      fat += meal.totalMacros['fat'] ?? 0;
    }

    return {
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  double get calorieProgress {
    if (_currentUser == null) return 0.0;
    return todayTotalCalories / _currentUser!.dailyCalorieGoal;
  }

  double get waterProgress {
    return _waterIntake / waterGoal;
  }

  // Mock friends data
  List<Map<String, dynamic>> get friends => [
    {
      'name': 'Maria Silva',
      'todayCalories': 1650,
      'dailyGoal': 1800,
      'weeklyCalories': 11500,
    },
    {
      'name': 'João Santos',
      'todayCalories': 1900,
      'dailyGoal': 2000,
      'weeklyCalories': 13200,
    },
    {
      'name': 'Ana Costa',
      'todayCalories': 1750,
      'dailyGoal': 1700,
      'weeklyCalories': 11800,
    },
  ];

  int get userRanking => 2; // Mock ranking
}
