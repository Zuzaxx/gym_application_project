import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_plan.dart';
import 'ekran_aktywny_trening.dart'; // Ekran ze stoperem (od osoby 3)
import 'ekran_edycji_planu.dart';

class EkranListaPlanow extends StatefulWidget {
  const EkranListaPlanow({super.key});

  @override
  State<EkranListaPlanow> createState() => _EkranListaPlanowState();
}

class _EkranListaPlanowState extends State<EkranListaPlanow> {
  // Pobieranie planów z Firebase
  Future<List<WorkoutPlan>> _pobierzPlany() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .get();

    return snapshot.docs.map((doc) => WorkoutPlan.fromMap(doc.data(), doc.id)).toList();
  }

  // Usuwanie planu z Firebase
  Future<void> usunPlan(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('plans')
        .doc(id)
        .delete();

    setState(() {}); // Odśwież widok po usunięciu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moje plany treningowe'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<WorkoutPlan>>(
        future: _pobierzPlany(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Brak zapisanych planów.\nStwórz nowy plan w menu głównym!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final plany = snapshot.data!;
          
          return ListView.builder(
            itemCount: plany.length,
            itemBuilder: (context, index) {
              final plan = plany[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.fitness_center, size: 30, color: Colors.blue),
                  title: Text(plan.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text('${plan.exercises.length} ćwiczeń\nDotknij, aby rozpocząć trening'),
                  isThreeLine: true,
                  
                  // OTO ZMIANA: Kliknięcie w cały pasek uruchamia trening ze stoperem
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EkranAktywnyTrening(
                          nazwaPlanu: plan.name,
                          poczatkoweCwiczeniaRaw: plan.exercises,
                        ),
                      ),
                    );
                  },

                  // Ikonki po prawej stronie karty
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Przycisk edycji (niebieski ołówek)
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => EkranEdycjiPlanu(plan: plan)));
                          setState(() {}); // Odśwież listę, jeśli plan został zmieniony
                        },
                      ),
                      // Przycisk usuwania (czerwony kosz)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => usunPlan(plan.id),
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