import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:izzup/Models/classy_loader.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../Models/job_offer_requests.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../Models/messaging_room.dart';
import '../../Models/user.dart';
import '../../Services/api.dart';
import '../../Services/colors.dart';
import '../../Services/prefs.dart';
import '../Chat/chat.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({super.key, required this.extraRequest, required this.indexOfJobOffer, required this.jobOffer});

  final List<JobRequests> extraRequest;
  final int indexOfJobOffer;
  final JobOfferRequest jobOffer;

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  List<JobRequests> requests = [];
  late io.Socket socket;
  String? authToken;
  bool _isLoading = true;
  UserRequest? lastUserClicked;

  List<MessagingRoom> _messageRooms = [];

  _getAllRooms() {
    socket.emit("request_all_rooms", {
      "userId": JwtDecoder.decode(authToken!)["id"]
    });
  }

  _createChat(int participantId) async {
    socket.emit("create_room", {{
      "createdBy": JwtDecoder.decode(authToken!)["id"],
      "participant": participantId
    }});
  }


  _connectToWebsocket() async {
    socket.connect();
    socket.onConnect((data) {
      if (kDebugMode) print(data);
    });
    socket.onConnectError((data) {
      if (kDebugMode) print(data);
    });
    _getAllRooms();
    socket.on('message', (data) {
      if (kDebugMode) print(data);
    });
    socket.on('room_created', (data) {
      _getAllRooms();
    });
    socket.on('receive_all_rooms', (data) => {
      setState(() {
        _isLoading = false;
        _messageRooms = [];
        for (var room in data) {
          _messageRooms.add(MessagingRoom.fromJson(room));
        }
        if (lastUserClicked?.id != null) {
          for (var room in _messageRooms) {
            if (room.participant.id == lastUserClicked?.id) {

              context.push(ChatPage(
                room: room,
                authToken: authToken!,
                socket: socket,
                name: lastUserClicked!.firstName,
                photoUrl: lastUserClicked!.photo,
              ));
            }
          }
        }
      })
    });
  }

  _createSocket() async {
    final authToken = await Globals.authToken();
    setState(() {
      this.authToken = authToken!;
    });
    socket = io.io(Api.getUriString('messaging'),
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .setExtraHeaders({'Authorization': 'Bearer $authToken'}) // optional
            .disableAutoConnect()  // disable auto-connection
            .build()
    );

    _connectToWebsocket();
  }

  MessagingRoom? _checkIfRoomAllreadyCreated(int participantId) {
    for (var room in _messageRooms) {
      if (room.participant.id == participantId) {
        return room;
      }
    }
    return null;
  }

  Future<bool> _acceptRequest(int requestId) async {
    final validation = await Api.acceptRequest(requestId);
    if(validation) {
      setState(() {
        for (var request in requests) {
          if (request.id == requestId) {
            request.status = "ACCEPTED";
          }
        }
      });
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _createSocket();
    setState(() {
      requests = widget.extraRequest;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    socket.dispose();
  }

  bool _jobRequestOngoing(int index) {
    print("Checking if job request is ongoing");
    print("Name: ${widget.jobOffer.jobTitle}");
    print("Now: ${DateTime.parse(DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()))}");
    print("Starting date: ${widget.jobOffer.startingDate}");
    print("Ending date: ${widget.jobOffer.startingDate.add(Duration(hours: widget.jobOffer.workingHours))}");
    var now = DateTime.parse(DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()));
    return requests[index].status == "ACCEPTED" && widget.jobOffer.startingDate.isBefore(now) && widget.jobOffer.startingDate.add(Duration(hours: widget.jobOffer.workingHours)).isAfter(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00B096),
        title: const Text('Request List'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200], // Background color for the card
            child: requests.isEmpty
                ?
            const Center(
                child: Text(
                  "No requests yet 😢",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                )
            )
                : RefreshIndicator(
              onRefresh: () async {
                final jobOffers = await Api.getMyJobOffers();
                if (jobOffers != null) {
                  setState(() {
                    requests = jobOffers[widget.indexOfJobOffer].requests;
                  });
                }
              },
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _jobRequestOngoing(index) ? Colors.blueGrey : Colors.transparent,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (requests[index].status == "ACCEPTED") {
                                lastUserClicked = requests[index].extra.user;
                                if (lastUserClicked?.id != null) {
                                  MessagingRoom? room = _checkIfRoomAllreadyCreated(lastUserClicked!.id!);
                                  if (room != null) {
                                    context.push(ChatPage(
                                      room : room,
                                      authToken: authToken!,
                                      socket: socket,
                                      name: requests[index].extra.user.firstName,
                                      photoUrl: requests[index].extra.user.photo,
                                    ));
                                  } else {
                                    setState(() => _isLoading = true);
                                    _createChat(lastUserClicked!.id!);
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                color: Color(0xFF00B096),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    Color(0xFF00B096),
                                    Color(0xFF008073),
                                  ],
                                ),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: requests[index].extra.user.photo != null
                                        ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          requests[index].extra.user.photo!
                                      ),
                                    )
                                        : const CircleAvatar(backgroundImage: AssetImage("assets/blank_profile_picture.png")),
                                    title: Text(
                                        '${requests[index].extra.user.firstName} ${requests[index].extra.user.lastName}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20
                                        )
                                    ),
                                    subtitle: Text(
                                      requests[index].extra.address,
                                      style: const TextStyle(
                                          color: Colors.white60
                                      ),
                                    ),
                                    trailing: requests[index].status == "PENDING"
                                        ? const Icon(
                                      Icons.timer_outlined,
                                      color: Colors.white,
                                    )
                                        : requests[index].status == "ACCEPTED"
                                        ? const Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      color: Colors.white,
                                    )
                                        : const Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (requests[index].status == "PENDING")
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(Icons.message, color: Colors.white),
                                          onPressed: () {
                                            lastUserClicked = requests[index].extra.user;
                                            if (lastUserClicked?.id != null) {
                                              MessagingRoom? room = _checkIfRoomAllreadyCreated(lastUserClicked!.id!);
                                              if (room != null) {
                                                context.push(ChatPage(
                                                  room : room,
                                                  authToken: authToken!,
                                                  socket: socket,
                                                  name: requests[index].extra.user.firstName,
                                                  photoUrl: requests[index].extra.user.photo,
                                                ));
                                              } else {
                                                setState(() => _isLoading = true);
                                                _createChat(lastUserClicked!.id!);
                                              }
                                            }
                                          },
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {},
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.cancel_sharp, color: Colors.red,),
                                                SizedBox(width: 8),
                                                Text('Decline', style: TextStyle(color: Colors.red)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        TextButton(
                                          onPressed: () {
                                            final requestId = requests[index].id;
                                            if(requestId != null) {
                                              _acceptRequest(requestId);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.check, color: AppColors.accent,),
                                                SizedBox(width: 8),
                                                Text('Accept', style: TextStyle(color: AppColors.accent)),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (_jobRequestOngoing(index))
                          GestureDetector(
                              onTap: () {
                                if (requests[index].id != null) Api.confirmWork(requests[index].id!);
                              },
                              child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                            "End job",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14
                                            )
                                        ),
                                      ),
                                    ],
                                  )
                              )
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          if (_isLoading) const ClassyLoader()
        ],
      ),
    );
  }
}
