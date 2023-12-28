import 'package:flutter/material.dart';
import 'package:qurankhwani/jigsaw_game.dart';

class JigsawScreen extends StatefulWidget {
  const JigsawScreen({super.key});

  @override
  State<JigsawScreen> createState() => _JigsawScreenState();
}

class _JigsawScreenState extends State<JigsawScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Display the image
                Image.asset(
                  'assets/image/jigsaw/jigsaw.png', // Replace with your image asset path
                  width: 300,
                ),

                SizedBox(height: 20),

                // Create a "Start" button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PuzzleGame()),
                    );
                  },
                  child: Text('Start'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
