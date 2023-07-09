import '../data/constant_variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class JokeContainer extends StatefulWidget {
  final double jokeNumber;

  const JokeContainer(this.jokeNumber, {super.key});

  @override
  State<JokeContainer> createState() => _JokeContainerState();
}

class _JokeContainerState extends State<JokeContainer> {
  late Future futureJoke;

  Future<String> fetchJoke() async {
    final response = await http.get(Uri.parse("https://icanhazdadjoke.com/"),
        headers: {"Accept": "text/plain"});

    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      throw Exception("Failed to load joke.");
    }
  }

  @override
  void initState() {
    super.initState();
    futureJoke = fetchJoke();
  }

  @override
  void didUpdateWidget(covariant JokeContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.jokeNumber < widget.jokeNumber) {
      futureJoke = fetchJoke();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureJoke,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: MediaQuery.of(context).size.width - 84,
              child: Text(
                snapshot.data
                    .toString()
                    .replaceAll(String.fromCharCodes([226, 128, 153]), "'"),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    letterSpacing: -0.02,
                    fontFamily: fontFamily,
                    fontSize: 16.5,
                    color: Color.fromARGB(120, 0, 0, 0)),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(
              "Slow internet's secret agenda: stealing our joy, one missed joke at a time.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: fontFamily,
                  color: Theme.of(context).colorScheme.error),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: themeColor,
            ),
          );
        });
  }
}
