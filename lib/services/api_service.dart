// API Service - Replace Firebase Service
// This service handles all API calls to the backend
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart' as model;
import '../models/meal.dart';
import '../models/body_metrics.dart';
import '../models/subscription.dart';
import '../config/payment_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Backend API URL
  static const String baseUrl = PaymentConfig.backendApiUrl;
  
  // Auth token
  String? _authToken;
  String? get authToken => _authToken;
  
  model.User? _currentUser;
  model.User? get currentUser => _currentUser;

  // Headers
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // Auth methods
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        _currentUser = model.User.fromJson(data['user']);
        return data;
      } else {
        print('Login error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> register({
    required String email,
    required String password,
    required String name,
    required DateTime birthDate,
    required double height,
    required double weight,
    required String bodyType,
    required String goal,
    required double targetWeight,
    required int dailyCalorieGoal,
    required Map<String, double> macroGoals,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'birthDate': birthDate.toIso8601String(),
          'height': height,
          'weight': weight,
          'bodyType': bodyType,
          'goal': goal,
          'targetWeight': targetWeight,
          'dailyCalorieGoal': dailyCalorieGoal,
          'macroGoals': macroGoals,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        _currentUser = model.User.fromJson(data['user']);
        return data;
      } else {
        print('Register error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      if (_authToken != null) {
        await http.post(
          Uri.parse('$baseUrl/api/auth/logout'),
          headers: _headers,
        );
      }
    } catch (e) {
      print('Logout error: $e');
    } finally {
      _authToken = null;
      _currentUser = null;
    }
  }

  Future<bool> verifyToken() async {
    try {
      if (_authToken == null) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/verify'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = model.User.fromJson(data['user']);
        return true;
      } else {
        _authToken = null;
        _currentUser = null;
        return false;
      }
    } catch (e) {
      print('Verify token error: $e');
      _authToken = null;
      _currentUser = null;
      return false;
    }
  }

  // User methods
  Future<model.User?> getUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return model.User.fromJson(jsonDecode(response.body));
      } else {
        print('Get user error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Get user error: $e');
      return null;
    }
  }

  Future<void> saveUser(model.User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users'),
        headers: _headers,
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode != 200) {
        print('Save user error: ${response.statusCode}');
      }
    } catch (e) {
      print('Save user error: $e');
    }
  }

  // Meals methods
  Future<List<Meal>> getMealsForDate(DateTime date) async {
    try {
      if (_currentUser == null) return [];
      
      final dateStr = date.toIso8601String().split('T')[0];
      final response = await http.get(
        Uri.parse('$baseUrl/api/meals/user/${_currentUser!.id}/date/$dateStr'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Meal.fromJson(json)).toList();
      } else {
        print('Get meals error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Get meals error: $e');
      return [];
    }
  }

  Future<void> addMeal(Meal meal) async {
    try {
      if (_currentUser == null) return;
      
      final mealJson = meal.toJson();
      mealJson['userId'] = _currentUser!.id;
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/meals'),
        headers: _headers,
        body: jsonEncode(mealJson),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Add meal error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Add meal error: $e');
    }
  }

  Future<void> updateMeal(String id, Meal meal) async {
    try {
      final mealJson = meal.toJson();
      
      final response = await http.put(
        Uri.parse('$baseUrl/api/meals/id/$id'),
        headers: _headers,
        body: jsonEncode(mealJson),
      );

      if (response.statusCode != 200) {
        print('Update meal error: ${response.statusCode}');
      }
    } catch (e) {
      print('Update meal error: $e');
    }
  }

  Future<void> deleteMeal(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/meals/id/$id'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        print('Delete meal error: ${response.statusCode}');
      }
    } catch (e) {
      print('Delete meal error: $e');
    }
  }

  // Body Metrics methods
  Future<List<BodyMetrics>> getBodyMetricsHistory() async {
    try {
      if (_currentUser == null) return [];
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/body-metrics/user/${_currentUser!.id}'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BodyMetrics.fromJson(json)).toList();
      } else {
        print('Get body metrics error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Get body metrics error: $e');
      return [];
    }
  }

  Future<void> addBodyMetrics(BodyMetrics metrics) async {
    try {
      if (_currentUser == null) return;
      
      final metricsJson = metrics.toJson();
      metricsJson['userId'] = _currentUser!.id;
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/body-metrics'),
        headers: _headers,
        body: jsonEncode(metricsJson),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Add body metrics error: ${response.statusCode}');
      }
    } catch (e) {
      print('Add body metrics error: $e');
    }
  }

  // Water Intake methods
  Future<void> addWater(double amount) async {
    try {
      if (_currentUser == null) return;
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/water-intake'),
        headers: _headers,
        body: jsonEncode({
          'userId': _currentUser!.id,
          'amount': amount,
          'date': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Add water error: ${response.statusCode}');
      }
    } catch (e) {
      print('Add water error: $e');
    }
  }

  Future<double> getWaterIntakeToday() async {
    try {
      if (_currentUser == null) return 0.0;
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/water-intake/user/${_currentUser!.id}/today'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['totalAmount'] ?? 0.0).toDouble();
      } else {
        return 0.0;
      }
    } catch (e) {
      print('Get water intake error: $e');
      return 0.0;
    }
  }

  Future<void> resetWaterIntake() async {
    try {
      if (_currentUser == null) return;
      
      final response = await http.delete(
        Uri.parse('$baseUrl/api/water-intake/user/${_currentUser!.id}/today'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        print('Reset water intake error: ${response.statusCode}');
      }
    } catch (e) {
      print('Reset water intake error: $e');
    }
  }

  // Subscription methods
  Future<Subscription?> getActiveSubscription(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/subscriptions/user/$userId/active'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Subscription.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print('Get active subscription error: $e');
      return null;
    }
  }

  Future<List<Subscription>> getUserSubscriptions(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/subscriptions/user/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Subscription.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Get user subscriptions error: $e');
      return [];
    }
  }

  Future<void> saveSubscription(Subscription subscription) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/subscriptions'),
        headers: _headers,
        body: jsonEncode(subscription.toJson()),
      );

      if (response.statusCode != 200) {
        print('Save subscription error: ${response.statusCode}');
      }
    } catch (e) {
      print('Save subscription error: $e');
    }
  }

  // Admin methods
  Future<List<model.User>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => model.User.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Get all users error: $e');
      return [];
    }
  }

  Future<int> getUserCount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/stats/count'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['count'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Get user count error: $e');
      return 0;
    }
  }

  Future<int> getActiveUsersCount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/stats/active'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['count'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Get active users count error: $e');
      return 0;
    }
  }

  Future<int> getTotalMealsToday() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/stats/meals-today'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['count'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Get total meals today error: $e');
      return 0;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        print('Delete user error: ${response.statusCode}');
      }
    } catch (e) {
      print('Delete user error: $e');
    }
  }

  Future<void> updateUserRole(String userId, String role) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/users/$userId/role'),
        headers: _headers,
        body: jsonEncode({ 'role': role }),
      );

      if (response.statusCode != 200) {
        print('Update user role error: ${response.statusCode}');
      }
    } catch (e) {
      print('Update user role error: $e');
    }
  }

  // Static constants
  static const double waterGoal = 2.0;
}

