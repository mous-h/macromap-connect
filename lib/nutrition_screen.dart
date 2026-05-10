import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'saudi_food_data.dart';
import 'meal_log_model.dart';
import 'nutrition_history_screen.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});
  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final int targetCalories = 2500;
  final String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void _logFood(FoodItem item) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final log = MealLog(
      id: '',
      userId: user.uid,
      mealType: 'snack',
      foodName: "${item.restaurant}: ${item.name}",
      calories: item.calories,
      protein: item.protein,
      loggedAt: DateTime.now(),
      dateKey: todayKey,
    );

    await FirebaseFirestore.instance.collection('mealLogs').add(log.toMap());

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logged ${item.name}!")));
    }
  }

  void _deleteLog(String docId) async {
    await FirebaseFirestore.instance.collection('mealLogs').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NutritionHistoryScreen()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('mealLogs')
            .where('userId', isEqualTo: user?.uid)
            .where('dateKey', isEqualTo: todayKey)
            .orderBy('loggedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          int currentCalories = 0;
          List<DocumentSnapshot> todayLogs = [];

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            todayLogs = snapshot.data!.docs;
            for (var doc in todayLogs) {
              final data = doc.data() as Map<String, dynamic>;
              currentCalories += (data['calories'] as num).toInt();
            }
          }

          double progress = currentCalories / targetCalories;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: progress > 1.0 ? 1.0 : progress,
                  minHeight: 20,
                  backgroundColor: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "$currentCalories / $targetCalories kcal",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (todayLogs.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text(
                    "Today's Logs (Tap 🗑️ to undo)",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: todayLogs.length,
                      itemBuilder: (context, index) {
                        final data =
                            todayLogs[index].data() as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Text(
                                  data['foodName']
                                      .toString()
                                      .split(':')
                                      .last
                                      .trim(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      _deleteLog(todayLogs[index].id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                const Divider(height: 40),
                const Text(
                  "Quick Log Saudi Restaurants",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: saudiFoodDatabase.length,
                    itemBuilder: (context, index) {
                      final food = saudiFoodDatabase[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(food.name),
                          subtitle: Text(food.restaurant),
                          trailing: Text("${food.calories} kcal"),
                          onTap: () => _logFood(food),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
