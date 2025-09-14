/*import 'package:flutter/material.dart';

class post extends StatefulWidget {
// final String initialText;

//   post({required this.initialText});
  @override
  State<post> createState() => _postState();
}

class _postState extends State<post> {
   String _inputText = '';
  @override
  //  void initState() {
  //   super.initState();
  //   if (widget.initialText != null) {
  //     _inputText = widget.initialText;
  //   }
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TOWNTALK"),
      ),
       body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Positioned(
            // top: 0,
            //   child:
              Container( height: 150.0, // Set a desired height for the text field container
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    _inputText = text;
                  });
                },
                maxLines: null, // Allows unlimited lines
                minLines: null, // Starts with a single line
                expands: true, // Expands to fill the container
                decoration: InputDecoration(
                  hintText: 'WHAT\'S HAPPENING OUT THERE',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0), 
                ),
              ),
              
              ),
              
              
          SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    // Define the action to be taken when the button is pressed
                    // print('Post button pressed: $_inputText');
                  },
                   label: Text('Post'), // Text label
                   icon: Icon(Icons.send), // Icon to be displayed
                 
                  
                ),
              ],
            ),
            Text(
                    'you are posting to: Jammikunta', // Your custom text
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          
          ]

    )));
    
  }
}*/
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:towntalk/profile.dart';
 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(TextAdder());
}

class TextAdder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      home: TextAdderScreen(),
    );
  }
}

class TextAdderScreen extends StatefulWidget {
  @override
  _TextAdderScreenState createState() => _TextAdderScreenState();
}

class _TextAdderScreenState extends State<TextAdderScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        
        // isLoading = false;
        
      });
    } catch (e) {
      print("Error fetching username: $e");
      setState(() {
        // isLoading = false;
      });
    }
  }

  // Add text to Firebase under the selected category
  Future<void> _addText() async {
    final String text = _textController.text;
    final String category = _categoryController.text.toUpperCase();
  

    if (text.isNotEmpty && category.isNotEmpty) {
      // Add the text as a document to the appropriate category (collection)
      await _firestore.collection(category).add({
      
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'username':username.toString(),
        'uid':userId.toString(),
      });
      final metadataRef = _firestore.collection('metadata').doc('collections');

      await metadataRef.get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          List<dynamic> collectionNames = documentSnapshot['names'];
          
          if (!collectionNames.contains(category)) {
            // If the category doesn't exist in the names array, add it
            await metadataRef.update({
              'names': FieldValue.arrayUnion([category])
            });
          }
        } else {
          // If the document doesn't exist, create it with the new category
          await metadataRef.set({
            'names': [category]
          });
        }
      });

      // Clear the input fields after adding
      _textController.clear();
      _categoryController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Text added to $category')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             TextAreaWidget( _textController),
            SizedBox(height: 10),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Enter Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addText,
              
              child: Text('Add Text to Location'),
            ),
          ],
        ),
      ),
    );
  }
}
Widget TextAreaWidget( TextEditingController controller) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            
            maxLength: 200,
            maxLines: null,
            expands: true,
            controller: controller,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xffA7A7A7),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              labelText: ("What's Happening Out there"),
            ),
          ),
        ),
      ],
    ),
  );
}
