
import 'package:flutter/material.dart';
import "all_workouts_page.dart";
import 'create_workout_page.dart';
import 'profile_page.dart';
import 'workout_history_page.dart';


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

