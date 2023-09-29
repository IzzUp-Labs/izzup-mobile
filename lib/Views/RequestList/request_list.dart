import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:izzup/Models/classy_loader.dart';
import 'package:izzup/Models/globals.dart';
import 'package:izzup/Services/navigation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../Models/job_offer_requests.dart';
import '../../Models/messaging_room.dart';
import '../../Services/api.dart';
import '../../Services/colors.dart';
import '../../Services/modals.dart';
import '../Chat/chat.dart';
import '../Profile/profile_recap.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage(
      {super.key,
        required this.extraRequest,
        required this.indexOfJobOffer,
        required this.jobOffer});

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
    socket.emit(
        "request_all_rooms", {"userId": JwtDecoder.decode(authToken!)["id"]});
  }

  _createChat(String participantId) async {
    socket.emit("create_room", {
      {
        "createdBy": JwtDecoder.decode(authToken!)["id"],
        "participant": participantId
      }
    });
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
    socket.on(
        'receive_all_rooms',
            (data) => {
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
    socket = io.io(
        Api.getUriString('messaging'),
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .setExtraHeaders({'Authorization': 'Bearer $authToken'}) // optional
            .disableAutoConnect() // disable auto-connection
            .build());

    _connectToWebsocket();
  }

  MessagingRoom? _checkIfRoomAllreadyCreated(String participantId) {
    for (var room in _messageRooms) {
      if (room.participant.id == participantId) {
        return room;
      }
    }
    return null;
  }

  Future<bool> _acceptRequest(String requestId) async {
    final validation = await Api.acceptRequest(requestId);
    if (validation) {
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
    var now = DateTime.parse(
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()));
    return requests[index].status == "ACCEPTED" &&
        widget.jobOffer.startingDate.isBefore(now) &&
        widget.jobOffer.startingDate
            .add(Duration(hours: widget.jobOffer.workingHours))
            .isAfter(now);
  }

  IconData getIconFromStatus(JobRequestStatus status) {
    switch (status) {
      case JobRequestStatus.pending:
        return Icons.timer_outlined;
      case JobRequestStatus.accepted:
        return Icons.check_circle;
      case JobRequestStatus.rejected:
        return Icons.cancel_outlined;
      case JobRequestStatus.waitingForVerification:
        return Icons.ac_unit;
      case JobRequestStatus.finished:
        return Icons.done_all_outlined;
      default:
        return Icons.timer_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00B096),
        title:
        Text(AppLocalizations.of(context)?.requestList_title ?? 'Requests'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200], // Background color for the card
            child: requests.isEmpty
                ? Center(
                child: Text(
                  AppLocalizations.of(context)?.requestList_noRequests ??
                      "No requests yet 😢",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ))
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
                            color: _jobRequestOngoing(index)
                                ? Colors.blueGrey
                                : Colors.transparent,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (requests[index].status == "ACCEPTED") {
                                lastUserClicked =
                                    requests[index].extra.user;
                                if (lastUserClicked?.id != null) {
                                  MessagingRoom? room =
                                  _checkIfRoomAllreadyCreated(
                                      lastUserClicked!.id!);
                                  if (room != null) {
                                    context.push(ChatPage(
                                      room: room,
                                      authToken: authToken!,
                                      socket: socket,
                                      name: requests[index]
                                          .extra
                                          .user
                                          .firstName,
                                      photoUrl: requests[index]
                                          .extra
                                          .user
                                          .photo,
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
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
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
                                    leading: requests[index]
                                        .extra
                                        .user
                                        .photo !=
                                        null
                                        ? GestureDetector(
                                        onTap: () {
                                          context.push(ProfileRecapScreen(fromProfile: false, id: requests[index].extra.user.id!));
                                        },
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              requests[index]
                                                  .extra
                                                  .user
                                                  .photo!),
                                        ))
                                        : GestureDetector(
                                        onTap: () {
                                          context.push(ProfileRecapScreen(fromProfile: false, id: requests[index].extra.user.id!));
                                        },
                                        child: const CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/blank_profile_picture.png"))),
                                    title: Text(
                                        '${requests[index].extra.user.firstName} ${requests[index].extra.user.lastName}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    subtitle: Text(
                                      requests[index].extra.address,
                                      style: const TextStyle(
                                          color: Colors.white60),
                                    ),
                                    trailing: Icon(
                                      getIconFromStatus(
                                          JobRequestStatus.fromString(
                                              requests[index].status)),
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (requests[index].status == "PENDING")
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: <Widget>[
                                        IconButton(
                                          icon: const Icon(Icons.message,
                                              color: Colors.white),
                                          onPressed: () {
                                            lastUserClicked =
                                                requests[index]
                                                    .extra
                                                    .user;
                                            if (lastUserClicked?.id !=
                                                null) {
                                              MessagingRoom? room =
                                              _checkIfRoomAllreadyCreated(
                                                  lastUserClicked!
                                                      .id!);
                                              if (room != null) {
                                                context.push(ChatPage(
                                                  room: room,
                                                  authToken: authToken!,
                                                  socket: socket,
                                                  name: requests[index]
                                                      .extra
                                                      .user
                                                      .firstName,
                                                  photoUrl:
                                                  requests[index]
                                                      .extra
                                                      .user
                                                      .photo,
                                                ));
                                              } else {
                                                setState(() =>
                                                _isLoading = true);
                                                _createChat(
                                                    lastUserClicked!.id!);
                                              }
                                            }
                                          },
                                        ),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () {},
                                          child: Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 15,
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  20),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.cancel_sharp,
                                                  color: Colors.red,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                    AppLocalizations.of(
                                                        context)
                                                        ?.requestList_decline ??
                                                        'Decline',
                                                    style:
                                                    const TextStyle(
                                                        color: Colors
                                                            .red)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        TextButton(
                                          onPressed: () {
                                            final requestId =
                                                requests[index].id;
                                            if (requestId != null) {
                                              _acceptRequest(requestId);
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 15,
                                                vertical: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  20),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check,
                                                  color: AppColors.accent,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                    AppLocalizations.of(
                                                        context)
                                                        ?.requestList_accept ??
                                                        'Accept',
                                                    style: const TextStyle(
                                                        color: AppColors
                                                            .accent)),
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
                              onTap: () async {
                                if (requests[index].id != null && requests[index].extra.user.id != null) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await Api.confirmWork(requests[index].id!);
                                  await Modals.showJobEndModalEmployer(
                                      requests[index].id!, requests[index].extra.user.id!);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                              child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(20)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.all(8.0),
                                        child: Text(
                                            AppLocalizations.of(context)
                                                ?.requestList_endJob ??
                                                "End job",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ))),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          if (_isLoading) ClassyLoader(loaderSize: MediaQuery.of(context).size.height)
        ],
      ),
    );
  }
}
