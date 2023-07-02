import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../../Models/messaging_room.dart';
import '../../Services/prefs.dart';
import '../Chat/chat.dart';

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({super.key});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  late IO.Socket socket;

  List<MessagingRoom> _messageRooms = [];

  String authToken = "";

  _connectToWebsocket() async {
    socket.connect();
    socket.onConnect((data) => print(data));
    socket.onConnectError((data) => print(data));
    _getAllRooms();
    socket.on('message', (data) => print(data));
    socket.on('room_created', (data) => {_getAllRooms()});
    socket.on(
        'receive_all_rooms',
        (data) => {
              setState(() {
                _messageRooms = [];
                for (var room in data) {
                  _messageRooms.add(MessagingRoom.fromJson(room));
                }
              })
            });
  }

  _getAllRooms() async {
    socket.emit(
        "request_all_rooms", {"userId": JwtDecoder.decode(authToken)["id"]});
  }

  _createSocket() async {
    final authToken = await Prefs.getString('authToken');
    setState(() {
      this.authToken = authToken!;
    });
    socket = io('https://izzup-api-production.up.railway.app/messaging',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .setExtraHeaders({'Authorization': 'Bearer $authToken'}) // optional
            .disableAutoConnect() // disable auto-connection
            .build());

    _connectToWebsocket();
  }

  _createChat() async {
    socket.emit("create_room", {
      {"createdBy": JwtDecoder.decode(authToken)["id"], "participant": 2}
    });
  }

  @override
  void initState() {
    super.initState();
    _createSocket();
  }

  @override
  void dispose() {
    super.dispose();
    socket.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Spacer(),
                      Text(
                        'Discussions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      _createChat();
                    },
                    child: const Text(
                      'Create Chat',
                      style: TextStyle(
                        color: Colors.black,
                        backgroundColor: Color(0xFFA5A5A5),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _messageRooms.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                    'assets/blank_profile_picture.png'),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _messageRooms[index].createdBy.id ==
                                          JwtDecoder.decode(authToken)["id"]
                                      ? Text(
                                          "${_messageRooms[index].participant.firstName} ${_messageRooms[index].participant.lastName}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          "${_messageRooms[index].createdBy.firstName} ${_messageRooms[index].createdBy.lastName}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  const Text(
                                    '2 hours ago',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                            room: _messageRooms[index],
                                            authToken: authToken,
                                            socket: socket)),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
