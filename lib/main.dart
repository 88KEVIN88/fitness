import 'dart:core';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const HomePage({Key? key}) : super(key: key);

  @override
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
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showUserData = false;

  @override
  Widget build(BuildContext context) {
    final userData = getUserData();
    final weightData = getWeightData(0);
    final workoutData = getWorkoutData();

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
  const WorkoutHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cronologia allenamenti'),
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          return WorkoutHistoryItem(workout: workouts[index]);
        },
      ),
    );
  }
}

class WorkoutHistoryItem extends StatelessWidget {
  final Workout workout;

  const WorkoutHistoryItem({required this.workout, Key? key}) : super(key: key);

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

  const WorkoutExerciseListPage({required this.workout, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
      ),
      body: ListView.builder(
        itemCount: workout.exercises.length,
        itemBuilder: (context, index) {
          return ExerciseListItem(exercise: workout.exercises[index]);
        },
      ),
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;

  const ExerciseListItem({required this.exercise, Key? key}) : super(key: key);

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

class CreateWorkoutPage extends StatelessWidget {
  const CreateWorkoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Create Workout Page'),
    );
  }
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

  const WeightChart({Key? key, required this.data}) : super(key: key);

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

  const WorkoutChart({Key? key, required this.data}) : super(key: key);

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
  const AllWorkoutsPage({Key? key}) : super(key: key);

  @override
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
    var request = http.Request(
      'GET',
      Uri.parse('https://api.api-ninjas.com/v1/exercises?muscle=$muscle&Key=LlrTjX8IV5FmNPhYjKqPIw==Do2Frt05e6fPgKdY'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        _workoutsData = response.stream.bytesToString();
      });
    } else {
      print(response.reasonPhrase);
      setState(() {
        _workoutsData = Future.error(response.reasonPhrase!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutti gli Allenamenti'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
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
                backgroundColor: Colors.blue, // Imposta il colore di sfondo del bottone su blu
                foregroundColor:  Colors.white, // Imposta il colore del testo su bianco
              ),
            child: Text('Cerca'),
          ),
          Expanded(
            child: Center(
              child: Container(
               color: Colors.lightBlue[100],
              child: FutureBuilder<String>(
                future: _workoutsData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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

