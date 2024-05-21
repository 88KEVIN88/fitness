import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        title: const Text('Tutti gli esercizi'),
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
