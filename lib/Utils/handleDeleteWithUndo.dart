import 'package:flutter/material.dart';

void handleDeleteWithUndo<T>({
  required BuildContext context,
  required List<T> list,
  required int index,
  required Function(T item) onFinalDelete,
}) {
  final removedItem = list[index];

  list.removeAt(index);

  bool isUndoPressed = false;

  ScaffoldMessenger.of(context)
      .showSnackBar(
        SnackBar(
          content: const Text("Item deleted"),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: "UNDO",
            onPressed: () {
              isUndoPressed = true;
              list.insert(index, removedItem);
            },
          ),
        ),
      )
      .closed
      .then((_) {
        if (!isUndoPressed) {
          onFinalDelete(removedItem);
        }
      });
}
