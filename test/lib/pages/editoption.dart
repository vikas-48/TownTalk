import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:towntalk/profile.dart';
 class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown and Text Fields',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DropdownAndTextFields(), // Ensures Scaffold is used
    );
  }
}
 class HomePage11 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown and Text Fields'),
      ),
      body: Center(
        child: DropdownAndTextFields(),
      ),
    );
  }
}
final _bioController = TextEditingController();
    final _locController = TextEditingController();
    final _emailController = TextEditingController();

class DropdownAndTextFields extends StatefulWidget {
  @override
  _DropdownAndTextFieldsState createState() => _DropdownAndTextFieldsState();
}
String? _selectedOption;
Future<void> _submit() async{
  String bio = _bioController.text.trim();
    String location = _selectedOption.toString();
    String email = _emailController.text.trim();

try{
    await FirebaseFirestore.instance.collection('Users').doc(userId).update({
      if(email.isNotEmpty)
        'email': email,
        if (bio.isNotEmpty)
        'bio':bio,
        if(_selectedOption.toString().isNotEmpty)
        'locations':location,
      });
}
 catch (e) {
      print("erroe");
}
}

class _DropdownAndTextFieldsState extends State<DropdownAndTextFields> {
  
   List<String> _collections = [];
 
 
     @override
  void initState() {
    super.initState();
    _setupCollectionListener();
  }

  void _setupCollectionListener() {
    final firestoreInstance = FirebaseFirestore.instance;

    // Real-time listener to fetch updates dynamically
    firestoreInstance
        .collection('metadata')
        .doc('collections')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        List<dynamic> collectionNames = snapshot.data()!['names'];
        setState(() {
          _collections = List<String>.from(collectionNames);
           
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown
          DropdownButtonFormField<String>(
            value: _selectedOption,
            hint: Text("Edit Profile"),
            items:  _collections.map((collection) {
                  return DropdownMenuItem<String>(
                    value: collection,
                    child: Text(collection),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedOption = value;
              });
            },
            decoration: InputDecoration(
              labelText: 'Dropdown',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),

          // First Text Field
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Edit email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),

          // Second Text Field
          TextFormField(
            controller: _bioController,
            decoration: InputDecoration(
              labelText: 'edit bio',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10,),
          greenButton(
              
              
              'Save Changes'
              
            ),
        ],
      ),
    );
  }
}
Widget greenButton(String title) {
  return MaterialButton(
    height: 50,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    color: Colors.blueAccent,
    onPressed: _submit,
    child: Text(
      title,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}