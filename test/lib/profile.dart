 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:towntalkkk/pages/home.dart';
String? username;
String? bio;
String? Locations;
String? email;
 String? userId;
class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
   // To store the username
  bool isLoading = true; // To manage the loading state

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    try {
      // Get the signed-in user's UID
       userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception("No user is signed in");
      }

      // Fetch the document for the signed-in user from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      // Extract the 'username' field
      setState(() {
      
         
        username = userDoc['name'];
        bio=userDoc['bio'];
        email=userDoc['email'];
        Locations=userDoc['locations'];
        isLoading = false;
        
      });
    } catch (e) {
      print("Error fetching username: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  
 
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          // Profile Header
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade400,
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                 Text(
                  username.toString(),
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
                const SizedBox(height: 5),
               Text(
                  email.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),

          // User Information Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.grey.shade100,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  <Widget>[
                    Text(
                      "User Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.black),
                      title: Text(
                        "Locations",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(Locations.toString()),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.black),
                      title: Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(email.toString()),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.black),
                      title: Text(
                        "Bio",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(bio.toString()),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation Icons

        ],
      ),
    );
  }
}
