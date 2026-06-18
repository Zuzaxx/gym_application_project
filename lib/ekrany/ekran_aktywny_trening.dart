import 'package:flutter/material.dart';
import 'dart:async';
import '../models/workout_session.dart';
import '../services/session_service.dart';

class EkranAktywnyTrening extends StatefulWidget {
  // Tego brakowało - ekran musi umieć odebrać dane z planu!
  final String? nazwaPlanu;
  final List<dynamic>? poczatkoweCwiczeniaRaw;

  const EkranAktywnyTrening({super.key, this.nazwaPlanu, this.poczatkoweCwiczeniaRaw});

  @override
  State<EkranAktywnyTrening> createState() => _EkranAktywnyTreningState();
}

class _EkranAktywnyTreningState extends State<EkranAktywnyTrening> {
  int _sekundy = 0;
  Timer? _stoper;
  List<PerformedExercise> aktualneCwiczenia = [];
  final SessionService _sessionService = SessionService();
  bool _trwaZapisywanie = false;

  @override
  void initState() {
    super.initState();
    _startStoper();
    
    // Jeśli wchodzimy z gotowego planu, ładujemy ćwiczenia
    if (widget.poczatkoweCwiczeniaRaw != null) {
      aktualneCwiczenia = widget.poczatkoweCwiczeniaRaw!.map((e) {
        final dynamic cw = e;
        int s = (cw.series is int) ? cw.series : 1;
        return PerformedExercise(
          name: cw.exerciseName.toString(),
          sets: List.generate(s, (_) => WorkoutSet(weight: cw.kg.toDouble(), reps: cw.powtorzenia)),
        );
      }).toList();
    }
  }

  void _startStoper() {
    _stoper = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _sekundy++);
    });
  }

  void _pokazOknoDodawaniaCwiczenia() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dodaj ćwiczenie'),
        content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(hintText: 'Nazwa')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Anuluj')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => aktualneCwiczenia.add(PerformedExercise(name: controller.text.trim(), sets: [])));
                Navigator.pop(context);
              }
            },
            child: const Text('Dodaj'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _stoper?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nazwaPlanu ?? 'Trening bez planu'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('${(_sekundy ~/ 60).toString().padLeft(2, '0')}:${(_sekundy % 60).toString().padLeft(2, '0')}', 
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: aktualneCwiczenia.length,
              itemBuilder: (context, i) {
                final cw = aktualneCwiczenia[i];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cw.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ...cw.sets.asMap().entries.map((entry) {
                          WorkoutSet seria = entry.value;
                          return Row(children: [
                            Text('Seria ${entry.key + 1}'),
                            const SizedBox(width: 10),
                            Expanded(child: TextFormField(
                              initialValue: seria.weight.toString(),
                              decoration: const InputDecoration(labelText: 'kg'),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => seria.weight = double.tryParse(v) ?? 0,
                            )),
                            const SizedBox(width: 10),
                            Expanded(child: TextFormField(
                              initialValue: seria.reps.toString(),
                              decoration: const InputDecoration(labelText: 'powt'),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => seria.reps = int.tryParse(v) ?? 0,
                            )),
                            Checkbox(value: seria.isCompleted, onChanged: (v) => setState(() => seria.isCompleted = v ?? false)),
                          ]);
                        }),
                        TextButton.icon(
                          icon: const Icon(Icons.add), 
                          label: const Text('Dodaj serię'), 
                          onPressed: () => setState(() => cw.sets.add(WorkoutSet(weight: 0, reps: 0)))
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton.icon(onPressed: _pokazOknoDodawaniaCwiczenia, icon: const Icon(Icons.add), label: const Text("Dodaj ćwiczenie")),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: _trwaZapisywanie ? null : () async {
                setState(() => _trwaZapisywanie = true);
                try {
                  final nowaSesja = WorkoutSession(
                    planName: widget.nazwaPlanu ?? 'Trening bez planu',
                    date: DateTime.now(),
                    durationInSeconds: _sekundy,
                    exercises: aktualneCwiczenia,
                  );
                  await _sessionService.saveWorkoutSession(nowaSesja);
                  if (mounted) Navigator.pop(context);
                } catch (e) {
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Błąd: $e'), backgroundColor: Colors.red));
                  setState(() => _trwaZapisywanie = false);
                }
              },
              child: _trwaZapisywanie ? const CircularProgressIndicator(color: Colors.white) : const Text('Zakończ i zapisz'),
            ),
          ),
        ],
      ),
    );
  }
}