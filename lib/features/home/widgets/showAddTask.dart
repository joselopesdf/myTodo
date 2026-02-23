import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'create_task_form.dart';
import '../viewmodel/task_view_model.dart';

Future<void> showAddTask(BuildContext context, WidgetRef ref) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        alignment: Alignment.bottomCenter,
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,

              child: const CreateTaskForm(),
            ),
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                ref.read(taskViewModel.notifier).reset();
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
          ),
        ],
      );
    },
  );
}
