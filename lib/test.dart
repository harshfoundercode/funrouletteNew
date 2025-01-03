// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// class PopUpMenuTileButtonExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Popup Menu Button Example'),
//         ),
//         body: Center(
//           child: PopupMenuButton(
//             elevation: 5,
//             // color: Colors.black.withOpacity(0.5),
//             shadowColor: Colors.pink,
//             shape:StadiumBorder(
//               // borderRadius: BorderRadius.circular(10),
//               side: const BorderSide(width: 1,color: Colors.red)
//             ),
//             surfaceTintColor: Colors.green,
//             constraints: const BoxConstraints(
//               maxWidth: 100,
//             ),
//             padding: const EdgeInsets.all(0),
//             itemBuilder: (BuildContext context) => [
//               PopupMenuItem(
//                   child: Container(
//                 width: 40,
//                 height: 40,
//                 color: Colors.white,
//               ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//


import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isFirstContainerVisible = true;

  void toggleFirstContainerVisibility() {
    setState(() {
      isFirstContainerVisible = !isFirstContainerVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      body: Row(
        verticalDirection: VerticalDirection.up,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: isFirstContainerVisible ? 0 : 400,
            child: Visibility(
              visible: isFirstContainerVisible,
              child: Container(
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    'First Container',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: Container(
                width: 300,
                color: Colors.green,
                child: Center(
                 child: Container(
                      width: 100,
                    height: double.infinity,
                    color: Colors.red,
                    child: const Text("dsnnnnndjfnkdjfcdfjfckfcjfnkjfj",overflow: TextOverflow.ellipsis,),
                  ),
                  // child: Text(
                  //   'Second Container',
                  //   style: TextStyle(color: Colors.white),
                  // ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleFirstContainerVisibility,
        child: const Icon(Icons.add),
      ),
    );
  }
}
