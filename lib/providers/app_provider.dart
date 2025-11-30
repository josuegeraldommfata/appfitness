import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/meal.dart';
import '../models/body_metrics.dart';
import '../models/drink.dart';
import '../models/challenge.dart';
import '../services/firebase_service.dart';

class AppProvider with ChangeNotifier {
  final FirebaseService _dataService = FirebaseService();

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isLoggedIn => _dataService.currentUser != null && _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin'; // Check role for admin

  List<Meal> _todayMeals = [];
  List<Meal> get todayMeals => _todayMeals;

  double _waterIntake = 0.0;
  double get waterIntake => _waterIntake;
  double get waterGoal => FirebaseService.waterGoal;

  List<BodyMetrics> _bodyMetricsHistory = [];
  List<BodyMetrics> get bodyMetricsHistory => _bodyMetricsHistory;

  List<Drink> _todayDrinks = [];
  List<Drink> get todayDrinks => _todayDrinks;

  List<Challenge> _userChallenges = [];
  List<Challenge> get userChallenges => _userChallenges;

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

    // Check if user is already logged in (Firebase Auth)
    if (_dataService.currentUser != null) {
      final userId = _dataService.currentUser!.uid;
      print('App initialized. User already logged in: userId=$userId');
      
      final user = await _dataService.getUser(userId);
      if (user != null) {
        _currentUser = user;
        print('User data loaded: ${user.name}, email: ${user.email}');
        
        // Carregar dados do dia
        await loadTodayData();
        
        print('App initialized. Today meals: ${_todayMeals.length}, drinks: ${_todayDrinks.length}');
      } else {
        print('User data not found in Firestore for userId: $userId');
      }
    } else {
      print('App initialized. No user logged in');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _dataService.signIn(email, password);
      if (userCredential != null && userCredential.user != null) {
        final userId = userCredential.user!.uid;
        print('User logged in: userId=$userId, email=$email');
        
        final user = await _dataService.getUser(userId);
        if (user != null) {
          _currentUser = user;
          print('User data loaded: ${user.name}, role: ${user.role}');
          
          // Carregar dados do dia
          await loadTodayData();
          
          print('Login complete. Today meals: ${_todayMeals.length}, drinks: ${_todayDrinks.length}');
          
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          print('User data not found in Firestore for userId: $userId');
        }
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Login error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password, User user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _dataService.signUp(email, password);
      if (userCredential != null && userCredential.user != null) {
        // Definir o ID do usuário com o UID do Firebase Auth
        final userId = userCredential.user!.uid;
        final userWithId = user.copyWith(id: userId);
        
        // Save user data to Firestore
        await _dataService.saveUser(userWithId);
        _currentUser = userWithId;
        
        print('New user created: ${userWithId.id}, email: ${userWithId.email}');
        
        // Carregar dados do dia (vai retornar vazio para novo usuário, mas está correto)
        await loadTodayData();
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Sign up error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
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
    final today = DateTime.now();
    
    // Carregar refeições (não falhar se der erro)
    try {
      _todayMeals = await _dataService.getMealsForDate(today);
      print('loadTodayData: Loaded ${_todayMeals.length} meals');
    } catch (e) {
      print('Error loading meals: $e');
      // Não limpar se já tiver dados
      if (_todayMeals.isEmpty) {
        _todayMeals = [];
      }
    }
    
    // Carregar bebidas (não falhar se der erro)
    try {
      _todayDrinks = await _dataService.getDrinksForDate(today);
      print('loadTodayData: Loaded ${_todayDrinks.length} drinks');
    } catch (e) {
      print('Error loading drinks: $e');
      // Não limpar se já tiver dados
      if (_todayDrinks.isEmpty) {
        _todayDrinks = [];
      }
    }
    
    // Carregar água
    try {
      _waterIntake = await _dataService.getWaterIntakeToday();
    } catch (e) {
      print('Error loading water intake: $e');
    }
    
    // Carregar métricas corporais (não falhar se der erro de índice)
    try {
      _bodyMetricsHistory = await _dataService.getBodyMetricsHistory();
    } catch (e) {
      print('Error loading body metrics: $e');
      // Não limpar se já tiver dados
      if (_bodyMetricsHistory.isEmpty) {
        _bodyMetricsHistory = [];
      }
    }
    
    // Carregar desafios
    try {
      _userChallenges = await _dataService.getUserChallenges();
    } catch (e) {
      print('Error loading challenges: $e');
      if (_userChallenges.isEmpty) {
        _userChallenges = [];
      }
    }
    
    print('loadTodayData: Final count - meals: ${_todayMeals.length}, drinks: ${_todayDrinks.length}');
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
    try {
      await _dataService.addMeal(meal);
      print('Meal saved to Firebase, now reloading data...');
      
      // Recarregar dados do dia
      await loadTodayData();
      
      print('Meal added and data reloaded. Today meals count: ${_todayMeals.length}');
      print('Meals details: ${_todayMeals.map((m) => '${m.type} - ${m.totalCalories}kcal').join(', ')}');
    } catch (e) {
      print('Error adding meal: $e');
      rethrow;
    }
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

  Future<void> addDrink(Drink drink) async {
    try {
      await _dataService.addDrink(drink);
      // Recarregar dados do dia
      await loadTodayData();
      print('Drink added and data reloaded. Today drinks count: ${_todayDrinks.length}');
    } catch (e) {
      print('Error adding drink: $e');
      rethrow;
    }
  }

  Future<void> deleteDrink(String id) async {
    await _dataService.deleteDrink(id);
    await loadTodayData();
  }

  Future<void> addChallenge(Challenge challenge) async {
    await _dataService.addChallenge(challenge);
    await loadTodayData();
  }

  Future<void> deleteChallenge(String challengeId) async {
    await _dataService.deleteChallenge(challengeId);
    await loadTodayData();
  }

  Future<void> addBodyMetrics(BodyMetrics metrics) async {
    await _dataService.addBodyMetrics(metrics);
    _bodyMetricsHistory = await _dataService.getBodyMetricsHistory();
    notifyListeners();
  }

  // Calculate daily totals (including drinks)
  int get todayTotalCalories {
    int mealsCalories = _todayMeals.fold(0, (sum, meal) => sum + meal.totalCalories);
    int drinksCalories = _todayDrinks.fold(0, (sum, drink) => sum + drink.calories);
    return mealsCalories + drinksCalories;
  }

  Map<String, double> get todayTotalMacros {
    double protein = 0;
    double carbs = 0;
    double fat = 0;

    // Add macros from meals
    for (var meal in _todayMeals) {
      protein += meal.totalMacros['protein'] ?? 0;
      carbs += meal.totalMacros['carbs'] ?? 0;
      fat += meal.totalMacros['fat'] ?? 0;
    }

    // Note: Drinks typically don't have macros, but if they do, add them here
    // For now, drinks only contribute calories

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

  Future<Map<String, dynamic>> getReportDataForDate(DateTime date) async {
    try {
      // Buscar dados reais do Firebase para a data selecionada
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
      
      // Buscar refeições do dia
      final meals = await _dataService.getMealsForDateRange(startOfDay, endOfDay);
      
      // Buscar assinaturas ativas
      final subscriptions = await _dataService.getActiveSubscriptionsForDate(date);
      
      // Calcular receita
      double revenue = 0.0;
      for (var sub in subscriptions) {
        revenue += sub.amount;
      }
      
      // Calcular calorias médias
      double avgCalories = 0.0;
      if (meals.isNotEmpty) {
        final totalCalories = meals.fold(0, (sum, meal) => sum + meal.totalCalories);
        avgCalories = totalCalories / meals.length;
      }
      
      // Top alimentos (contar frequência)
      Map<String, int> foodCount = {};
      for (var meal in meals) {
        for (var food in meal.foods) {
          foodCount[food.name] = (foodCount[food.name] ?? 0) + 1;
        }
      }
      final topFoods = foodCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      return {
        'totalUsers': _userCount,
        'activeUsers': _activeUsersCount,
        'totalMeals': meals.length,
        'averageCalories': avgCalories.round(),
        'topFoods': topFoods.take(10).map((e) => {'name': e.key, 'count': e.value}).toList(),
        'revenue': revenue,
        'subscriptions': subscriptions.length,
        'date': date.toIso8601String(),
      };
    } catch (e) {
      print('Error getting report data: $e');
      return {
        'totalUsers': _userCount,
        'activeUsers': _activeUsersCount,
        'totalMeals': 0,
        'averageCalories': 0,
        'topFoods': [],
        'revenue': 0.0,
        'subscriptions': 0,
        'date': date.toIso8601String(),
      };
    }
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
