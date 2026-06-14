import 'package:flutter/material.dart';
import 'ekran_tworzenie_planu.dart';

class StartowyEkran extends StatefulWidget {
  const StartowyEkran({super.key, required this.title});

  final String title;

  @override
  State<StartowyEkran> createState() => _StartowyEkranState();
}

class _StartowyEkranState extends State<StartowyEkran> {
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.title),
      centerTitle: true,
    ),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          const Icon(
            Icons.fitness_center,
            size: 100,
          ),

          const SizedBox(height: 20),

          const Text(
            'Twój Trener Personalny',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Generuj spersonalizowane plany treningowe i śledź postępy.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard("0", "Treningów"),
              _buildStatCard("0", "Planów"),
              _buildStatCard("0", "Dni"),
            ],
          ),

          const Spacer(),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EkranTworzeniaPlanu(),
                  ),
              );
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text("Stwórz plan treningowy"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),

          const SizedBox(height: 15),

          OutlinedButton.icon(
            onPressed: () {
              // TODO: przejście do historii planów
            },
            icon: const Icon(Icons.history),
            label: const Text("Historia planów"),
          ),
        ],
      ),
    ),
  );
}

Widget _buildStatCard(String value, String label) {
  return Card(
    elevation: 3,
    child: SizedBox(
      width: 90,
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label),
        ],
      ),
    ),
  );
}
  
}
