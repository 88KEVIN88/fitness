
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