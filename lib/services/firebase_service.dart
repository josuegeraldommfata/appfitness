import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as model;
import '../models/meal.dart';
import '../models/body_metrics.dart';

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
      if (data['email'] == 'admin@email.com' && !data.containsKey('role')) {
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
    return snapshot.docs.map((doc) => model.User.fromJson(doc.data() as Map<String, dynamic>)).toList();
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
    Timestamp start = Timestamp.fromDate(DateTime(date.year, date.month, date.day));
    Timestamp end = Timestamp.fromDate(DateTime(date.year, date.month, date.day + 1));

    QuerySnapshot snapshot = await _firestore
        .collection('meals')
        .where('userId', isEqualTo: currentUser?.uid)
        .where('dateTime', isGreaterThanOrEqualTo: start)
        .where('dateTime', isLessThan: end)
        .get();

    return snapshot.docs.map((doc) => Meal.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> addMeal(Meal meal) async {
    meal.userId = currentUser?.uid;
    await _firestore.collection('meals').add(meal.toJson());
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
}
