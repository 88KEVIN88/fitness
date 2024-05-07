
import 'package:flutter/material.dart';


class WorkoutHistoryPage extends StatelessWidget {
  const WorkoutHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronologia allenamenti'),
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
}

class Exercise {
  final String name;
  final String description;

  Exercise({required this.name, required this.description});
}

// Example data
List<Workout> workouts = [
  Workout(
    name: 'Petto e tricipiti',
    date: DateTime(2022, 1, 1),
    exercises: [
      Exercise(name: 'Panca piana', description: '3 serie da 10 reps'),
      Exercise(name: 'Tricipiti cavo alto', description: '3 serie da 12 reps'),
      Exercise(
          name: 'Tirate al mento bilancere sagomato',
          description: '3 serie da 15 reps'),
    ],
  ),
  Workout(
    name: 'Dorso e bicipiti',
    date: DateTime(2022, 1, 3),
    exercises: [
      Exercise(name: 'Pull-ups', description: '3 serie da 8 reps'),
      Exercise(name: 'Manubri', description: '3 serie da 10 reps'),
      Exercise(
          name: 'Curl bilancere panca scott', description: '3 serie da 12 reps'),
    ],
  ),
  Workout(
    name: 'Allenamento HIIT',
    date: DateTime(2022, 1, 17),
    exercises: [
      Exercise(
          name: 'Jump squats',
          description:
              'Tabata: 20 secondi di lavoro, 10 secondi di riposo, per 4 minuti'),
      Exercise(
          name: 'Mountain climbers',
          description:
              'Tabata: 20 secondi di lavoro, 10 secondi di riposo, per 4 minuti'),
      Exercise(
          name: 'Burpees',
          description:
              'Tabata: 20 secondi di lavoro, 10 secondi di riposo, per 4 minuti'),
    ],
  ),
  Workout(
    name: 'Allenamento a corpo libero',
    date: DateTime(2022, 1, 19),
    exercises: [
      Exercise(name: 'Push-up', description: '5 serie da 15 reps'),
      Exercise(name: 'Squat jump', description: '4 serie da 12 reps'),
      Exercise(name: 'Plank', description: '3 serie da 45 secondi'),
    ],
  ),
  Workout(
    name: 'Allenamento della resistenza',
    date: DateTime(2022, 1, 21),
    exercises: [
      Exercise(name: 'Swing con kettlebell', description: '4 serie da 15 reps'),
      Exercise(
          name: 'Affondi con salto', description: '3 serie da 12 reps per gamba'),
      Exercise(name: 'Curl bicipiti con manubri', description: '3 serie da 12 reps'),
    ],
  ),
  Workout(
    name: 'Allenamento del powerlifting',
    date: DateTime(2022, 1, 23),
    exercises: [
      Exercise(name: 'Squat', description: '5 serie da 5 reps'),
      Exercise(name: 'Panca piana', description: '5 serie da 5 reps'),
      Exercise(name: 'Stacchi da terra', description: '5 serie da 5 reps'),
    ],
  ),
];
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