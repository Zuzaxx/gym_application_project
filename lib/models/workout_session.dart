import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutSet {
  double weight;
  int reps;
  bool isCompleted;

  WorkoutSet({required this.weight, required this.reps, this.isCompleted = false});

  Map<String, dynamic> toMap() => {
    'weight': weight, 
    'reps': reps, 
    'isCompleted': isCompleted
  };
  
  factory WorkoutSet.fromMap(Map<String, dynamic> map) => WorkoutSet(
    weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
    reps: map['reps'] as int? ?? 0,
    isCompleted: map['isCompleted'] as bool? ?? false,
  );
}

class PerformedExercise {
  String name;
  List<WorkoutSet> sets;

  PerformedExercise({required this.name, required this.sets});

  Map<String, dynamic> toMap() => {
    'name': name,
    'sets': sets.map((x) => x.toMap()).toList(),
  };

  factory PerformedExercise.fromMap(Map<String, dynamic> map) => PerformedExercise(
    name: map['name'] as String? ?? 'Nieznane ćwiczenie',
    sets: (map['sets'] as List<dynamic>? ?? []).map((x) => WorkoutSet.fromMap(x as Map<String, dynamic>)).toList(),
  );
}

class WorkoutSession {
  String id;
  String planName;
  DateTime date;
  int durationInSeconds;
  List<PerformedExercise> exercises;

  WorkoutSession({
    this.id = '', 
    required this.planName, 
    required this.date, 
    required this.durationInSeconds, 
    required this.exercises
  });

  // Zapis do Firebase (używamy Timestamp dla poprawnego formatu czasu)
  Map<String, dynamic> toMap() => {
    'id': id,
    'planName': planName,
    'date': Timestamp.fromDate(date),
    'durationInSeconds': durationInSeconds,
    'exercises': exercises.map((x) => x.toMap()).toList(),
  };

  // Odczyt z Firebase
  factory WorkoutSession.fromMap(Map<String, dynamic> map, String documentId) {
    DateTime parsedDate;
    
    // Bezpieczne sprawdzanie formatu daty
    if (map['date'] is Timestamp) {
      parsedDate = (map['date'] as Timestamp).toDate();
    } else if (map['date'] is String) {
      parsedDate = DateTime.tryParse(map['date'] as String) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return WorkoutSession(
      id: documentId.isEmpty ? (map['id'] ?? '') : documentId,
      planName: map['planName'] as String? ?? 'Trening',
      date: parsedDate,
      durationInSeconds: map['durationInSeconds'] as int? ?? 0,
      exercises: (map['exercises'] as List<dynamic>? ?? []).map((x) => PerformedExercise.fromMap(x as Map<String, dynamic>)).toList(),
    );
  }
}