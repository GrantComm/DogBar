import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  String randomImageUrl;
  ResultScreen({Key? key, required this.randomImageUrl}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModal(context);
        },
        backgroundColor: Colors.lime[900],
        child: const Icon(Icons.help),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal[600]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
              child: RichText(
                text: TextSpan(
                  text: 'Dog',
                  style: TextStyle(
                    fontFamily: 'LuckiestGuy',
                    fontSize: 60,
                    color: Colors.lime[900],
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Bar',
                      style: TextStyle(
                        fontFamily: 'LuckiestGuy',
                        fontSize: 60,
                        color: Colors.teal[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(getBreedFromResponseUrl(widget.randomImageUrl),
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5.0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Image.network(widget.randomImageUrl),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        primary: Colors.lime[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Show another Random Breed'),
                      onPressed: () {
                        sendRandomBreedRequest(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show a modal with information about the screen.
  void showModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text('Help'),
              content: Text('Use this page to view random dog breeds.'),
            ));
  }

  String _localhost() {
    if (!kIsWeb && Platform.isAndroid)
      return 'http://10.0.2.2:3011';
    else
      return 'http://localhost:3011';
  }

  // Sends a request to the server to get a random breed.
  void sendRandomBreedRequest(BuildContext context) async {
    final url = Uri.parse(_localhost() + '/random');
    Response response = await get(url);
    String imageUrl = parseResponseString(response.body);
    getBreedFromResponseUrl(imageUrl);
    setState(() {
      widget.randomImageUrl = imageUrl;
    });
  }

  // Parses the response string from the server.
  String parseResponseString(String response) {
    var parsed = jsonDecode(response);
    return parsed['message'];
  }

  // Gets the breed from the response url.
  String getBreedFromResponseUrl(String responseUrl) {
    String breed = responseUrl.substring(30);
    breed = breed.substring(0, breed.length - 4);
    breed = breed.substring(0, breed.indexOf('/'));
    if (breed.contains('-')) {
      int index = breed.indexOf('-');
      return breed[0].toUpperCase() +
          breed.substring(1, index) +
          '-' +
          breed.substring(index + 1, index + 2).toUpperCase() +
          breed.substring(index + 2);
    }
    return breed[0].toUpperCase() + breed.substring(1);
  }
}
