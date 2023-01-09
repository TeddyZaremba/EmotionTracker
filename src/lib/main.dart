import 'package:flutter/material.dart';
import 'package:tzarem2_project4/log.dart';
import 'package:tzarem2_project4/plot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Daily Emotion Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade800,
        title: Text(widget.title),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover),
        ),
        child: Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => log()));
                },
                child: Container(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(238, 237, 231, .8),
                    ),
                    // Change button text when light changes state.
                    child: Center(
                      child: Text("Log how you feel", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))
                    )
                ),
              ),
              SizedBox(height:30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => plot()));
                },
                child: Container(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(238, 237, 231, .8),
                    ),
                    // Change button text when light changes state.
                    child: Center(
                      child: Text("Plot your emotions", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))
                    )
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}



