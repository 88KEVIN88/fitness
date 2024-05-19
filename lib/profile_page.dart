import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showUserData = false;
  List<WeightData> weightData = [];
  List<WorkoutData> workoutData = [];
  UserData userData = UserData(name: '', age: 0, email: '');

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController workoutDayController = TextEditingController();
  final TextEditingController workoutCountController = TextEditingController();

  void _showUserModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Inserisci Dati Utente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(
                  labelText: 'Età',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  userData = UserData(
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    email: emailController.text,
                  );
                });
                nameController.clear();
                ageController.clear();
                emailController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Salva'),
            ),
          ],
        );
      },
    );
  }

  void _showWeightModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aggiungi Misurazione'),
          content: TextField(
            controller: weightController,
            decoration: const InputDecoration(
              labelText: 'Peso',
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  weightData.add(WeightData(
                      date: DateTime.now(),
                      weight: double.parse(weightController.text)));
                });
                weightController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Salva'),
            ),
          ],
        );
      },
    );
  }

  void _showWorkoutModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aggiungi Allenamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: workoutDayController,
                decoration: const InputDecoration(
                  labelText: 'Giorno della settimana (es. Lun)',
                ),
              ),
              TextField(
                controller: workoutCountController,
                decoration: const InputDecoration(
                  labelText: 'Numero di allenamenti',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  workoutData.add(WorkoutData(
                    day: workoutDayController.text,
                    count: int.parse(workoutCountController.text),
                  ));
                });
                workoutDayController.clear();
                workoutCountController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Salva'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
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
                    userData.name.isEmpty ? 'Modifica Profilo' : userData.name,
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
            ElevatedButton(
              onPressed: _showUserModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Modifica Profilo',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
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
              onPressed: _showWeightModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Aggiungi Misurazione',
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
            ElevatedButton(
              onPressed: _showWorkoutModal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Aggiungi Allenamento',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 200,
              child: WorkoutChart(data: workoutData),
            ),
          ],
        ),
      ),
    );
  }
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

class UserData {
  final String name;
  final int age;
  final String email;

  UserData({required this.name, required this.age, required this.email});
}
