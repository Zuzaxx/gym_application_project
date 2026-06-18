class WorkoutExercise {
  final String exerciseId;
  final String exerciseName;
  int series;
  int powtorzenia;
  double kg;

  WorkoutExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.series,
    required this.powtorzenia,
    required this.kg,
  });
}