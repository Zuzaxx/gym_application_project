import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workout_session.dart';

class SessionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Funkcja zapisująca (już ją znasz)
  Future<void> saveWorkoutSession(WorkoutSession session) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Użytkownik nie jest zalogowany!');

    await _db
        .collection('users')
        .doc(user.uid)
        .collection('sessions')
        .add(session.toMap());
  }

  // NOWE: Funkcja pobierająca historię treningów zalogowanego użytkownika (od najnowszego)
  Stream<List<WorkoutSession>> getWorkoutSessions() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]); // Zwróć pustą listę, jeśli nikt nie jest zalogowany
    }

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('sessions')
        .orderBy('date', descending: true) // Najnowsze treningi na górze
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return WorkoutSession.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }
}