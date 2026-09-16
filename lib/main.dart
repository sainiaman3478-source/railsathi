import 'package:flutter/material.dart';

void main() => runApp(RailSathiPro());

class RailSathiPro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF0D47A1),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.train_rounded, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text('RailSathi Pro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            Text('Build Success!', style: TextStyle(fontSize: 18, color: Colors.greenAccent)),
            SizedBox(height: 30),
            Text('Ab Pro features add karenge', style: TextStyle(color: Colors.white70)),
          ]),
        ),
      ),
    );
  }
}
