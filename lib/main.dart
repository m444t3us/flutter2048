import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      home: const Projeto2048Page(title: 'Jogo 2048'),
      debugShowCheckedModeBanner: false,
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
  int boardSize = 5;
  int moveCount = 0;
  void resetMoveCount() {
    setState(() {
      moveCount = 0;
    });
  }
  void incrementMoveCount() {
    setState(() {
      moveCount++;
    });
  }
  @override
  Widget build(BuildContext context) {
    double cellSize = 60;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      boardSize = 4;
                      moveCount = 0;
                    });
                  },
                  child: const Text('Fácil'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      boardSize = 5;
                      moveCount = 0;
                    });
                  },
                  child: const Text('Médio'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      boardSize = 6;
                      moveCount = 0;
                    });
                  },
                  child: const Text('Difícil'),
                ),
                const SizedBox(width: 24),
                Text(
                  'Movimentos: $moveCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int row = 0; row < boardSize; row++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int col = 0; col < boardSize; col++)
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
                      onPressed: () {
                        incrementMoveCount();
                      },
                      child: const Icon(Icons.arrow_upward),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            incrementMoveCount();
                          },
                          child: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 12),
                        const SizedBox(width: 48),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            incrementMoveCount();
                          },
                          child: const Icon(Icons.arrow_forward),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        incrementMoveCount();
                      },
                      child: const Icon(Icons.arrow_downward),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
