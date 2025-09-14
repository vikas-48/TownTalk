/*import 'package:/flutter/material.dart';
/*class ChatPage extends StatelessWidget {
  final String receiverEmail;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(receiverEmail),),
    );
  }

}*/
class ChatPage extends StatelessWidget {
  final String? receiverEmail; // Make it nullable
  const ChatPage({Key? key, this.receiverEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${receiverEmail ?? 'unknown'}')),
      body: Center(
        child: Text(
          receiverEmail != null
              ? 'Chatting with $receiverEmail'
              : 'No receiver specified.',
        ),
      ),
    );
  }
};*/
/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:towntalk/services/auth/auth_service.dart';
import 'package:towntalk/services/chat_services.dart';

class ChatPage extends StatelessWidget {
  final String? receiverEmail; 
  final String receiverID;// Nullable to handle cases without a receiver

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID
    });
final TextEditingController _messageController= TextEditingController();
//chat and auth services
final ChatServices _chatService = ChatServices();
final AuthService _authService=AuthService();
//send message
void sendMessage() async{
  //if there is something inside the textfield
  if(_messageController.text.isNotEmpty){
    //send the message
    await _chatService.sendMessage(receiverID, _messageController.text);
    //clear text controller
    _messageController.clear();
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail!)),
         body: Column(
          children: [
            // display all messages
            Expanded(
              child: _buildMessagesList(),
            ),

            //userr input
            _buildUserInput(),
          ],
         ),
      );
    
  }
  //build message list
  Widget _buildMessagesList(){
   String senderID = _authService.getCurrentUser()!.uid;
   return StreamBuilder(
    stream: _chatService.getMessages(receiverID, senderID), 
    builder: (context,snapshot){
 //errors
 if(snapshot.hasError){
  return Text("Error");
 }
 //loading
 if(snapshot.connectionState == ConnectionState.waiting){
  return const Text("Loading..");
 }
 //return list view
return ListView(
  children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
);
    },);
  }
  Widget _buildMessageItem(QueryDocumentSnapshot<Object?> doc){
    Map<String,dynamic> data =doc.data() as Map<String,dynamic>;
    return Text(data["message"]);
  }
  //build message input
  Widget _buildUserInput(){
    return Row(
      children: [
        Expanded(
          child:MyTextField(
            controller: _messageController,
            hintText: "Type a message",
            obscureText: false,
          )
          ),
//send button
IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward))
    ],);
  }
}*/
          // Send button
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting time
import 'package:towntalk/services/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    Key? key,
    required this.receiverEmail,
    required this.receiverID,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatService = ChatServices();

  final User? _currentUser = FirebaseAuth.instance.currentUser;

  // ScrollController to ensure that the chat view scrolls to the bottom
  final ScrollController _scrollController = ScrollController();

  // Send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty && _currentUser != null) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();
      // After sending a message, scroll to the bottom
      _scrollToBottom();
    }
  }

  // Scroll to the bottom of the chat
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          // Display messages
          Expanded(
            child: _buildMessagesList(),
          ),

          // User input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    if (_currentUser == null) {
      return Center(
        child: Text(
          "User not authenticated.",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    final senderID = _currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(
            child: Text(
              "No messages yet.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController, // Controller added for auto-scrolling
          reverse: true, // Ensures messages appear at the bottom
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(docs[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;

    final isCurrentUser = data["senderID"] == _currentUser?.uid;

    // Format timestamp
    final Timestamp timestamp = data["timestamp"] as Timestamp;
    final DateTime dateTime = timestamp.toDate();
    final timeString = DateFormat.jm().format(dateTime); // Example: "5:30 PM"

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isCurrentUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data["message"] ?? "",
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeString,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
