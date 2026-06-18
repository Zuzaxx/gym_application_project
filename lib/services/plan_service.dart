import '../models/workout_plan.dart';

class PlanService {
  static final PlanService _instance = PlanService._internal();
  factory PlanService() => _instance;
  PlanService._internal();

  final List<WorkoutPlan> _plany = [];

  List<WorkoutPlan> get plany => _plany;

  void dodajPlan(WorkoutPlan plan) {
    _plany.add(plan);
  }

  void usunPlan(String id) {
    _plany.removeWhere((p) => p.id == id);
  }

  void edytujPlan(WorkoutPlan nowyPlan) {
    final index = _plany.indexWhere((p) => p.id == nowyPlan.id);
    if (index != -1) {
      _plany[index] = nowyPlan;
    }
  }
}