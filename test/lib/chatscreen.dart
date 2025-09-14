import 'package:flutter/material.dart';


class ChatScreen extends StatefulWidget {
  final String userName;

  ChatScreen({required this.userName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List<Message> _messages = []; // List to store chat messages

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(String messageText) {
    setState(() {
      _messages.add(Message(
        message: messageText,
        time: DateTime.now(),
        isUser: true,
      ));
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CircleAvatar(
              child: Icon(Icons.person),
            ),
            SizedBox(width: 10),
            Text(
              widget.userName,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  message: message.message,
                  time: message.time,
                  isUser: message.isUser,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String messageText = _messageController.text.trim();
                    if (messageText.isNotEmpty) {
                      _sendMessage(messageText);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class Message {
  final String message;
  final DateTime time;
  final bool isUser; // Indicates if the message is sent by the user

  Message({required this.message, required this.time, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final String message;
  final DateTime time;
  final bool isUser;

  ChatBubble({required this.message, required this.time, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isUser ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: EdgeInsets.all(12.0),
            child: Text(
              message,
              style: TextStyle(color: isUser ? Colors.white : Colors.black),
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            "${time.hour}:${time.minute}",
            style: TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}