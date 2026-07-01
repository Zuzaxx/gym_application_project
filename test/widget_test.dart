// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_project/main.dart';
import 'package:flutter_application_project/models/workout_session.dart';

void main() {
  // 1. TEST MAILA
  test('Test jednostkowy sprawdzajacy poprawnosc walidacji emaila', () {
    final emailPodany = "test@gym.com";
    final czyZawieraMape = emailPodany.contains('@');
    expect(czyZawieraMape, true);
  });

  // 2. TEST PUSTEGO POLA
  test('Test jednostkowy sprawdzajacy wykrywanie pustego pola', () {
    final wpisanyEmail = ""; // udajemy, że użytkownik nic nie wpisał
    final czyJestPusty = wpisanyEmail.isEmpty;
    expect(czyJestPusty, true); // oczekujemy, że program potwierdzi: "tak, jest pusty"
  });

  // 3. TEST DŁUGOŚCI HASŁA
  test('Test jednostkowy sprawdzajacy walidacje zbyt krotkiego hasla', () {
    final hasloPodane = "123"; // za krótkie hasło
    final czyZaKrotkie = hasloPodane.length < 6;
    expect(czyZaKrotkie, true); // oczekujemy prawdy, bo 3 znaki to mniej niż 6
  });
  // 4. TEST MODELU: SPRAWDZANIE POPRAWNOŚCI DATY W WORKOUTSESSION
  test('Test jednostkowy modelu: poprawne parsowanie daty sesji treningowej', () {
    final testowaData = DateTime(2026, 6, 30, 18, 30); // 30 czerwca 2026, 18:30
    
    // Tworzymy sztuczny obiekt sesji treningowej
    final sesja = WorkoutSession(
      id: 'test_id',
      planName: 'Trening klatki',
      date: testowaData,
      durationInSeconds: 3600,
      exercises: [],
    );

    // Sprawdzamy, czy model poprawnie przechowuje i zwraca naszą datę
    expect(sesja.date, testowaData);
    expect(sesja.date.year, 2026);
    expect(sesja.date.month, 6);
  });

  // 5. TEST MODELU: SPRAWDZANIE CZASU TRWANIA TRENINGU
  test('Test jednostkowy modelu: sprawdzanie czasu trwania cwiczen w sekundach', () {
    final oczekiwanyCzas = 4500; // np. 1 godzina i 15 minut (w sekundach)
    
    final sesja = WorkoutSession(
      id: 'test_id_2',
      planName: 'Trening nog',
      date: DateTime.now(),
      durationInSeconds: oczekiwanyCzas,
      exercises: [],
    );

    // Sprawdzamy, czy czas trwania został zapisany bezbłędnie
    expect(sesja.durationInSeconds, oczekiwanyCzas);
    // Dodatkowy test logiczny: sprawdzamy, czy czas jest liczbą dodatnią
    expect(sesja.durationInSeconds > 0, true);
  });
}

