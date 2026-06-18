import 'workout_exercise.dart';

class WorkoutPlan {
  String id;
  String name;
  List<WorkoutExercise> exercises;

  WorkoutPlan({required this.id, required this.name, required this.exercises});

  // Metoda do zapisu w Firebase
  Map<String, dynamic> toMap() => {
    'name': name,
    'exercises': exercises.map((e) => {
      'exerciseId': e.exerciseId,
      'exerciseName': e.exerciseName,
      'series': e.series,
      'powtorzenia': e.powtorzenia,
      'kg': e.kg,
    }).toList(),
  };

  // Metoda do odczytu z Firebase (tego brakowało!)
  factory WorkoutPlan.fromMap(Map<String, dynamic> map, String id) {
    return WorkoutPlan(
      id: id,
      name: map['name'] as String? ?? 'Bez nazwy',
      exercises: (map['exercises'] as List<dynamic>? ?? []).map((e) {
        final data = e as Map<String, dynamic>;
        return WorkoutExercise(
          exerciseId: data['exerciseId'] ?? '',
          exerciseName: data['exerciseName'] ?? 'Nieznane',
          series: data['series'] ?? 0,
          powtorzenia: data['powtorzenia'] ?? 0,
          kg: (data['kg'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList(),
    );
  }
}