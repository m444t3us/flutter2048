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
  int maxValue = 2048;
  late List<List<int>> board;
  int moves = 0;
  String message = '';
  final double cellSize = 60;
  final random = Random();

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {
    moves = 0;
    message = '';
    board = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    _addRandomBlock();
    setState(() {});
  }

  void _setDifficulty(int size) {
    setState(() {
      gridSize = size;
      maxValue = size == 4 ? 1024 : size == 5 ? 2048 : 4096;
      _initBoard();
    });
  }

  void _addRandomBlock() {
    List<Point<int>> empty = [];
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (board[r][c] == 0) empty.add(Point(r, c));
      }
    }
    if (empty.isNotEmpty) {
      Point<int> spot = empty[random.nextInt(empty.length)];
      board[spot.x][spot.y] = 1;
    }
  }

  bool _moveBoard(int dx, int dy) {
    bool moved = false;
    List<List<int>> oldBoard = board.map<List<int>>((row) => List<int>.from(row)).toList();
    List<List<bool>> merged = List.generate(gridSize, (_) => List.filled(gridSize, false));

    List<Point<int>> cells = [];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        cells.add(Point(i, j));
      }
    }

    if (dx == 1) cells.sort((a, b) => b.x.compareTo(a.x));
    if (dx == -1) cells.sort((a, b) => a.x.compareTo(b.x));
    if (dy == 1) cells.sort((a, b) => b.y.compareTo(a.y));
    if (dy == -1) cells.sort((a, b) => a.y.compareTo(b.y));

    for (final cell in cells) {
      int i = cell.x;
      int j = cell.y;
      if (board[i][j] == 0) continue;
      int ni = i + dx;
      int nj = j + dy;
      if (ni >= 0 && ni < gridSize && nj >= 0 && nj < gridSize) {
        if (board[ni][nj] == 0) {
          board[ni][nj] = board[i][j];
          board[i][j] = 0;
          moved = true;
        } else if (board[ni][nj] == board[i][j] && !merged[ni][nj]) {
          board[ni][nj] *= 2;
          board[i][j] = 0;
          merged[ni][nj] = true;
          moved = true;
        }
      }
    }

    if (!_boardsEqual(board, oldBoard)) {
      _addRandomBlock();
      moves++;
      if (_checkVictory()) {
        message = 'Você venceu';
      } else if (!_canMove()) {
        message = 'Você perdeu';
      }
    }
    return moved;
  }

  bool _boardsEqual(List<List<int>> a, List<List<int>> b) {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (a[i][j] != b[i][j]) return false;
      }
    }
    return true;
  }

  bool _checkVictory() {
    for (var row in board) {
      for (var val in row) {
        if (val == maxValue) return true;
      }
    }
    return false;
  }

  bool _canMove() {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (board[i][j] == 0) return true;
        if (j + 1 < gridSize && board[i][j] == board[i][j + 1]) return true;
        if (i + 1 < gridSize && board[i][j] == board[i + 1][j]) return true;
      }
    }
    return false;
  }

  void _handleMove(int dx, int dy) {
    if (message.isNotEmpty) return;
    _moveBoard(dx, dy);
    setState(() {});
  }

  Color getColor(int value) {
    switch (value) {
      case 1:
        return Colors.orange[100]!;
      case 2:
        return Colors.orange[200]!;
      case 4:
        return Colors.orange[300]!;
      case 8:
        return Colors.orange[400]!;
      case 16:
        return Colors.orange[500]!;
      case 32:
        return Colors.deepOrange[400]!;
      case 64:
        return Colors.deepOrange[500]!;
      case 128:
        return Colors.red[300]!;
      case 256:
        return Colors.red[400]!;
      case 512:
        return Colors.red[500]!;
      case 1024:
        return Colors.red[600]!;
      case 2048:
        return Colors.red[700]!;
      case 4096:
        return Colors.red[900]!;
      default:
        return Colors.white;
    }
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
                Text(
                  message.isNotEmpty ? message : 'Jogo 2048',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () => _setDifficulty(4), child: const Text('Fácil')),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: () => _setDifficulty(5), child: const Text('Médio')),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: () => _setDifficulty(6), child: const Text('Difícil')),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Movimentos: $moves', style: const TextStyle(color: Colors.white, fontSize: 18)),
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
                            color: getColor(board[row][col]),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Center(
                            child: Text(
                              board[row][col] == 0 ? '' : board[row][col].toString(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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
                ElevatedButton(onPressed: () => _handleMove(-1, 0), child: const Icon(Icons.arrow_upward)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(onPressed: () => _handleMove(0, -1), child: const Icon(Icons.arrow_back)),
                    const SizedBox(width: 12),
                    const SizedBox(width: 48),
                    const SizedBox(width: 12),
                    ElevatedButton(onPressed: () => _handleMove(0, 1), child: const Icon(Icons.arrow_forward)),
                  ],
                ),
                ElevatedButton(onPressed: () => _handleMove(1, 0), child: const Icon(Icons.arrow_downward)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
