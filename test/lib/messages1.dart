/*import 'package:towntalk/chatscreen.dart';
import 'package:towntalk/pages/chat_page.dart';
import 'package:towntalk/services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:towntalk/usertile.dart';
import '../services/auth/auth_service.dart';
class Messages1 {
  final ChatServices _chatService=ChatServices();
  final AuthService _authService= AuthService();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),
      body: _buildUserList(),
    );
  }
  //build a list of users except for current logged in user
  Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUsersStream(), 
      builder: (context,snapshot){
        //error
        if(snapshot.hasError)
        {
          return const Text("Error");
        }
        //loading..
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading..");
        }
        //return list view
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData,context)).toList(),
        );
      }
      );
  }
  c
}*/
import 'package:flutter/material.dart';
import 'package:towntalk/services/chat_services.dart';
import 'package:towntalk/usertile.dart';
import 'package:towntalk/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages1 extends StatelessWidget {
  final ChatServices _chatService = ChatServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getUsersList() async {
    // Get the current user's UID
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return []; // No current user, return empty list
    }

    // Get all users from Firestore (excluding the current user)
    QuerySnapshot usersSnapshot = await _firestore.collection('Users').get();
    List<Map<String, dynamic>> users = [];

    for (var doc in usersSnapshot.docs) {
      if (doc.id != currentUser.uid) {
        users.add({
          'name': doc['name'],
          'email': doc['email'],
          'uid': doc.id,
        });
      }
    }

    return users;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUsersList(), // Fetch users excluding the current one
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading users."));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found."));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index];
              return _buildUserListItem(userData, context);
            },
          );
        },
      ),
    );
  }

  // This method builds the list item for each user in the list
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    return Usertile(
      text: userData["name"], // Display the name instead of email
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(receiverEmail: userData["name"], receiverID: userData["uid"],), // Send the email or name to ChatPage
          ),
        );
      },
    );
  }
}
