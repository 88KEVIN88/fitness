import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final contents = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(contents);
      setState(() {
        workouts = jsonData.map((e) => Workout.fromJson(e)).toList();
        print('Allenamenti caricati correttamente.');
      });
    } else {
      print('Nessun file trovato.');
    }
  }

  Future<void> _saveWorkouts() async {
    final file = await _getLocalFile();
    final jsonData = workouts.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonData));
    print('Allenamenti salvati correttamente su ${file.path}');
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/Workout.json');
  }

  void _addWorkout(Workout workout) {
    setState(() {
      workouts.add(workout);
      _saveWorkouts();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Allenamento aggiunto con successo!')),
    );
  }

  void _editWorkout(Workout workout, int index) {
    setState(() {
      workouts[index] = workout;
      _saveWorkouts();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Allenamento modificato con successo!')),
    );
  }

  void _confirmDeleteWorkout(Workout workout) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Conferma eliminazione'),
        content: const Text('Sei sicuro di voler eliminare questo allenamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              _deleteWorkout(workout);
              Navigator.pop(ctx);
            },
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }

  void _deleteWorkout(Workout workout) {
    setState(() {
      workouts.remove(workout);
      _saveWorkouts();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Allenamento eliminato con successo!')),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddWorkoutPage(
                    onAddWorkout: (workout) {
                      _addWorkout(workout);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: workouts.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return WorkoutHistoryItem(
            workout: workouts[index],
            onEditWorkout: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddWorkoutPage(
                    workout: workouts[index],
                    onAddWorkout: (updatedWorkout) {
                      _editWorkout(updatedWorkout, index);
                    },
                  ),
                ),
              );
            },
            onDeleteWorkout: () {
              _confirmDeleteWorkout(workouts[index]);
            },
          );
        },
      ),
    );
  }
}

class WorkoutHistoryItem extends StatelessWidget {
  final Workout workout;
  final VoidCallback onEditWorkout;
  final VoidCallback onDeleteWorkout;

  const WorkoutHistoryItem({
    required this.workout,
    required this.onEditWorkout,
    required this.onDeleteWorkout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(workout.name),
        subtitle: Text(workout.date.toString()),
        onTap: onEditWorkout,
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDeleteWorkout,
        ),
      ),
    );
  }
}

class Workout {
  final String name;
  final DateTime date;
  final List<Exercise> exercises;

  Workout({required this.name, required this.date, required this.exercises});

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date.toIso8601String(),
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

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

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      description: json['description'],
    );
  }
}

class WorkoutExerciseListPage extends StatelessWidget {
  final Workout workout;
  final VoidCallback onEditWorkout;
  final VoidCallback onDeleteWorkout;

  const WorkoutExerciseListPage({
    required this.workout,
    required this.onEditWorkout,
    required this.onDeleteWorkout,
    super.key,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Conferma eliminazione'),
        content: const Text('Sei sicuro di voler eliminare questo allenamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              onDeleteWorkout();
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEditWorkout,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
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
  final Workout? workout;

  const AddWorkoutPage({required this.onAddWorkout, this.workout, super.key});

  @override
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final TextEditingController _nameController = TextEditingController();
  final List<Exercise> _exercises = [];

  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _exerciseDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _nameController.text = widget.workout!.name;
      _exercises.addAll(widget.workout!.exercises);
    }
  }

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
      date: widget.workout?.date ?? DateTime.now(),
      exercises: _exercises,
    );
    widget.onAddWorkout(workout);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Allenamento salvato con successo!')),
    );
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
