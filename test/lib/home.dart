 
import 'package:flutter/material.dart';
import 'package:towntalk/pages/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:towntalk/pages/login_page.dart';
import 'package:towntalk/messages1.dart';
// import 'house.dart'; // Replace with actual import paths for your app
import 'location.dart';
import 'messages.dart';
import 'profile.dart';
import 'post.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:firebase_auth/firebase_auth.dart';
 import 'package:intl/intl.dart';


String category='';
ValueNotifier<String?> selectedCategory = ValueNotifier(null);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int c = 0; // Current index for the bottom navigation bar
  bool isFabVisible = true; // Flag to control FAB visibility

  final pages = [
    DisplayTextsPage(),
    FieldChoosePage(),
    TextAdder(),
    Messages1(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          // Uncomment and add your logo asset path
          // child: Image.asset('assets/logo.png'),
        ),
        title: const Text('TownTalk'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            /*
                Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login page widget
    );

            */
            onPressed: () {
              // Handle the logout action
              //Navigator.pop(context);
              Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Replace with your login page widget
    );

            },
          ),
        ],
      ),
      
body: Center(child: pages[c]),

     bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: Colors.black26,
        currentIndex: c,
        onTap: (index) {
          setState(() {
            c = index;
            // Toggle FAB visibility based on the current tab
            isFabVisible = index == 0; // Only show the FAB on the Home tab
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "Location"),
           BottomNavigationBarItem(icon: Icon(Icons.add), label: "Post"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Message"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      
    );
  }
}

// Import the post page
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 

class DisplayTextsPage extends StatefulWidget {
  @override
  State<DisplayTextsPage> createState() => _DisplayTextsPageState();
}
String? category1;
class _DisplayTextsPageState extends State<DisplayTextsPage> {
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
        category1=userDoc['Locations'];
        category=category1.toString();
        
        // isLoading = false;
        
      });
    } catch (e) {
      print("Error fetching username: $e");
      setState(() {
        // isLoading = false;
      });
    }
  }
   

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedCategory,
      builder: (context, category, child) {
        
        if (category == null) {
          return Center(child: Text("No category selected."));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Texts for $category'),
          ),
          body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
               stream: _firestore.collection(category).orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var texts = snapshot.data!.docs;
             
             
               
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: texts.length,
                  itemBuilder: (context, index) {
                    var textData = texts[index];
            DateTime timestamp=textData['timestamp'].toDate();

                    return Card(
                       color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
               child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                  children: [
                    CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person_2),
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                    Text(
                          textData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                     Text(textData['text'],
                     style: const TextStyle(fontSize: 14),
                     ),
                     const SizedBox(height: 10,),
                      // subtitle: Text(textData['timestamp']?.toDate().toString() ?? 'No timestamp'),
                    Row(
                      children: [
                        Text(
                        timestamp != null
        ? DateFormat('dd MMM yy HH:mm').format(timestamp)
        : 'No timestamp',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(width: 25,),
                        userId != textData['uid'] // Check if user ID is not equal to receiver ID
      ? GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: textData["username"],
                  receiverID: textData['uid'],
                ),
              ),
            );
          },
          child: Icon(Icons.message),
        )
      : SizedBox(),  
                        
                        
                        const Spacer(),
                        Text(
                          "Posted to: $category",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
               )
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
        );
      },
    );
  }
}

