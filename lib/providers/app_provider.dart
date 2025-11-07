import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/meal.dart';
import '../models/body_metrics.dart';
import '../services/firebase_service.dart';
import '../services/mock_data_service.dart';

class AppProvider with ChangeNotifier {
  final FirebaseService _dataService = FirebaseService();
  final MockDataService _mockService = MockDataService();

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isLoggedIn => _dataService.currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin'; // Check role for admin

  List<Meal> _todayMeals = [];
  List<Meal> get todayMeals => _todayMeals;

  double _waterIntake = 0.0;
  double get waterIntake => _waterIntake;
  double get waterGoal => FirebaseService.waterGoal;

  List<BodyMetrics> _bodyMetricsHistory = [];
  List<BodyMetrics> get bodyMetricsHistory => _bodyMetricsHistory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Theme mode
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
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

    // Firebase is initialized in main.dart
    // Load user if already logged in
    if (_dataService.currentUser != null) {
      final user = _dataService.currentUser!;
      final uid = user.uid;
      _currentUser = await _dataService.getUser(uid);
      await loadTodayData();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Try Firebase first
    var credential = await _dataService.signIn(email, password);
    if (credential != null) {
      final firebaseUser = credential.user!;
      _currentUser = await _dataService.getUser(firebaseUser.uid);
      await loadTodayData();
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      // Fallback to mock data
      final authUser = _mockService.authenticate(email, password);
      if (authUser != null) {
        _currentUser = _mockService.getUserById(authUser.userId);
        await loadMockTodayData();
        _isLoading = false;
        notifyListeners();
        return true;
      }
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signUp(String email, String password, User user) async {
    _isLoading = true;
    notifyListeners();

    final credential = await _dataService.signUp(email, password);
    if (credential != null) {
      final firebaseUser = credential.user!;
      final uid = firebaseUser.uid;
      final updatedUser = user.copyWith(id: uid);
      await _dataService.saveUser(updatedUser);
      _currentUser = updatedUser;
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

  Future<void> logout() async {
    await _dataService.signOut();
    _currentUser = null;
    _todayMeals = [];
    _waterIntake = 0.0;
    _bodyMetricsHistory = [];
    notifyListeners();
  }

  Future<void> loadTodayData() async {
    try {
      final today = DateTime.now();
      _todayMeals = await _dataService.getMealsForDate(today);
      _waterIntake = await _dataService.getWaterIntakeToday();
      _bodyMetricsHistory = await _dataService.getBodyMetricsHistory();
    } catch (e) {
      print('Error loading today data: $e');
      // Set empty data on error to avoid loop
      _todayMeals = [];
      _waterIntake = 0.0;
      _bodyMetricsHistory = [];
      // Note: Create the required index in Firebase Console to fix the query error
    }
    notifyListeners();
  }

  Future<void> loadMockTodayData() async {
    _todayMeals = _mockService.getMealsForDate(DateTime.now());
    _waterIntake = _mockService.waterIntakeToday;
    _bodyMetricsHistory = _mockService.getBodyMetricsHistory();
    notifyListeners();
  }

  Future<void> loadDataForDate(DateTime date) async {
    _todayMeals = await _dataService.getMealsForDate(date);
    // TODO: Load water and metrics for specific date
    notifyListeners();
  }

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> addMeal(Meal meal) async {
    await _dataService.addMeal(meal);
    await loadTodayData(); // Reload today data
  }

  Future<void> updateMeal(String id, Meal meal) async {
    await _dataService.updateMeal(id, meal);
    await loadTodayData();
  }

  Future<void> deleteMeal(String mealId) async {
    await _dataService.deleteMeal(mealId);
    await loadTodayData();
  }

  Future<void> addWater(double amount) async {
    await _dataService.addWater(amount);
    _waterIntake = await _dataService.getWaterIntakeToday();
    notifyListeners();
  }

  Future<void> resetWaterIntake() async {
    await _dataService.resetWaterIntake();
    _waterIntake = 0.0;
    notifyListeners();
  }

  Future<void> addBodyMetrics(BodyMetrics metrics) async {
    await _dataService.addBodyMetrics(metrics);
    _bodyMetricsHistory = await _dataService.getBodyMetricsHistory();
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

    return {'protein': protein, 'carbs': carbs, 'fat': fat};
  }

  double get calorieProgress {
    if (_currentUser == null) return 0.0;
    return todayTotalCalories / _currentUser!.dailyCalorieGoal;
  }

  double get waterProgress {
    return _waterIntake / waterGoal;
  }

  // Admin data
  List<User> _allUsers = [];
  List<User> get allUsers => _allUsers;

  int _userCount = 0;
  int get userCount => _userCount;

  int _activeUsersCount = 0;
  int get activeUsersCount => _activeUsersCount;

  int _totalMealsToday = 0;
  int get totalMealsToday => _totalMealsToday;

  Future<void> loadAdminData() async {
    _allUsers = await _dataService.getAllUsers();
    _userCount = await _dataService.getUserCount();
    _activeUsersCount = await _dataService.getActiveUsersCount();
    _totalMealsToday = await _dataService.getTotalMealsToday();
    notifyListeners();
  }

  Future<void> deleteUser(String uid) async {
    await _dataService.deleteUser(uid);
    await loadAdminData();
  }

  Future<void> updateUserRole(String uid, String role) async {
    await _dataService.updateUserRole(uid, role);
    await loadAdminData();
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
