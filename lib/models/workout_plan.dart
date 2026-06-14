import 'workout_exercise.dart';

class WorkoutPlan {
  final String id;
  final String name;
  final List<WorkoutExercise> exercises;

  WorkoutPlan({
    required this.id,
    required this.name,
    required this.exercises,
  });
}