import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../widgets/joke_card.dart';
import 'joke_type_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<String>> jokeTypes;

  @override
  void initState() {
    super.initState();
    jokeTypes = ApiService.getJokeTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke Types'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.pushNamed(context, '/random-joke');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: jokeTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final types = snapshot.data!;
            return ListView.builder(
              itemCount: types.length,
              itemBuilder: (context, index) {
                return JokeCard(
                  type: types[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JokeTypeScreen(type: types[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}