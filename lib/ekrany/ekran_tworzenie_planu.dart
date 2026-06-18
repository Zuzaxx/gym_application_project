import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout_exercise.dart';
import '../models/workout_plan.dart';
import '../services/plan_service.dart';

class EkranTworzeniaPlanu extends StatefulWidget {
  const EkranTworzeniaPlanu({super.key});

  @override
  State<EkranTworzeniaPlanu> createState() => _EkranTworzeniaPlanuState();
}

class _EkranTworzeniaPlanuState extends State<EkranTworzeniaPlanu> {
  final TextEditingController nazwaPlanController = TextEditingController();
  final List<Exercise> wszystkieCwiczenia = [
    Exercise(id: '1', name: 'Przysiady', muscleGroup: 'Nogi'),
    Exercise(id: '2', name: 'Wykroki', muscleGroup: 'Nogi'),
    Exercise(id: '3', name: 'Martwy ciąg', muscleGroup: 'Plecy'),
    Exercise(id: '4', name: 'Podciąganie', muscleGroup: 'Plecy'),
    Exercise(id: '5', name: 'Hip Thrust', muscleGroup: 'Pośladki'),
    Exercise(id: '6', name: 'Odwodzenie na maszynie', muscleGroup: 'Pośladki'),
    Exercise(id: '7', name: 'Przywodzenie na maszynie', muscleGroup: 'Uda'),
    Exercise(id: '8', name: 'Wyciskanie sztangi', muscleGroup: 'Klatka piersiowa'),
    Exercise(id: '9', name: 'Pompki', muscleGroup: 'Klatka piersiowa'),
    Exercise(id: '10', name: 'Wiosłowanie sztangą', muscleGroup: 'Plecy'),
  ];

  final Map<String, bool> zaznaczone = {};
  final Map<String, TextEditingController> serieControllers = {};
  final Map<String, TextEditingController> powtorzeniaControllers = {};
  final Map<String, TextEditingController> kgControllers = {};

  @override
  void initState() {
    super.initState();
    for (var cwiczenie in wszystkieCwiczenia) {
      zaznaczone[cwiczenie.id] = false;
      serieControllers[cwiczenie.id] = TextEditingController(text: '3');
      powtorzeniaControllers[cwiczenie.id] = TextEditingController(text: '10');
      kgControllers[cwiczenie.id] = TextEditingController(text: '0');
    }
  }

  void zapiszPlan() {
    if (nazwaPlanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wpisz nazwę planu!')),
      );
      return;
    }

    final wybrane = wszystkieCwiczenia.where((e) => zaznaczone[e.id] == true).toList();

    if (wybrane.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wybierz co najmniej jedno ćwiczenie!')),
      );
      return;
    }

    final plan = WorkoutPlan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nazwaPlanController.text,
      exercises: wybrane.map((e) => WorkoutExercise(
        exerciseId: e.id,
        exerciseName: e.name,
        series: int.tryParse(serieControllers[e.id]!.text) ?? 3,
        powtorzenia: int.tryParse(powtorzeniaControllers[e.id]!.text) ?? 10,
        kg: double.tryParse(kgControllers[e.id]!.text) ?? 0,
      )).toList(),
    );
    
    PlanService().dodajPlan(plan);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Plan "${plan.name}" zapisany!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nowy plan treningowy'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: nazwaPlanController,
              decoration: const InputDecoration(
                labelText: 'Nazwa planu',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: wszystkieCwiczenia.length,
              itemBuilder: (context, index) {
                final cwiczenie = wszystkieCwiczenia[index];
                final zaznaczone_ = zaznaczone[cwiczenie.id] ?? false;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: Text(cwiczenie.name),
                        subtitle: Text(cwiczenie.muscleGroup),
                        value: zaznaczone_,
                        onChanged: (val) {
                          setState(() {
                            zaznaczone[cwiczenie.id] = val ?? false;
                          });
                        },
                      ),
                      if (zaznaczone_)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: serieControllers[cwiczenie.id],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Serie',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: powtorzeniaControllers[cwiczenie.id],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Powtórzenia',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: kgControllers[cwiczenie.id],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Kg',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: zapiszPlan,
              icon: const Icon(Icons.save),
              label: const Text('Zapisz plan'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}