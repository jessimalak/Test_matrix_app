import 'package:flutter/material.dart';
import 'package:test_matrix_app/screens/form.dart';
import 'package:test_matrix_app/screens/matrix.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyApp();
}

class MyApp extends State<MyHomePage> {
  Map<String, int> matrixSize = {"x": 0, "y": 0};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter! Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Navigator(
        pages: [
          MaterialPage(child: FormScreen(
            openMatrix: (values) {
              print('opening screen...');
              setState(() {
                matrixSize = values;
              });
            },
          )),
          if (matrixSize["x"] != 0 && matrixSize["y"] != 0)
            MaterialPage(
                child: MatrixScreen(
              rows: matrixSize["x"] ?? 0,
              columns: matrixSize["y"] ?? 0,
            ))
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          setState(() {
            matrixSize = {"x": 0, "y": 0};
          });
          return true;
        },
      ),
    );
  }
}
