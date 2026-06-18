import 'package:flutter/material.dart';
import '../models/workout_session.dart';
import '../services/session_service.dart';

class EkranHistoriaTreningow extends StatelessWidget {
  const EkranHistoriaTreningow({super.key});

  // Pomocnicza funkcja do zamiany sekund na minuty i sekundy na liście
  String _formatujCzas(int calkowiteSekundy) {
    int minuty = calkowiteSekundy ~/ 60;
    int sekundy = calkowiteSekundy % 60;
    return '${minuty}m ${sekundy}s';
  }

  // NOWA: Pomocnicza funkcja do formatowania daty bez użycia dodatkowych bibliotek
  String _formatujDate(DateTime data) {
    String dzien = data.day.toString().padLeft(2, '0');
    String miesiac = data.month.toString().padLeft(2, '0');
    String rok = data.year.toString();
    String godzina = data.hour.toString().padLeft(2, '0');
    String minuta = data.minute.toString().padLeft(2, '0');
    return '$dzien.$miesiac.$rok $godzina:$minuta';
  }

  @override
  Widget build(BuildContext context) {
    final SessionService sessionService = SessionService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historia Treningów'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<WorkoutSession>>(
        stream: sessionService.getWorkoutSessions(),
        builder: (context, snapshot) {
          // 1. Sprawdzanie czy trwa ładowanie danych
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Sprawdzanie czy wystąpił błąd
          if (snapshot.hasError) {
            return Center(child: Text('Błąd pobierania danych: ${snapshot.error}'));
          }

          // 3. Sprawdzanie czy lista jest pusta
          final sesje = snapshot.data ?? [];
          if (sesje.isEmpty) {
            return const Center(
              child: Text('Brak odbytych treningów. Czas coś poćwiczyć!'),
            );
          }

          // 4. Wyświetlanie listy treningów
          return ListView.builder(
            itemCount: sesje.length,
            itemBuilder: (context, index) {
              final sesja = sesje[index];
              // Używamy naszej nowej funkcji do formatowania daty
              final String sformatowanaData = _formatujDate(sesja.date);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green, size: 35),
                  title: Text(
                    sesja.planName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text('$sformatowanaData\nCzas trwania: ${_formatujCzas(sesja.durationInSeconds)}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TUTAJ w kolejnym etapie podepniemy Ekran Szczegółów (punkt 5 z planu)
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}