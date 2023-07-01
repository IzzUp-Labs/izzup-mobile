import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestListPage extends StatefulWidget {
  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  // List of requests
  List<String> requests = ['Request 1', 'Request 2', 'Request 3', 'Request 4', 'Request 5', 'Request 6', 'Request 7', 'Request 8', 'Request 9', 'Request 10'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00B096),
        title: const Text('Request List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              // Navigate to messaging page
              print("Messaging page");
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Background color for the card
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.album),
                    title: Text(requests[index]),
                    subtitle: Text('${requests[index]} description'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        onPressed: () {/* ... */},
                        child: const Text('Decline'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF00B096),
                        ),
                        onPressed: () {/* ... */},
                        child: const Text('Accept'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}