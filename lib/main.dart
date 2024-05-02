import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allenamento Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ProfilePage(),
    const WorkoutHistoryPage(),
    const CreateWorkoutPage(),
    const AllWorkoutsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Tracker'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.blue),
            label: 'Profilo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, color: Colors.blue),
            label: 'Cronologia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.blue),
            label: 'Crea',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.blue),
            label: 'Tutti',
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showUserData = false;
  final weightData = getWeightData(0);
  final workoutData = getWorkoutData();

  @override
  Widget build(BuildContext context) {
    final userData = getUserData();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                showUserData = !showUserData;
              });
            },
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      'https://www.w3schools.com/howto/img_avatar.png'),
                ),
                const SizedBox(width: 16.0),
                Text(
                  userData.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          if (showUserData)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dati dell\'utente',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial',
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Nome: ${userData.name}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Arial',
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Età: ${userData.age}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Arial',
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Email: ${userData.email}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Arial',
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10.0),
          const Text(
            'Andamento del peso',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arial',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Aggiungi Misurazione'),
                    content: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Peso',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {},
                    ),
                    backgroundColor: Colors.white,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          weightData.add(WeightData(
                              date: DateTime.now(),
                              weight: double.parse(context.toString())));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        child: const Text('Salva'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text(
              'Aggiungi',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 200,
            child: WeightChart(data: weightData),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Andamento degli allenamenti',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Arial',
            ),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 200,
            child: WorkoutChart(data: workoutData),
          ),
        ],
      ),
    );
  }
}

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

// Example data models
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
        title: const Text('Aggiugi Allenamento'),
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
class UserData {
  final String name;
  final int age;
  final String email;

  UserData({required this.name, required this.age, required this.email});
}

UserData getUserData() {
  return UserData(
    name: 'Marco Rossi',
    age: 25,
    email: 'Marco.rossi@gmail.com',
  );
}

class WeightChart extends StatelessWidget {
  final List<WeightData> data;

  const WeightChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _createSeriesData(),
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
        ),
      ),
    );
  }

  List<charts.Series<WeightData, DateTime>> _createSeriesData() {
    return [
      charts.Series<WeightData, DateTime>(
        id: 'Peso',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
        domainFn: (WeightData weightData, _) => weightData.date,
        measureFn: (WeightData weightData, _) => weightData.weight,
        data: data,
      ),
    ];
  }
}

class WeightData {
  final DateTime date;
  final double weight;

  WeightData({required this.date, required this.weight});
}

List<WeightData> getWeightData(double weight) {
  return [
    WeightData(date: DateTime(2022, 1, 1), weight: 80),
    WeightData(date: DateTime(2022, 2, 2), weight: 87),
    WeightData(date: DateTime(2022, 3, 3), weight: 70),
    WeightData(date: DateTime(2022, 4, 4), weight: 60),
    WeightData(date: DateTime(2022, 4, 21), weight: 70),
  ];
}

class WorkoutChart extends StatelessWidget {
  final List<WorkoutData> data;

  const WorkoutChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _createSeriesData(),
      animate: true,
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
          ),
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
        ),
      ),
    );
  }

  List<charts.Series<WorkoutData, String>> _createSeriesData() {
    return [
      charts.Series<WorkoutData, String>(
        id: 'Allenamento',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue),
        domainFn: (WorkoutData workoutData, _) => workoutData.day,
        measureFn: (WorkoutData workoutData, _) => workoutData.count,
        data: data,
      ),
    ];
  }
}

class WorkoutData {
  final String day;
  final int count;

  WorkoutData({required this.day, required this.count});
}

List<WorkoutData> getWorkoutData() {
  return [
    WorkoutData(day: 'Lun', count: 3),
    WorkoutData(day: 'Mar', count: 2),
    WorkoutData(day: 'Mer', count: 1),
    WorkoutData(day: 'Gio', count: 4),
    WorkoutData(day: 'Ven', count: 2),
    WorkoutData(day: 'Sab', count: 3),
    WorkoutData(day: 'Dom', count: 1),
  ];
}

class AllWorkoutsPage extends StatefulWidget {
  const AllWorkoutsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllWorkoutsPageState createState() => _AllWorkoutsPageState();
}

class _AllWorkoutsPageState extends State<AllWorkoutsPage> {
  Future<String>? _workoutsData;
  final _searchController = TextEditingController();

  Future<void> _searchWorkouts() async {
    String muscle = _searchController.text.trim();
    if (muscle.isEmpty) {
      return;
    }

    var headers = {
      'x-api-key': 'LlrTjX8IV5FmNPhYjKqPIw==Do2Frt05e6fPgKdY',
    };
    var url = Uri.https(
      'api.api-ninjas.com',
      '/v1/exercises',
      {'muscle': muscle, 'Key': 'LlrTjX8IV5FmNPhYjKqPIw==Do2Frt05e6fPgKdY'},
    );

    http.Response response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        _workoutsData = Future.value(response.body);
      });
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
      setState(() {
        _workoutsData = Future.error(response.reasonPhrase!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutti gli Allenamenti'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Inserisci il muscolo da cercare',
                  border: OutlineInputBorder(),
                ),
                onFieldSubmitted: (value) {
                  _searchWorkouts();
                },
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _searchWorkouts,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue[200],
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerca'),
          ),
          Expanded(
            child: Center(
              child: Container(
                color: Colors.lightBlue[100],
              child: Container(
               color: Colors.lightBlue[100],
              child: FutureBuilder<String>(
                future: _workoutsData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final List<dynamic> exercises = jsonDecode(snapshot.data ?? '[]');
                    return ListView.builder(
                      itemCount: exercises.length,  
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                exercise['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Type: ${exercise['type']}'),
                                  Text('Muscle: ${exercise['muscle']}'),
                                  Text('Equipment: ${exercise['equipment']}'),
                                  Text('Difficulty: ${exercise['difficulty']}'),
                                  Text('Instructions: ${exercise['instructions']}'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

