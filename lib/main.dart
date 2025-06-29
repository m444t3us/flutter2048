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
  // aqui cria o estado alteravel do projeto krl
}

class _Projeto2048PageState extends State<Projeto2048Page> {
  int gridSize = 5;
  int maxValue = 2048;
  late List<List<int>> board; //late para iniciar mais tarde
  int moves = 0;
  String message = '';
  final double cellSize = 60;
  final random = Random();
  //declarando variáveis iniciais

  @override
  void initState() { //primeira inicialização
    super.initState(); //chama construtor pai
    _initBoard(); //iniciar tabuleiro
  }

  void _initBoard() {
    moves = 0; //zera contador dos movimentos
    message = ''; //zera mensagem de vitoria/derrota
    board = List.generate(gridSize, (_) => List.filled(gridSize, 0)); //criação do tabuleiro
    _addRandomBlock(); //função do numero aleatorio
    setState(() {}); //atualiza estado da tela
  }

  void _setDifficulty(int size) {
    setState(() {
      gridSize = size; //altera o tamanho do tabuleiro de acordo com a dificuldade selecionada
      maxValue = size == 4 ? 1024 : size == 5 ? 2048 : 4096; //atualiza o valor da vitória de acordo com o tamanho do tabuleiro
      //não tem size no 4096 porque não precisa disso no último(meio if/else)
      _initBoard(); //chama o init board pra resetar a tela
    });
    //vai alterar o tamanho do tabuleiro de acordo com a dificuldade selecionada
  }

  void _addRandomBlock() {
    List<Point<int>> empty = []; //lista para as posições vazias
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (board[r][c] == 0) empty.add(Point(r, c)); //esse ciclo armazena as posições vazias no emptty
      }
    }
    if (empty.isNotEmpty) {
      Point<int> spot = empty[random.nextInt(empty.length)];
      board[spot.x][spot.y] = 1;
      //vai escolher uma das posições vazias armazenadas para colocar o valor 1
      //se não tiver vazia não vai adicionar nada
    }
  }

  void _handleMove(int dx, int dy) { //dx, dy, indicam a direção horizontal e vertical do movimento
    if (message.isNotEmpty) return; //trava o jogo se vitória/derrota
    setState(() { //para atualizar o codigo
      bool moved = false; //se houve mudança
      List<List<bool>> merged = List.generate(gridSize, (_) => List.filled(gridSize, false));
      //evitar que multiplas fusões da mesma célula no mesmo movimento

      List<Point<int>> order = [];
      for (int r = 0; r < gridSize; r++) {
        for (int c = 0; c < gridSize; c++) {
          order.add(Point(r, c));
          //loop para armazenar posições e ordem
        }
      }

      if (dx == 1) order.sort((a, b) => b.x.compareTo(a.x)); //ultima linha -> primeira linha
      if (dx == -1) order.sort((a, b) => a.x.compareTo(b.x)); //primeira linha -> ultima linha
      if (dy == 1) order.sort((a, b) => b.y.compareTo(a.y)); //ultima coluna -> primeira coluna
      if (dy == -1) order.sort((a, b) => a.y.compareTo(b.y)); //primeira coluna -> ultima coluna
      //indicadores da ordem de processamento dependendo da direção do movimento
      //a(menor) b(maior) indica a ordem de processamento, se B compare to A seria do ultimo ao primeiro
      //se A compare to B indica do primeiro ao ultimo
      //o sort vai organizar a lista de acordo com à direção

      for (var point in order) {
        int r = point.x;
        int c = point.y;
        //pega coordenada atual

        if (board[r][c] == 0) continue; //verifica se a célula está vazia
        int nr = r + dx;
        int nc = c + dy;
        //calculo de movimentação
        if (nr < 0 || nr >= gridSize || nc < 0 || nc >= gridSize) continue;
        //verificação de limite do tabuleiro

        if (board[nr][nc] == 0) { //se o vizinho está sozinho
          board[nr][nc] = board[r][c]; //valor antigo na casa nova
          board[r][c] = 0; //casa antiga zerada
          moved = true; //movimentado
        } else if (board[nr][nc] == board[r][c] && !merged[nr][nc]) { //se a vizinha é igual e não foi juntada
          board[nr][nc] *= 2; //multiplica eles por 2
          board[r][c] = 0; //zera a anterior a vizinha
          merged[nr][nc] = true; //juntado
          moved = true; //movimentado
        }
      }

      if (moved) {
        _addRandomBlock(); //verifica caso movimento tenha ocorrido(moved=true)
        moves++; //soma no contador
        if (_checkVictory()) { //ver se venceu
          message = 'VOCÊ GANHOU';
        } else if (!_canMove()) { //ver se não pode se mexer
          message = 'VOCÊ PERDEU';
        }
      }
    });
  }

  bool _checkVictory() {
    for (var row in board) {
      for (var val in row) { //verificar cada local do tabuleiro
        if (val == maxValue) return true; //se valor maximo encontrado retorna vitoria
      }
    }
    return false; //caso não encontre
  }

  bool _canMove() {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) { //percorrer tabuleiro
        if (board[i][j] == 0) return true; //procura células vazias, se tem canmove = true
        if (j + 1 < gridSize && board[i][j] == board[i][j + 1]) return true;
        if (i + 1 < gridSize && board[i][j] == board[i + 1][j]) return true;
        //se a célula não está vazia vai procurar células em volta que podem se juntar
        //caso encontre retorna true
      }
    }
    return false; //caso não encontre jogo acaba
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
    //switch das cores equivalente ao valor encontrado no tabuleiro
  }


  //tela
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
                    const SizedBox(width: 8), //espaço entre botões
                    ElevatedButton(onPressed: () => _setDifficulty(5), child: const Text('Médio')),
                    const SizedBox(width: 8), //espaço entre botões
                    ElevatedButton(onPressed: () => _setDifficulty(6), child: const Text('Difícil')),
                  ],
                ), //construção dos botões de dificuldade, alterando o tamanho do tabuleiro com o clique nela
                const SizedBox(height: 20),
                Text('Movimentos: $moves', style: const TextStyle(color: Colors.white, fontSize: 18)), //contador de movimentos
                const SizedBox(height: 20),
                for (int row = 0; row < gridSize; row++) //construção do tabuleiro, percorre cada linha
                  Row( //faz a linha de widgets = linha de tabuleiro
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int col = 0; col < gridSize; col++) //percorre a coluna da linha atual
                        Container(
                          margin: const EdgeInsets.all(4), //espaçamento entre as células
                          width: cellSize,
                          height: cellSize,
                          //tamanho fixo de cada célula pra facilitar o código
                          decoration: BoxDecoration(
                            color: getColor(board[row][col]), //coloca cor no bloco de acordo com o valor
                            border: Border.all(color: Colors.black), //bordinha
                          ),
                          child: Center( //centraliza o texto dos bloco
                            child: Text(
                              board[row][col] == 0 ? '' : board[row][col].toString(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                              //ve se é 0, se for mostra a string vazia,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(width: 60), //espaço do tabuleiro pros botões
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
                    //espaçamento entre os botões
                    ElevatedButton(onPressed: () => _handleMove(0, 1), child: const Icon(Icons.arrow_forward)),
                  ],
                ),
                ElevatedButton(onPressed: () => _handleMove(1, 0), child: const Icon(Icons.arrow_downward)),
                //quando pressionado cada botão chama a função _handleMove com a direção desejada
                //que o tabuleiro deve mexer suas peças para representar o botão clicado
                //arrow_upward == seta pra cima ou seja sobe um (-1,0)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
