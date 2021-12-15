import 'package:flutter/material.dart';
import '../components/fluent_icons.dart';

class FormScreen extends StatelessWidget {
  FormScreen({Key? key, required this.openMatrix}) : super(key: key);
  TextEditingController rowsController = TextEditingController();
  TextEditingController columnsController = TextEditingController();
  FocusNode columnNode = FocusNode();
  FocusNode rowNode = FocusNode();
  final Function(Map<String, int>) openMatrix;

  void _openMatrix() {
    String rows = rowsController.value.text;
    String columns = columnsController.value.text;
    if (rows.isEmpty) {
      rowNode.requestFocus();
    } else if (columns.isEmpty) {
      columnNode.requestFocus();
    } else {
      print('open matrix');
      rowNode.unfocus();
      columnNode.unfocus();
      openMatrix({"x": int.parse(rows), "y": int.parse(columns)});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App de prueba"),
      ),
      body: Container(
        child: Column(children: [
          TextField(
              controller: rowsController,
              focusNode: rowNode,
              autofocus: true,
              style: const TextStyle(fontSize: 14),
              cursorColor: Colors.green,
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: const InputDecoration(
                labelText: "Filas",
                prefixIcon: Icon(Fluent.chevron_down, size: 18,)
              ),
              onSubmitted: (_) {
                columnNode.requestFocus();
              },
              textInputAction: TextInputAction.next),
          TextField(
            controller: columnsController,
            focusNode: columnNode,
            style: const TextStyle(fontSize: 14),
            cursorColor: Colors.green,
            keyboardType: TextInputType.number,
            maxLength: 2,
            decoration: const InputDecoration(
              labelText: "Columnas",
              prefixIcon: Icon(Fluent.chevron_right, size: 18,)
            ),
            onSubmitted: (_) {
              _openMatrix();
            },
          ),
          ElevatedButton.icon(
              onPressed: _openMatrix, label: const Text("Generar matriz"), icon: Icon(Fluent.exit_outline),)
        ]),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
    );
  }
}
