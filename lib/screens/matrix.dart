import 'package:flutter/material.dart';
import 'dart:math';

class MatrixScreen extends StatefulWidget {
  const MatrixScreen({Key? key, required this.rows, required this.columns})
      : super(key: key);

  final int rows;
  final int columns;

  @override
  State<MatrixScreen> createState() => _MatrixScreen();
}

class _MatrixScreen extends State<MatrixScreen> {
  int islands = 0;
  List<List<int>> matrix = [];

  void setMatrix() {
    List<List<int>> matrix_ = [];
    for (int r = 0; r < widget.rows; r++) {
      List<int> cols = [];
      for (int c = 0; c < widget.columns; c++) {
        var random = Random();
        cols.add(random.nextInt(2));
      }
      matrix_.add(cols);
    }
    setState(() {
      matrix = matrix_;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setMatrix();
      countIslands();
    });
  }

  /* -- PRIMER INTENTO ALGORITMO PLANTEADO EN LA ENTREVISTA -- */
  // void countIslands() {
  //   List<List<String>> islands_ = [];
  //   for (int r = 0; r < matrix.length; r++) {
  //     for (int c = 0; c < matrix[r].length; c++) {
  //       if (matrix[r][c] == 1) {
  //         if ((r == 0 ? false : matrix[r - 1][c] == 1) || (c == matrix[r].length-1 ? false : matrix[r][c+1] == 1)) {
  //           for (int i = 0; i < islands_.length; i++) {
  //             if (islands_[i].contains('${r - 1}-$c') || islands_[i].contains('$r-${c-1}')) {
  //               islands_[i].add('$r-$c');
  //               break;
  //             }
  //           }
  //         } else {
  //           islands_.add(['$r-$c']);
  //         }
  //       }
  //     }
  //   }
  //   setState(() {
  //     islands = islands_.length;
  //   });
  // }

  /* -- SEGUNDO INTENTO PENSANDOLO UN POCO MEJOR CON LA CABEZA FRIA -- */
  void countIslands() {
    int count = 0;
    for (int r = 0; r < matrix.length; r++) {
      for (int c = 0; c < matrix[r].length; c++) {
        if (matrix[r][c] == 1) {
          count++;
          isIsland(r, c);
        }
      }
    }
    for (int r = 0; r < matrix.length; r++) {
      for (int c = 0; c < matrix[r].length; c++) {
        if (matrix[r][c] == 2) {
          matrix[r][c] = 1;
        }
      }
    }
    setState(() {
      islands = count;
    });
  }

  void isIsland(int row, int column) {
    bool before = column > 0 ? matrix[row][column - 1] == 1 : false;
    bool up = row > 0 ? matrix[row - 1][column] == 1 : false;
    bool after =
        column < matrix[row].length - 1 ? matrix[row][column + 1] == 1 : false;
    bool down = row < matrix.length - 1 ? matrix[row + 1][column] == 1 : false;
    matrix[row][column] = 2;
    if (up) {
      isIsland(row - 1, column);
    }
    if (before) {
      isIsland(row, column - 1);
    }
    if (after) {
      isIsland(row, column + 1);
    }
    if (down) {
      isIsland(row + 1, column);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrix'),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(children: [
            Row(
              children: [
                Text('Rows: ${widget.rows.toString()}'),
                Text('Columns: ${widget.columns.toString()}'),
                Text('Islands: ${islands.toString()}')
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                  children: matrix
                      .asMap()
                      .entries
                      .map((e) => Row(
                            children: e.value
                                .asMap()
                                .entries
                                .map((c) => TweenAnimationBuilder(
                                    tween: Tween<double>(begin: 0, end: 1),
                                    duration: const Duration(milliseconds: 550),
                                    curve: Curves.ease,
                                    builder: (context, double scale, child) {
                                      return Transform.scale(
                                        scale: scale,
                                        child: child,
                                      );
                                    },
                                    child: ElevatedButton(
                                        onPressed: () {
                                          var newMatrix = matrix;
                                          newMatrix[e.key][c.key] =
                                              c.value == 1 ? 0 : 1;
                                          setState(() {
                                            matrix = newMatrix;
                                          });
                                          countIslands();
                                        },
                                        child: Text(c.value.toString()),
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(0),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith<Color?>(
                                                        (Set<MaterialState>
                                                            states) {
                                              if (states.contains(
                                                  MaterialState.pressed)) {
                                                return Colors.lightGreen
                                                    .withOpacity(0.5);
                                              }
                                              return c.value == 0
                                                  ? Colors.lightBlue
                                                  : null;
                                            })))))
                                .toList(),
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ))
                      .toList()),
            )
          ])),
    );
  }
}
