import 'package:flutter/material.dart';

class WorkoutHistoryPage extends StatefulWidget {
  const WorkoutHistoryPage({super.key});

  @override
  _WorkoutHistoryPageState createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  List<Workout> workouts = [];

  @override
  void initState() {
    super.initState();
    // Load initial data if any
    workouts = [
      Workout(
        name: 'Petto e tricipiti',
        date: DateTime(2022, 1, 1),
        exercises: [
          Exercise(name: 'Panca piana', description: '3 serie da 10 reps'),
          Exercise(name: 'Tricipiti cavo alto', description: '3 serie da 12 reps'),
          Exercise(name: 'Tirate al mento bilancere sagomato', description: '3 serie da 15 reps'),
        ],
      ),
      Workout(
        name: 'Dorso e bicipiti',
        date: DateTime(2022, 1, 3),
        exercises: [
          Exercise(name: 'Pull-ups', description: '3 serie da 8 reps'),
          Exercise(name: 'Manubri', description: '3 serie da 10 reps'),
          Exercise(name: 'Curl bilancere panca scott', description: '3 serie da 12 reps'),
        ],
      ),
      // Add more initial data as needed
    ];
  }

  void _addWorkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWorkoutPage(
          onAddWorkout: (workout) {
            setState(() {
              workouts.add(workout);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronologia allenamenti'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addWorkout,
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: workouts.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return WorkoutHistoryItem(workout: workouts[index]);
        },
      ),
    );
  }
}

class WorkoutHistoryItem extends StatelessWidget {
  final Workout workout;

  const WorkoutHistoryItem({required this.workout, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(workout.name),
        subtitle: Text(workout.date.toString()),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutExerciseListPage(workout: workout),
            ),
          );
        },
      ),
    );
  }
}

class Workout {
  final String name;
  final DateTime date;
  final List<Exercise> exercises;

  Workout({required this.name, required this.date, required this.exercises});

  // Convert Workout to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date.toIso8601String(),
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  // Convert JSON to Workout
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json['name'],
      date: DateTime.parse(json['date']),
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList(),
    );
  }
}

class Exercise {
  final String name;
  final String description;

  Exercise({required this.name, required this.description});

  // Convert Exercise to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
      };

  // Convert JSON to Exercise
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      description: json['description'],
    );
  }
}

class WorkoutExerciseListPage extends StatelessWidget {
  final Workout workout;

  const WorkoutExerciseListPage({required this.workout, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
      ),
      body: ListView.separated(
        itemCount: workout.exercises.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ExerciseListItem(exercise: workout.exercises[index]);
        },
      ),
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;

  const ExerciseListItem({required this.exercise, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exercise.name),
      subtitle: Text(exercise.description),
    );
  }
}

class AddWorkoutPage extends StatefulWidget {
  final void Function(Workout) onAddWorkout;

  const AddWorkoutPage({required this.onAddWorkout, super.key});

  @override
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final TextEditingController _nameController = TextEditingController();
  final List<Exercise> _exercises = [];

  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _exerciseDescriptionController = TextEditingController();

  void _addExercise() {
    setState(() {
      _exercises.add(Exercise(
        name: _exerciseNameController.text,
        description: _exerciseDescriptionController.text,
      ));
      _exerciseNameController.clear();
      _exerciseDescriptionController.clear();
    });
  }

  void _saveWorkout() {
    final workout = Workout(
      name: _nameController.text,
      date: DateTime.now(),
      exercises: _exercises,
    );
    widget.onAddWorkout(workout);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aggiungi Allenamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome Allenamento',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _exerciseNameController,
              decoration: const InputDecoration(
                labelText: 'Nome Esercizio',
              ),
            ),
            TextField(
              controller: _exerciseDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrizione Esercizio',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addExercise,
              child: const Text('Aggiungi Esercizio'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.separated(
                itemCount: _exercises.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ExerciseListItem(exercise: _exercises[index]);
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveWorkout,
              child: const Text('Salva Allenamento'),
            ),
          ],
        ),
      ),
    );
  }
}
