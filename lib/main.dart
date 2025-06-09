eimport 'package:flutter/material.dart';

void main() {
  runApp(ClassePai());
}

class ClassePai extends StatefulWidget {
  @override
  State<ClassePai> createState() {
    return ClasseFilha();
  }
}

class ClasseFilha extends State<ClassePai> {
  String _display = ''; // Visor superior (mostra a operação completa)
  String _currentInput = ''; // Entrada atual (visor inferior esquerdo)
  String _resultado = ''; // Resultado final (visor direito inferior)

  // Método para atualizar o visor inferior enquanto o número está sendo digitado
  void _atualizarEntrada(String texto) {
    setState(() {
      _currentInput += texto; // Adiciona o número ao visor de entrada
    });
  }

  // Método para adicionar a operação no visor superior
  void _adicionarOperacao(String texto) {
    setState(() {
      // Se a entrada não estiver vazia, envia o número para o visor superior
      if (_currentInput.isNotEmpty) {
        _display += _currentInput;  // Adiciona o número atual ao visor superior
        _currentInput = '';  // Limpa a entrada
      }
      // Se o texto for um operador, apenas o adiciona ao visor superior
      if (_display.isNotEmpty && texto != "=") {
        _display += ' $texto';  // Adiciona o operador ao visor superior
      }
    });
  }

  // Método para calcular o resultado
  void _calcularResultado() {
    try {
      setState(() {
        // Se a entrada não estiver vazia, inclui o número atual no visor superior
        if (_currentInput.isNotEmpty) {
          _display += _currentInput; // Adiciona o número ao visor superior
          _currentInput = '';  // Limpa a entrada
        }

        // Se o último caractere no visor superior for um operador, remove-o
        if (_display.endsWith(' +') || _display.endsWith(' -') ||
            _display.endsWith(' *') || _display.endsWith(' /')) {
          _display = _display.substring(0, _display.length - 2); // Remove o operador final
        }

        // Verifica se a expressão está vazia e se é possível realizar a operação
        if (_display.isEmpty || _display == "Erro") {
          _resultado = 'Erro';  // Exibe erro se não houver uma operação válida
        } else {
          // Avalia a expressão e calcula o resultado
          _resultado = _avaliarExpressao(_display); // Chama o método de avaliação
        }

        // Limpa os visores de operação e entrada após calcular
        _display = '';  // Limpa o visor superior (operação)
        _currentInput = '';  // Limpa a entrada
      });
    } catch (e) {
      setState(() {
        _resultado = 'Erro'; // Exibe erro se a expressão for inválida
      });
    }
  }

  // Método para avaliar expressões respeitando a ordem de operações
  String _avaliarExpressao(String expressao) {
    try {
      // Substitui os operadores de maneira simples
      expressao = expressao.replaceAll('x', '*').replaceAll('÷', '/');
      // Avalia a expressão considerando a ordem de operações
      final resultado = _calcularComOrdem(expressao);
      return resultado.toString();
    } catch (e) {
      return 'Erro';
    }
  }

  // Função que faz o cálculo considerando a ordem de operações
  double _calcularComOrdem(String expressao) {
    // Primeiro, faz as multiplicações e divisões
    expressao = _calcularMultiplicacaoDivisao(expressao);
    // Depois, faz as somas e subtrações
    expressao = _calcularSomaSubtracao(expressao);

    return double.parse(expressao);
  }

  // Calcula as multiplicações e divisões
  String _calcularMultiplicacaoDivisao(String expressao) {
    // Regular expression para encontrar multiplicação e divisão
    final regExp = RegExp(r'(\d+(\.\d+)?)\s*([*/])\s*(\d+(\.\d+)?)');

    while (regExp.hasMatch(expressao)) {
      final match = regExp.firstMatch(expressao);
      if (match != null) {
        final num1 = double.parse(match.group(1)!);
        final num2 = double.parse(match.group(4)!);
        final operador = match.group(3);

        double resultado;
        if (operador == '*') {
          resultado = num1 * num2;
        } else if (operador == '/') {
          resultado = num1 / num2;
        } else {
          continue;
        }

        // Substitui a operação original pelo resultado
        expressao = expressao.replaceRange(
            match.start, match.end, resultado.toString());
      }
    }

    return expressao;
  }

  // Calcula as somas e subtrações
  String _calcularSomaSubtracao(String expressao) {
    // Regular expression para encontrar soma e subtração
    final regExp = RegExp(r'(\d+(\.\d+)?)\s*([+-])\s*(\d+(\.\d+)?)');

    while (regExp.hasMatch(expressao)) {
      final match = regExp.firstMatch(expressao);
      if (match != null) {
        final num1 = double.parse(match.group(1)!);
        final num2 = double.parse(match.group(4)!);
        final operador = match.group(3);

        double resultado;
        if (operador == '+') {
          resultado = num1 + num2;
        } else if (operador == '-') {
          resultado = num1 - num2;
        } else {
          continue;
        }

        // Substitui a operação original pelo resultado
        expressao = expressao.replaceRange(
            match.start, match.end, resultado.toString());
      }
    }

    return expressao;
  }

  // Método para limpar tudo
  void _limpar() {
    setState(() {
      _display = ''; // Limpa o visor completo
      _currentInput = ''; // Limpa o visor inferior esquerdo
      _resultado = ''; // Limpa o visor de resultado
    });
  }

  // Método para criar botões
  Widget criarBotao(BuildContext context, double altura, double largura, Color cor, String texto) {
    return Container(
      width: largura,
      height: altura,
      color: cor,
      child: TextButton(
        onPressed: () {
          if (texto == "=") {
            _calcularResultado(); // Calcula o resultado
          } else if (texto == "C") {
            _limpar(); // Limpa tudo
          } else if (texto == '+' || texto == '-' || texto == '*' || texto == '/') {
            _adicionarOperacao(texto); // Adiciona a operação ao visor
          } else {
            _atualizarEntrada(texto); // Atualiza a entrada com o número
          }
        },
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 24.0, // Tamanho da fonte ajustado para os botões
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Calculadora")),
        body: Column(
          children: [
            // Visor superior (mostra a operação completa)
            Container(
              width: double.infinity,
              height: 100,
              color: Colors.grey[300],
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerRight,
              child: Text(
                _display, // Exibe a operação completa
                style: TextStyle(
                  fontSize: 32.0, // Tamanho da fonte para o visor superior (reduzido)
                  color: Colors.black,
                ),
              ),
            ),
            // Visores inferiores lado a lado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Visor inferior esquerdo (número sendo digitado)
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 60,
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    _currentInput, // Exibe os números enquanto estão sendo digitados
                    style: TextStyle(
                      fontSize: 24.0, // Tamanho da fonte ajustado para o visor inferior esquerdo
                      color: Colors.black,
                    ),
                  ),
                ),
                // Visor inferior direito (mostra o resultado)
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 60,
                  color: Colors.grey[100],
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    _resultado, // Exibe o resultado final
                    style: TextStyle(
                      fontSize: 24.0, // Tamanho da fonte ajustado para o visor inferior direito
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            // Botões da calculadora
            Row(
              children: [
                Column(
                  children: [
                    criarBotao(context, 150, 150, Colors.white, "1"),
                    criarBotao(context, 150, 150, Colors.white, "4"),
                    criarBotao(context, 150, 150, Colors.white, "7"),
                    criarBotao(context, 150, 150, Colors.white, "0"),
                  ],
                ),
                Column(
                  children: [
                    criarBotao(context, 150, 150, Colors.white, "2"),
                    criarBotao(context, 150, 150, Colors.white, "5"),
                    criarBotao(context, 150, 150, Colors.white, "8"),
                    criarBotao(context, 150, 150, Colors.white, "C"),
                  ],
                ),
                Column(
                  children: [
                    criarBotao(context, 150, 150, Colors.white, "3"),
                    criarBotao(context, 150, 150, Colors.white, "6"),
                    criarBotao(context, 150, 150, Colors.white, "9"),
                  ],
                ),
                Column(
                  children: [
                    criarBotao(context, 100, 100, Colors.white, "+"),
                    criarBotao(context, 100, 100, Colors.white, "-"),
                    criarBotao(context, 100, 100, Colors.white, "/"),
                    criarBotao(context, 100, 100, Colors.white, "*"),
                    criarBotao(context, 100, 100, Colors.white, "="),
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