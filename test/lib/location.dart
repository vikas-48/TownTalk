 
// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           titleTextStyle: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//           iconTheme: IconThemeData(color: Colors.black),
//         ),
//         textTheme: const TextTheme(
//           bodyMedium: TextStyle(color: Colors.black87),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: Colors.grey[800],
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ),
//       home: LocationSelectionPage(),
//     );
//   }
// }

// class LocationSelectionPage extends StatefulWidget {
//   @override
//   _LocationSelectionPageState createState() => _LocationSelectionPageState();
// }

// class _LocationSelectionPageState extends State<LocationSelectionPage>
//     with SingleTickerProviderStateMixin {
//   final List<String> _allLocations = [
//     'New York',
//     'Los Angeles',
//     'Chicago',
//     'Houston',
//     'Phoenix',
//     'San Francisco',
//     'Seattle',
//     'Miami',
//     'Boston',
//     'Denver'
//   ];

//   List<String> _filteredLocations = [];
//   List<String> _recentSearches = [];
//   String? _selectedLocation;

//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _filteredLocations = _allLocations; // Initially display all locations

//     // Initialize animation controller
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );

//     // Define the slide animation for the location list
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.2), // Start slightly below the view
//       end: Offset.zero, // Move to original position
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeOut,
//       ),
//     );

//     _controller.forward(); // Start the animation
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         _filteredLocations = _allLocations;
//       } else {
//         _filteredLocations = _allLocations
//             .where((location) =>
//                 location.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   void _onLocationSelected(String location) {
//     setState(() {
//       _selectedLocation = location;
//       if (!_recentSearches.contains(location)) {
//         _recentSearches.add(location);
//         if (_recentSearches.length > 5) {
//           _recentSearches.removeAt(0); // Limit recent searches to 5
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Location Selector"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Search for a location",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               onChanged: _onSearchChanged,
//               decoration: InputDecoration(
//                 hintText: "Type to search locations...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 prefixIcon: const Icon(Icons.search),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Animated list of locations
//             Expanded(
//               child: SlideTransition(
//                 position: _slideAnimation,
//                 child: ListView.builder(
//                   itemCount: _filteredLocations.length,
//                   itemBuilder: (context, index) {
//                     final location = _filteredLocations[index];
//                     return ListTile(
//                       title: Text(location),
//                       onTap: () => _onLocationSelected(location),
//                     );
//                   },
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Recently searched locations directly visible (No animation)
//             if (_recentSearches.isNotEmpty) ...[
//               const Text(
//                 "Recently Searched Locations",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 8.0,
//                 children: _recentSearches.map((location) {
//                   return Chip(
//                     label: Text(location),
//                     onDeleted: () {
//                       setState(() {
//                         _recentSearches.remove(location);
//                       });
//                     },
//                   );
//                 }).toList(),
//               ),
//             ],
//             const SizedBox(height: 16),

//             ElevatedButton(
//               onPressed: () {
//                 String selectedLocation =
//                     _selectedLocation ?? "No location selected";
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text("Location: $selectedLocation"),
//                   ),
//                 );
//               },
//               child: const Text("Submit"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:towntalk/home.dart';
 

class FieldChoosePage extends StatefulWidget {
  @override
  _FieldChoosePageState createState() => _FieldChoosePageState();
}

class _FieldChoosePageState extends State<FieldChoosePage> {
  List<String> _collections = [];
  String? _selectedCollection;
  bool _isLoading = true;

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
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location  '),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : DropdownButton<String>(
                hint: Text('Select Location'),
                value: _selectedCollection,
                onChanged: (value) {
                  setState(() {
                    _selectedCollection = value;
                     selectedCategory.value=value;
                  });
                  // if (value != null) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => DisplayTextsPage(
                  //         category: value,
                  //       ),
                  //     ),
                  //   );
                  // }
                },
                items: _collections.map((collection) {
                  return DropdownMenuItem<String>(
                    value: collection,
                    child: Text(collection),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
