import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as model;
import '../models/meal.dart';
import '../models/body_metrics.dart';
import '../models/subscription.dart';
import '../models/drink.dart';
import '../models/challenge.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const double waterGoal = 2.0;

  // Auth methods
  auth.User? get currentUser => _auth.currentUser;

  Future<auth.UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  Future<auth.UserCredential?> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // User data
  Future<void> saveUser(model.User user) async {
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser!.uid).set(user.toJson());
    }
  }

  Future<model.User?> getUser(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      // Ensure role is set based on email for demo users
      if ((data['email'] == 'admin@email.com' || data['email'] == 'demoadmin@email.com') && !data.containsKey('role')) {
        data['role'] = 'admin';
      } else if (!data.containsKey('role')) {
        data['role'] = 'user';
      }
      return model.User.fromJson(data);
    }
    return null;
  }

  // Admin methods
  Future<List<model.User>> getAllUsers() async {
    QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Ensure id is set from document ID
      // Ensure role is set
      if (!data.containsKey('role') || data['role'] == null) {
        if (data['email'] == 'admin@email.com' || data['email'] == 'demoadmin@email.com') {
          data['role'] = 'admin';
        } else {
          data['role'] = 'user';
        }
      }
      // Ensure all required fields have default values
      if (!data.containsKey('name') || data['name'] == null) data['name'] = '';
      if (!data.containsKey('email') || data['email'] == null) data['email'] = '';
      if (!data.containsKey('birthDate') || data['birthDate'] == null) {
        data['birthDate'] = DateTime.now().toIso8601String();
      }
      if (!data.containsKey('macroGoals') || data['macroGoals'] == null) {
        data['macroGoals'] = {'protein': 150.0, 'carbs': 200.0, 'fat': 65.0};
      }
      try {
        return model.User.fromJson(data);
      } catch (e) {
        print('Error parsing user ${doc.id}: $e');
        print('User data: $data');
        // Return a default user instead of crashing
        return model.User.fromJson({
          'id': doc.id,
          'name': data['name'] ?? 'Unknown',
          'email': data['email'] ?? 'unknown@email.com',
          'birthDate': DateTime.now().toIso8601String(),
          'height': 0,
          'weight': 0,
          'bodyType': 'mesomorfo',
          'goal': 'manutenção',
          'targetWeight': 0,
          'dailyCalorieGoal': 2000,
          'macroGoals': {'protein': 150.0, 'carbs': 200.0, 'fat': 65.0},
          'role': data['role'] ?? 'user',
        });
      }
    }).toList();
  }

  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
    await _firestore.collection('meals').where('userId', isEqualTo: uid).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    await _firestore.collection('body_metrics').where('userId', isEqualTo: uid).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    await _firestore.collection('water_intake').doc(uid).delete();
    await _firestore.collection('friends').where('userId', isEqualTo: uid).get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
    // Delete from Auth
    await _auth.currentUser?.delete(); // Only if current user, but for admin, use admin SDK if needed
  }

  Future<void> updateUserRole(String uid, String role) async {
    await _firestore.collection('users').doc(uid).update({'role': role});
  }

  Future<int> getUserCount() async {
    AggregateQuery countQuery = _firestore.collection('users').count();
    AggregateQuerySnapshot snapshot = await countQuery.get();
    return snapshot.count ?? 0;
  }

  Future<int> getActiveUsersCount() async {
    // Active as last login within 30 days
    DateTime thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    Timestamp thirtyDaysAgoTs = Timestamp.fromDate(thirtyDaysAgo);
    QuerySnapshot snapshot = await _firestore.collection('users').where('lastLogin', isGreaterThanOrEqualTo: thirtyDaysAgoTs).get();
    return snapshot.docs.length;
  }

  Future<int> getTotalMealsToday() async {
    DateTime todayStart = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    Timestamp todayStartTs = Timestamp.fromDate(todayStart);
    Timestamp todayEndTs = Timestamp.fromDate(todayStart.add(const Duration(days: 1)));
    QuerySnapshot snapshot = await _firestore.collection('meals').where('dateTime', isGreaterThanOrEqualTo: todayStartTs).where('dateTime', isLessThan: todayEndTs).get();
    return snapshot.docs.length;
  }

  // Meals
  Future<List<Meal>> getMealsForDate(DateTime date) async {
    final userId = currentUser?.uid;
    if (userId == null) {
      print('No user authenticated, returning empty meals list');
      return [];
    }

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    Timestamp start = Timestamp.fromDate(startOfDay);
    Timestamp end = Timestamp.fromDate(endOfDay);

    print('Getting meals for date: ${date.toString()}, userId: $userId');
    print('Date range: ${start.toDate()} to ${end.toDate()}');

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .where('dateTime', isGreaterThanOrEqualTo: start)
          .where('dateTime', isLessThan: end)
          .get();

      print('Found ${snapshot.docs.length} meals for user $userId');
      
      final meals = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Converter Timestamp para DateTime string se necessário
        if (data['dateTime'] is Timestamp) {
          data['dateTime'] = (data['dateTime'] as Timestamp).toDate().toIso8601String();
        }
        data['id'] = doc.id; // Usar o ID do documento
        // Garantir que userId está presente
        if (!data.containsKey('userId') || data['userId'] == null) {
          data['userId'] = userId;
        }
        return Meal.fromJson(data);
      }).toList();
      
      print('Parsed ${meals.length} meals for user $userId');
      return meals;
    } catch (e) {
      print('Error getting meals for user $userId: $e');
      return [];
    }
  }

  Future<void> addMeal(Meal meal) async {
    final userId = currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated - cannot save meal');
    }
    
    // Garantir que o userId está definido
    meal.userId = userId;
    
    // Converter dateTime para Timestamp
    final mealData = meal.toJson();
    mealData['dateTime'] = Timestamp.fromDate(meal.dateTime);
    mealData['userId'] = userId; // Garantir que userId está no JSON
    
    print('Adding meal: userId=$userId, dateTime=${meal.dateTime}, type=${meal.type}, foods=${meal.foods.length}');
    final docRef = await _firestore.collection('meals').add(mealData);
    print('Meal added with ID: ${docRef.id}');
    
    // Verificar se foi salvo corretamente
    final savedDoc = await _firestore.collection('meals').doc(docRef.id).get();
    if (savedDoc.exists) {
      final savedData = savedDoc.data();
      print('Meal saved successfully. Saved userId: ${savedData?['userId']}');
    }
  }

  Future<void> updateMeal(String id, Meal meal) async {
    await _firestore.collection('meals').doc(id).update(meal.toJson());
  }

  Future<void> deleteMeal(String id) async {
    await _firestore.collection('meals').doc(id).delete();
  }

  // Body Metrics
  Future<List<BodyMetrics>> getBodyMetricsHistory() async {
    QuerySnapshot snapshot = await _firestore
        .collection('body_metrics')
        .where('userId', isEqualTo: currentUser?.uid)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) => BodyMetrics.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addBodyMetrics(BodyMetrics metrics) async {
    metrics.userId = currentUser?.uid;
    await _firestore.collection('body_metrics').add(metrics.toJson());
  }

  // Water Intake (use Realtime Database or Firestore for daily tracking)
  Future<void> addWater(double amount) async {
    String dateKey = DateTime.now().toIso8601String().split('T')[0];
    DocumentReference docRef = _firestore.collection('water_intake').doc(currentUser!.uid).collection('days').doc(dateKey);
    await docRef.set({'amount': FieldValue.increment(amount)}, SetOptions(merge: true));
  }

  Future<double> getWaterIntakeToday() async {
    String dateKey = DateTime.now().toIso8601String().split('T')[0];
    DocumentSnapshot doc = await _firestore.collection('water_intake').doc(currentUser!.uid).collection('days').doc(dateKey).get();
    if (doc.exists) {
      return (doc.data() as Map<String, dynamic>)['amount']?.toDouble() ?? 0.0;
    }
    return 0.0;
  }

  Future<void> resetWaterIntake() async {
    String dateKey = DateTime.now().toIso8601String().split('T')[0];
    await _firestore.collection('water_intake').doc(currentUser!.uid).collection('days').doc(dateKey).delete();
  }

  // Drinks methods
  Future<List<Drink>> getDrinksForDate(DateTime date) async {
    final userId = currentUser?.uid;
    if (userId == null) {
      print('No user authenticated, returning empty drinks list');
      return [];
    }

    print('Getting drinks for date: ${date.toString()}, userId: $userId');

    try {
      // Buscar todas as bebidas do usuário (evita erro de índice composto)
      QuerySnapshot snapshot = await _firestore
          .collection('drinks')
          .where('userId', isEqualTo: userId)
          .get();

      print('Found ${snapshot.docs.length} total drinks for user $userId');
      
      // Filtrar por data em memória
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final drinks = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // Converter Timestamp para DateTime string se necessário
            if (data['dateTime'] is Timestamp) {
              data['dateTime'] = (data['dateTime'] as Timestamp).toDate().toIso8601String();
            }
            data['id'] = doc.id;
            // Garantir que userId está presente
            if (!data.containsKey('userId') || data['userId'] == null) {
              data['userId'] = userId;
            }
            return Drink.fromJson(data);
          })
          .where((drink) {
            // Filtrar bebidas para a data específica
            final drinkDate = drink.dateTime;
            return drinkDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
                   drinkDate.isBefore(endOfDay);
          })
          .toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime)); // Ordenar por data descendente
      
      print('Filtered to ${drinks.length} drinks for user $userId on date ${date.toString().split(' ')[0]}');
      return drinks;
    } catch (e) {
      print('Error getting drinks for user $userId: $e');
      return [];
    }
  }

  Future<void> addDrink(Drink drink) async {
    final userId = currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated - cannot save drink');
    }
    
    // Garantir que o userId está definido
    drink.userId = userId;
    
    // Converter dateTime para Timestamp
    final drinkData = drink.toJson();
    drinkData['dateTime'] = Timestamp.fromDate(drink.dateTime);
    drinkData['userId'] = userId; // Garantir que userId está no JSON
    
    print('Adding drink: userId=$userId, dateTime=${drink.dateTime}, name=${drink.name}, amount=${drink.amount}ml');
    final docRef = await _firestore.collection('drinks').add(drinkData);
    print('Drink added with ID: ${docRef.id}');
    
    // Verificar se foi salvo corretamente
    final savedDoc = await _firestore.collection('drinks').doc(docRef.id).get();
    if (savedDoc.exists) {
      final savedData = savedDoc.data();
      print('Drink saved successfully. Saved userId: ${savedData?['userId']}');
    }
    
    // Also add to water intake if it's water
    if (drink.name.toLowerCase().contains('água') || drink.name.toLowerCase() == 'água') {
      await addWater(drink.amount);
    }
  }

  Future<void> deleteDrink(String id) async {
    await _firestore.collection('drinks').doc(id).delete();
  }

  // Get all drinks from Firebase (drinks database collection)
  Future<List<Map<String, dynamic>>> getAllDrinks() async {
    QuerySnapshot snapshot = await _firestore.collection('drinks_database').get();
    if (snapshot.docs.isEmpty) {
      // If collection doesn't exist, return default drinks
      return _getDefaultDrinks();
    }
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  List<Map<String, dynamic>> _getDefaultDrinks() {
    return [
      {'name': 'Água', 'calories': 0, 'serving': '200ml'},
      {'name': 'Café Preto', 'calories': 5, 'serving': '200ml'},
      {'name': 'Suco de Laranja', 'calories': 120, 'serving': '300ml'},
      {'name': 'Refrigerante', 'calories': 140, 'serving': '350ml'},
      {'name': 'Leite', 'calories': 150, 'serving': '200ml'},
      {'name': 'Chá Verde', 'calories': 0, 'serving': '200ml'},
      {'name': 'Suco de Maçã', 'calories': 110, 'serving': '300ml'},
      {'name': 'Água de Coco', 'calories': 45, 'serving': '300ml'},
      {'name': 'Café com Leite', 'calories': 50, 'serving': '200ml'},
      {'name': 'Chá de Camomila', 'calories': 0, 'serving': '200ml'},
      {'name': 'Suco de Uva', 'calories': 130, 'serving': '300ml'},
      {'name': 'Água Tônica', 'calories': 85, 'serving': '350ml'},
      {'name': 'Cerveja', 'calories': 150, 'serving': '350ml'},
      {'name': 'Vinho Tinto', 'calories': 85, 'serving': '150ml'},
      {'name': 'Smoothie de Frutas', 'calories': 200, 'serving': '300ml'},
      {'name': 'Chá de Hortelã', 'calories': 0, 'serving': '200ml'},
      {'name': 'Suco de Abacaxi', 'calories': 125, 'serving': '300ml'},
      {'name': 'Água com Gás', 'calories': 0, 'serving': '200ml'},
      {'name': 'Cappuccino', 'calories': 80, 'serving': '200ml'},
      {'name': 'Chocolate Quente', 'calories': 200, 'serving': '200ml'},
    ];
  }

  // Foods search (mock or integrate with external API; for now, use Firestore collection)
  Future<List<Map<String, dynamic>>> searchFoods(String query) async {
    QuerySnapshot snapshot = await _firestore
        .collection('foods')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .limit(10)
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Get all foods from Firebase
  Future<List<Map<String, dynamic>>> getAllFoods() async {
    QuerySnapshot snapshot = await _firestore.collection('foods').get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Friends (Firestore collection)
  Future<List<Map<String, dynamic>>> getFriends() async {
    QuerySnapshot snapshot = await _firestore
        .collection('friends')
        .where('userId', isEqualTo: currentUser?.uid)
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Suggestions (can be static or AI-generated; for now, static)
  List<Map<String, dynamic>> getMealSuggestions(String type) {
    // Similar to mock, but can be fetched from Firestore if needed
    switch (type) {
      case 'Café da Manhã':
        return [
          {'name': 'Aveia com Banana', 'calories': 250},
          {'name': 'Ovos Mexidos', 'calories': 180},
        ];
      case 'Almoço':
        return [
          {'name': 'Salada de Frango', 'calories': 350},
          {'name': 'Arroz com Feijão', 'calories': 400},
        ];
      case 'Jantar':
        return [
          {'name': 'Peixe Grelhado', 'calories': 300},
          {'name': 'Salada Verde', 'calories': 150},
        ];
      default:
        return [];
    }
  }

  // Subscription methods
  Future<void> saveSubscription(Subscription subscription) async {
    await _firestore.collection('subscriptions').doc(subscription.id).set(subscription.toJson());
  }

  Future<Subscription?> getSubscription(String subscriptionId) async {
    DocumentSnapshot doc = await _firestore.collection('subscriptions').doc(subscriptionId).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Subscription.fromJson(data);
    }
    return null;
  }

  Future<Subscription?> getActiveSubscription(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('subscriptions')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    
    if (snapshot.docs.isNotEmpty) {
      Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
      data['id'] = snapshot.docs.first.id;
      return Subscription.fromJson(data);
    }
    return null;
  }

  Future<List<Subscription>> getUserSubscriptions(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('subscriptions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Subscription.fromJson(data);
    }).toList();
  }

  Future<void> updateSubscriptionStatus(String subscriptionId, SubscriptionStatus status) async {
    await _firestore.collection('subscriptions').doc(subscriptionId).update({
      'status': status.name,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> cancelSubscription(String subscriptionId) async {
    await _firestore.collection('subscriptions').doc(subscriptionId).update({
      'status': 'cancelled',
      'updatedAt': Timestamp.now(),
    });
  }

  // Challenges methods
  Future<void> addChallenge(Challenge challenge) async {
    final userId = currentUser?.uid ?? challenge.userId;
    // Create a new challenge with the correct userId
    final challengeData = challenge.toJson();
    challengeData['userId'] = userId;
    await _firestore.collection('challenges').add(challengeData);
  }

  Future<List<Challenge>> getUserChallenges() async {
    if (currentUser?.uid == null) return [];
    
    QuerySnapshot snapshot = await _firestore
        .collection('challenges')
        .where('userId', isEqualTo: currentUser!.uid)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Challenge.fromJson(data);
    }).toList();
  }

  Future<void> deleteChallenge(String challengeId) async {
    await _firestore.collection('challenges').doc(challengeId).delete();
  }

  // Report methods
  Future<List<Meal>> getMealsForDateRange(DateTime start, DateTime end) async {
    if (currentUser?.uid == null) return [];
    
    Timestamp startTs = Timestamp.fromDate(start);
    Timestamp endTs = Timestamp.fromDate(end);
    
    QuerySnapshot snapshot = await _firestore
        .collection('meals')
        .where('dateTime', isGreaterThanOrEqualTo: startTs)
        .where('dateTime', isLessThanOrEqualTo: endTs)
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Meal.fromJson(data);
    }).toList();
  }

  Future<List<Subscription>> getActiveSubscriptionsForDate(DateTime date) async {
    QuerySnapshot snapshot = await _firestore
        .collection('subscriptions')
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Subscription.fromJson(data);
    }).toList();
  }
}
