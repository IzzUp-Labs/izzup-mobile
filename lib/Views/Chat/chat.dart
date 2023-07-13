import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:izzup/Models/messaging_room.dart';
import 'package:izzup/Services/colors.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Models/message.dart';

class ChatPage extends StatefulWidget {
  final MessagingRoom room;
  final String authToken;
  final io.Socket socket;
  final String? photoUrl;
  final String name;

  const ChatPage(
  {super.key,
  required this.room,
  required this.authToken,
  required this.socket,
  this.photoUrl,
  required this.name});



  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textController = TextEditingController();

  int authTokenId = 0;

  final List<Message> _messages = [];

  bool isTyping = false;

  _joinRoom() async {
    widget.socket.emit("join_room", {"roomId": widget.room.id});
  }

  _sendMessage() async {
    widget.socket.emit("send_message", {
      "roomId": widget.room.id,
      "authorId": authTokenId,
      "content": textController.text
    });
  }

  _onTyping() async {
    widget.socket.emit("typing",
        {"roomId": widget.room.id, "authorId": authTokenId, "isTyping": true});
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    int authTokenId = JwtDecoder.decode(widget.authToken)["id"];
    //User user = User.basic;
    setState(() {
      this.authTokenId = authTokenId;
    });
    _joinRoom();
    widget.socket.on(
        'receive_all_room_messages',
            (data) => {
          setState(() {
            _messages.clear();
            for (var message in data) {
              _messages.add(Message.fromJson(message));
            }
          })
        });
    widget.socket.on(
        'joined_room',
            (data) => {
          widget.socket
              .emit("request_all_room_messages", {"roomId": widget.room.id})
        });
    widget.socket.on(
        'receive_message',
            (data) => {
          setState(() {
            _messages.add(Message.fromJson(data));
          })
        });
    /*widget.socket.on("typing", (data) => {
      user = User.fromJson(data["user"]),
      setState(() {
        if(user.id != authTokenId) {
          isTyping = data["isTyping"];
        }
      })
    });*/
  }

  @override
  void dispose() {
    super.dispose();
    widget.socket.emit("leave_room", {"roomId": widget.room.id});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        title: Row(
          children: [
            widget.photoUrl != null
                ? CircleAvatar(backgroundImage: NetworkImage(widget.photoUrl!))
                : const SizedBox(width: 35, height: 35, child: CircleAvatar(backgroundImage: AssetImage("assets/blank_profile_picture.png"))),
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: GroupedListView<Message, DateTime>(
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  padding: const EdgeInsets.all(10),
                  elements: _messages,
                  groupBy: (message) => DateTime(2022),
                  groupHeaderBuilder: (Message message) => const SizedBox(),
                  itemBuilder: (context, Message message) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: message.author.id != authTokenId
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: message.author.id != authTokenId
                                  ? Colors.grey[300]
                                  : AppColors.accent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Text(
                                overflow: TextOverflow.visible,
                                message.content,
                                maxLines: 4,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: message.author.id == authTokenId ? Colors.white : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                        isTyping
                            ? Text(AppLocalizations.of(context)?.chat_typing ?? "Typing...")
                            : const SizedBox(width: 0, height: 0),
                      ],
                    ),
                  ),
                )
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300],
                      ),
                      child: TextField(
                        controller: textController,
                        cursorColor: AppColors.accent,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)?.chat_typeAMessage ?? 'Type a message',
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        onSubmitted: (value) {
                          _sendMessage();
                          textController.clear();
                        },
                      )),
                ),
                IconButton(
                  onPressed: () {
                    if (textController.text.trim().isNotEmpty) {
                      _sendMessage();
                    }
                    textController.clear();
                  },
                  icon: const Icon(Icons.send, color: AppColors.accent),
                )
              ],
            )
          ],
        ),
      ));
}
