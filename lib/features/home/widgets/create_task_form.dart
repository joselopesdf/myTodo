import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev/features/home/viewmodel/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/local_user_provider.dart';
import '../model/hive_task_model.dart';
import '../repository/task_repository.dart';
import 'multi_user_picker.dart';

class CreateTaskForm extends ConsumerStatefulWidget {
  const CreateTaskForm({super.key});

  @override
  ConsumerState<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends ConsumerState<CreateTaskForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  DateTime? completionDate;

  String priority = "normal";

  List<String> assignedUsers = [];

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskViewModel);

    ref.listen<AsyncValue<bool>>(taskViewModel, (previous, next) {
      next.when(
        data: (value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Tarefa criada com sucesso!")),
            );
            ref.read(taskViewModel.notifier).reset();
            Navigator.of(context).pop();
          }
        },
        loading: () {},
        error: (err, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(err.toString())));
        },
      );
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Criar Nova Tarefa",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // NOME
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nome da tarefa",
                  prefixIcon: Icon(Icons.edit),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Digite um nome" : null,
              ),

              const SizedBox(height: 20),

              // DESCRIÇÃO
              TextFormField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 20),

              // DATA DE COMPLETAR
              InkWell(
                onTap: () async {
                  final result = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                  );

                  if (result != null) {
                    setState(() => completionDate = result);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          completionDate == null
                              ? "Escolher data de completar"
                              : "${completionDate!.day}/${completionDate!.month}/${completionDate!.year}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // PRIORIDADE
              DropdownButtonFormField<String>(
                value: priority,
                decoration: const InputDecoration(
                  labelText: "Prioridade",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "baixa", child: Text("Baixa")),
                  DropdownMenuItem(value: "normal", child: Text("Normal")),
                  DropdownMenuItem(value: "alta", child: Text("Alta")),
                ],
                onChanged: (v) => setState(() => priority = v!),
              ),

              const SizedBox(height: 20),

              // SELEÇÃO DE USUÁRIOS
              InkWell(
                onTap: () {
                  // abrir modal para selecionar usuários
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MultiUserPicker(
                    initiallySelectedIds: [],
                    onSelectionChanged: (ids) {
                      setState(() {
                        assignedUsers = ids;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // BOTÃO CRIAR
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: taskState.isLoading
                      ? null
                      : () async {
                          final now = DateTime.now().toUtc();

                          final docRef = FirebaseFirestore.instance
                              .collection('tasks')
                              .doc();
                          final id = docRef.id;

                          final testTask = Task(
                            id: id,
                            title: nameController.text,
                            description: descController.text,
                            ownerId: ref.read(localUserProvider).value!.id,
                            assignedUserIds: assignedUsers,
                            createdAt: now,
                            dueDate:
                                completionDate ??
                                now.add(const Duration(days: 7)),
                            priority: priority,
                            completed: false,
                            isSynced: false,
                          );

                          await ref
                              .read(taskViewModel.notifier)
                              .createTask(testTask);

                          final tasks = await ref
                              .read(taskLocalRepositoryProvider)
                              .getLocalTasks();

                          print(
                            'Tasks no Hive: ${tasks.map((t) => t.title).toList()}',
                          );
                        },
                  icon: !taskState.isLoading
                      ? const Icon(Icons.check)
                      : const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                  label: const Text("Criar Tarefa"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
