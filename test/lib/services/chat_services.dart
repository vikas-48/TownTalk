import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:towntalk/models/messages2.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send a message
  Future<void> sendMessage(String receiverID, String message) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not authenticated");

    final String senderID = currentUser.uid;
    final String senderEmail = currentUser.email ?? 'Unknown';
    final Timestamp timestamp = Timestamp.now();

    Messages2 newMessage = Messages2(
      senderID: senderID,
      senderEmail: senderEmail,
      message: message,
      receiverID: receiverID,
      timestamp: timestamp,
    );

    // Chat room ID based on the two user IDs
    List<String> ids = [senderID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Add the message to Firestore
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Retrieve messages for the chat room
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
