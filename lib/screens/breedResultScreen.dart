import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'breedResultScreen.dart';

class BreedResultScreen extends StatefulWidget {
  String breedName;
  List<dynamic> breedImages;
  BreedResultScreen(
      {Key? key, required this.breedName, required this.breedImages})
      : super(key: key);

  @override
  State<BreedResultScreen> createState() => _BreedResultScreenState();
}

class _BreedResultScreenState extends State<BreedResultScreen> {
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
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    widget.breedImages.isEmpty
                        ? 'No Images Found!'
                        : widget.breedName[0].toUpperCase() +
                            widget.breedName.substring(1),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.teal[600]),
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                  children: List.generate(widget.breedImages.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.network(
                            widget.breedImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
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
                  'Use this page to view images of the selected breed. If the breed is not found, no images will be displayed.'),
            ));
  }
}
