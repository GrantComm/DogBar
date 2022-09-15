import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
              padding: EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5.0,
                  primary: Colors.lime[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Show Me a Random Breed'),
                onPressed: () {
                  serverCall();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text('Help'),
              content: Text(
                  'Use this page to search for a dog breed by name or discover a random breed.'),
            ));
  }

  void serverCall() {
    WebSocketChannel? channel;
    try {
      channel = WebSocketChannel.connect(Uri.parse('ws://localhost:3011'));
      print(channel.toString());
    } catch (e) {
      print(e);
    }
    print("SUCCESS");
  }
}
