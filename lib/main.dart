import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo 2048',
      debugShowCheckedModeBanner: false,
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
  int gridSize = 5;
  late List<List<int>> board;
  int moves = 0;
  final double cellSize = 60;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {
    final random = Random();
    moves = 0;
    board = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    int r = random.nextInt(gridSize);
    int c = random.nextInt(gridSize);
    board[r][c] = 1;
    setState(() {});
  }

  void _setDifficulty(int size) {
    setState(() {
      gridSize = size;
      _initBoard();
    });
  }

  void moveUp() {
    setState(() {
      for (int col = 0; col < gridSize; col++) {
        for (int row = 1; row < gridSize; row++) {
          if (board[row][col] != 0 && board[row - 1][col] == 0) {
            board[row - 1][col] = board[row][col];
            board[row][col] = 0;
          }
        }
      }
      moves += 1;
    });
  }

  void moveDown() {
    setState(() {
      for (int col = 0; col < gridSize; col++) {
        for (int row = gridSize - 2; row >= 0; row--) {
          if (board[row][col] != 0 && board[row + 1][col] == 0) {
            board[row + 1][col] = board[row][col];
            board[row][col] = 0;
          }
        }
      }
      moves += 1;
    });
  }

  void moveLeft() {
    setState(() {
      for (int row = 0; row < gridSize; row++) {
        for (int col = 1; col < gridSize; col++) {
          if (board[row][col] != 0 && board[row][col - 1] == 0) {
            board[row][col - 1] = board[row][col];
            board[row][col] = 0;
          }
        }
      }
      moves += 1;
    });
  }

  void moveRight() {
    setState(() {
      for (int row = 0; row < gridSize; row++) {
        for (int col = gridSize - 2; col >= 0; col--) {
          if (board[row][col] != 0 && board[row][col + 1] == 0) {
            board[row][col + 1] = board[row][col];
            board[row][col] = 0;
          }
        }
      }
      moves += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Jogo 2048',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _setDifficulty(4),
                      child: const Text('Nível Fácil'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _setDifficulty(5),
                      child: const Text('Nível Fácil'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _setDifficulty(6),
                      child: const Text('Nível Fácil'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Movimentos: $moves',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                for (int row = 0; row < gridSize; row++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int col = 0; col < gridSize; col++)
                        Container(
                          margin: const EdgeInsets.all(4),
                          width: cellSize,
                          height: cellSize,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              board[row][col] == 0 ? '' : board[row][col].toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
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
                  onPressed: moveUp,
                  child: const Icon(Icons.arrow_upward),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: moveLeft,
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 12),
                    const SizedBox(width: 48),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: moveRight,
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: moveDown,
                  child: const Icon(Icons.arrow_downward),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
