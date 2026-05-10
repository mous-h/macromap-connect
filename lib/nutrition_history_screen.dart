import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NutritionHistoryScreen extends StatelessWidget {
  const NutritionHistoryScreen({super.key});

  List<String> _last7Days() {
    return List.generate(7, (i) {
      final day = DateTime.now().subtract(Duration(days: i));
      return DateFormat('yyyy-MM-dd').format(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final days = _last7Days();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weekly History',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final dateKey = days[index];
          final label = index == 0
              ? 'Today'
              : index == 1
              ? 'Yesterday'
              : dateKey;
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('mealLogs')
                .where('userId', isEqualTo: user?.uid)
                .where('dateKey', isEqualTo: dateKey)
                .snapshots(),
            builder: (context, snapshot) {
              int totalCals = 0;
              int totalProtein = 0;
              int count = 0;
              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  totalCals += (data['calories'] as num).toInt();
                  totalProtein += (data['protein'] as num).toInt();
                  count++;
                }
              }
              final progress = (totalCals / 2500).clamp(0.0, 1.0);
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '$count meals',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade200,
                          color: totalCals > 2500
                              ? Colors.orange
                              : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '$totalCals kcal',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${totalProtein}g protein',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
