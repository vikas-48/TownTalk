 import 'package:flutter/material.dart';
import 'package:towntalk/post.dart';

// class Hpage extends StatelessWidget {
//   const Hpage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//            body: Column(
//         // padding: const EdgeInsets.all(16.0),
//         children: [
//           Container(
//             height: 200,
//             child: Card(
//               elevation: 4.0, // Add elevation for a shadow effect
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//                 side: BorderSide(color: Colors.grey, width: 1.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Colors.blue,
//                           child: Icon(
//                             Icons.person,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           'Balu Uppala',
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Had 2 extra tickets for Kalki 2928 AD, anyone up??',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     Text(
//                       'Special Morning Show 4AM AMB Cinemas',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                      SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Icon(Icons.access_time, size: 16, color: Colors.grey),
//                         SizedBox(width: 5),
//                         Text(
//                           '9:47 AM',
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                          SizedBox(width: 5),
//                         Text(
//                           'Posted To Jammikunta',
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                         SizedBox(width: 20),
//                         Icon(Icons.message, size: 16, color: Colors.grey),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Container(
//             height: 200,
//             child: Card(
//               elevation: 4.0, // Add elevation for a shadow effect
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//                 side: BorderSide(color: Colors.grey, width: 1.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 20,
//                           // backgroundColor: Colors.blue,
//                           child: Icon(
//                             Icons.person,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           'Srija Avunuri',
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       '''Hosting a event need few volunteers,will be paid on the basis of work. Work needed tdy & tmrw @manjeera grounds,jmkt ''',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                      SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Icon(Icons.access_time, size: 16, color: Colors.grey),
//                         SizedBox(width: 5),
//                         Text(
//                           '9:47 AM',
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                          SizedBox(width: 5),
//                         Text(
//                           'Posted To Jammikunta',
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                         SizedBox(width: 20),
//                         Icon(Icons.message, size: 16, color: Colors.grey),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//            SizedBox(height: 20),
//           Container(
//             height: 200,
//             child: Card(
//               elevation: 4.0, // Add elevation for a shadow effect
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//                 side: BorderSide(color: Colors.grey, width: 1.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 20,
//                           // backgroundColor: Colors.blue,
//                           child: Icon(
//                             Icons.person,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           'John Doe',
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non diam risus.',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                      SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Icon(Icons.access_time, size: 16, color: Colors.grey),
//                         SizedBox(width: 5),
//                         Text(
//                           '9:47 AM',
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                          SizedBox(width: 5),
//                         Text(
//                           'Posted To Jammikunta',
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                         SizedBox(width: 20),
//                         Icon(Icons.message, size: 16, color: Colors.grey),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//      floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Define the action to be taken when the button is pressed
//            Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => post()),
//            );
//         },
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

//     );
//   }
// }


void main() {
  runApp(HomeScreen());
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Towntalk'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          // Header section
          Container(
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color.fromARGB(255, 192, 95, 95))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ),
                const Text('Home'),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Tweet list section
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Replace with your tweet list length
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('https://via.placeholder.com/50'),
                    ),
                    title: Text('Tweet $index'),
                    subtitle: Text('This is a sample tweet'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}