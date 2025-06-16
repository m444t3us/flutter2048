import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      home: const Projeto2048Page(title: 'Jogo 2048'),
    );
  }
}

class Projeto2048Page extends StatefulWidget {
  const Projeto2048Page({super.key, required this.title});



  final String title;

  @override
  State<Projeto2048Page> createState() => _Projeto2048PageState();
}

class _Projeto2048PageState extends State<Projeto2048Page> {
  @override
  Widget build(BuildContext context) {
    double cellSize = 60;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('2048'),
      ),
      body: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for(int row = 0; row < 5; row++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for(int col = 0; col < 5; col++)
                      Container(
                        margin: const EdgeInsets.all(4),
                        width: cellSize,
                        height: cellSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                  ],
                ),
            ],
          ),
          const SizedBox(width: 60),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.arrow_upward),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 12),
                  const SizedBox(width: 48),
                  const SizedBox(width: 12),

                  ElevatedButton(
                    onPressed: () {},
                      child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Icon(Icons.arrow_downward),
              ),
            ],
          ),

         ],

      ),





      )
      );
  }
}
