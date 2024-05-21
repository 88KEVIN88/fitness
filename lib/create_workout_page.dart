
import 'package:flutter/material.dart';

class CreateWorkoutPage extends StatefulWidget {
  const CreateWorkoutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  List<Exercise> exercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea Esercizio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _addExercise();
              },
              child: const Text('Aggiungi Allenamento'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return _buildExerciseCard(exercises[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(exercise.name),
        subtitle: Text('Serie: ${exercise.name}, Ripetizioni: ${exercise.description}'),
      ),
    );
  }

  void _addExercise() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String exerciseName = '';
      int sets = 0;
      int reps = 0;

      return AlertDialog(
        backgroundColor: Colors.blue, // Sfondo blu
        title: const Text('Aggiungi esercizio', style: TextStyle(color: Colors.white)), // Testo bianco
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nome', labelStyle: TextStyle(color: Colors.white)), // Testo bianco
              style: const TextStyle(color: Colors.white), // Testo bianco
              onChanged: (value) {
                exerciseName = value;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Serie', labelStyle: TextStyle(color: Colors.white)), // Testo bianco
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white), // Testo bianco
              onChanged: (value) {
                sets = int.tryParse(value) ?? 0;
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Ripetizioni', labelStyle: TextStyle(color: Colors.white)), // Testo bianco
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white), // Testo bianco
              onChanged: (value) {
                reps = int.tryParse(value) ?? 0;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.white)), // Testo bianco
          ),
          ElevatedButton(
            onPressed: () {
              if (exerciseName.isNotEmpty && sets > 0 && reps > 0) {
                setState(() {
                  exercises.add(
                    Exercise(
                      name: exerciseName,
                      description: 'Serie: $sets, Ripetizioni: $reps',
                    ),
                  );
                });
                Navigator.pop(context);
              } else {
                
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Sfondo blu
            ),
            child: const Text('Add', style: TextStyle(color: Colors.white)), // Testo bianco
          ),
        ],
      );
    },
  );
}
}




class CustomExercise {
  final String exerciseName;
  final int sets;
  final int reps;

  CustomExercise({required this.exerciseName, required this.sets, required this.reps});
}

class Exercise {
  final String name;
  final String description;

  Exercise({required this.name, required this.description});
}