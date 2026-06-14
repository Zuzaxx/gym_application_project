import 'package:flutter/material.dart';
import '../services/plan_service.dart';
import '../models/workout_plan.dart';
import 'ekran_edycji_planu.dart';

class EkranListaPlanow extends StatefulWidget {
  const EkranListaPlanow({super.key});

  @override
  State<EkranListaPlanow> createState() => _EkranListaPlanowState();
}

class _EkranListaPlanowState extends State<EkranListaPlanow> {
  final PlanService _planService = PlanService();

  void usunPlan(String id) {
    setState(() {
      _planService.usunPlan(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final plany = _planService.plany;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Moje plany treningowe'),
      ),
      body: plany.isEmpty
          ? const Center(
              child: Text(
                'Nie masz jeszcze żadnych planów!\nStwórz swój pierwszy plan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: plany.length,
              itemBuilder: (context, index) {
                final plan = plany[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(plan.name),
                    subtitle: Text('${plan.exercises.length} ćwiczeń'),
                    leading: const Icon(Icons.fitness_center),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EkranEdycjiPlanu(plan: plan),
                        ),
                      );
                      setState(() {});
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => usunPlan(plan.id),
                    ),
                  ),
                );
              },
            ),
    );
  }
}