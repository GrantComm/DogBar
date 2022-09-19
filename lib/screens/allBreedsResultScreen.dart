import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'breedResultScreen.dart';

class AllBreedsResultScreen extends StatefulWidget {
  List<dynamic> breedList;
  AllBreedsResultScreen({Key? key, required this.breedList}) : super(key: key);

  @override
  State<AllBreedsResultScreen> createState() => _AllBreedsResultScreenState();
}

class _AllBreedsResultScreenState extends State<AllBreedsResultScreen> {
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
            children: List.generate(widget.breedList.length, (index) {
              String breedName = widget.breedList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    List<dynamic> breedImages =
                        await sendBreedRequest(context, breedName);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BreedResultScreen(
                              breedName: breedName,
                              breedImages: breedImages,
                            )));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                        child: Text(
                      breedName[0].toUpperCase() + breedName.substring(1),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.teal[600]),
                    )),
                  ),
                ),
              );
            }),
          ),
        ));
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
                  'Use this page to view all of the available dog breeds. If you click on a specific container, you can view images of that breed!'),
            ));
  }

  String _localhost() {
    if (!kIsWeb && Platform.isAndroid)
      return 'http://10.0.2.2:3011';
    else
      return 'http://localhost:3011';
  }

  // Send a request to the server to get the images of a specific breed.
  Future<List<dynamic>> sendBreedRequest(
      BuildContext context, String type) async {
    final url = Uri.parse(_localhost() + '/breed:' + type);
    Response response = await get(url);
    var breeImages = parseResponseList(response.body);
    print(breeImages);
    return breeImages;
  }

  // Parse the response from the server.
  List<dynamic> parseResponseList(String response) {
    var parsed = jsonDecode(response);
    return parsed['message'];
  }
}
