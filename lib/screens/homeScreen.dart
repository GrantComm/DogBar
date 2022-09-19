import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'resultScreen.dart';
import 'allBreedsResultScreen.dart';
import 'dart:convert';
import 'breedResultScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.teal[600],
        title: Column(
          children: const [
            Text('View the Different Dog Breeds!',
                style: TextStyle(fontSize: 30)),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 5.0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    controller: _search,
                    onSubmitted: (value) async {
                      String breedName = value;
                      List<dynamic> breedImages = await sendBreedRequest(
                          context, breedName.toLowerCase());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BreedResultScreen(
                            breedName: breedName,
                            breedImages: breedImages,
                          ),
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                  ),
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
                      child: Text('Show a Random Breed'),
                      onPressed: () {
                        sendRandomBreedRequest(context);
                      },
                    ),
                  ),
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
                      child: Text('Show all Breeds'),
                      onPressed: () {
                        sendAllBreedRequest(context);
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
              content: Text(
                  'Use this page to search for a dog breed by name, discover a random breed, or show all breeds.'),
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
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ResultScreen(
              randomImageUrl: imageUrl,
            )));
  }

  // Sends a request to the server to get all the breeds.
  void sendAllBreedRequest(BuildContext context) async {
    final url = Uri.parse(_localhost() + '/all');
    Response response = await get(url);
    List<dynamic> allBreeds = parseResponseList(response.body);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AllBreedsResultScreen(
              breedList: allBreeds,
            )));
  }

  // Return the random image url.
  String parseResponseString(String response) {
    var parsed = jsonDecode(response);
    return parsed['message'];
  }

  // Return a list of all breeds.
  List<dynamic> parseResponseList(String response) {
    var parsed = jsonDecode(response);
    Map map = Map.from(parsed['message']);
    return map.keys.toList()..sort();
  }

  // Send an HTTP request to the server to get the images for the breed and return the list of images.
  Future<List<dynamic>> sendBreedRequest(
      BuildContext context, String type) async {
    final url = Uri.parse(_localhost() + '/breed:' + type);
    Response response = await get(url);
    var breedImages = parseBreedResponseList(response.body);
    return breedImages;
  }

  // Return a list of the breed images.
  List<dynamic> parseBreedResponseList(String response) {
    var parsed = jsonDecode(response);
    if (parsed['message'].runtimeType == String) {
      return [];
    }
    return parsed['message'];
  }
}
