import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/exercise.dart';

class EkranBibliotekaCwiczen extends StatefulWidget {
  const EkranBibliotekaCwiczen({super.key});

  @override
  State<EkranBibliotekaCwiczen> createState() => _EkranBibliotekaCwiczenState();
}

class _EkranBibliotekaCwiczenState extends State<EkranBibliotekaCwiczen> {
  List<Exercise> wszystkieCwiczenia = [];
  List<Exercise> przefiltrowane = [];
  final TextEditingController wyszukiwarka = TextEditingController();

  @override
  void initState() {
    super.initState();
    wczytajCwiczenia();
  }

// tu jest funkcja by bral automatycznie z json ale mi 
//nie dzialala , wiec pod spodem recznie
  // Future<void> wczytajCwiczenia() async {
  //   try {
  //     final String data = await rootBundle.loadString('assets/exercises.json');
  //     final List<dynamic> jsonList = json.decode(data);
  //     setState(() {
  //       wszystkieCwiczenia = jsonList.map((e) => Exercise.fromJson(e)).toList();
  //       przefiltrowane = wszystkieCwiczenia;
  //     });
  //     print('Wczytano ${wszystkieCwiczenia.length} ćwiczeń');
  //   } catch (e) {
  //     print('BŁĄD: $e');
  //   }
  // }

  Future<void> wczytajCwiczenia() async {
    setState(() {
      wszystkieCwiczenia = [
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
      przefiltrowane = wszystkieCwiczenia;
    });
  }

  void filtruj(String fraza) {
    setState(() {
      przefiltrowane = wszystkieCwiczenia
          .where((e) =>
              e.name.toLowerCase().contains(fraza.toLowerCase()) ||
              e.muscleGroup.toLowerCase().contains(fraza.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteka ćwiczeń'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: wyszukiwarka,
              onChanged: filtruj,
              decoration: const InputDecoration(
                hintText: 'Szukaj ćwiczenia...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: przefiltrowane.length,
              itemBuilder: (context, index) {
                final cwiczenie = przefiltrowane[index];
                return ListTile(
                  title: Text(cwiczenie.name),
                  subtitle: Text(cwiczenie.muscleGroup),
                  leading: const Icon(Icons.fitness_center),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}