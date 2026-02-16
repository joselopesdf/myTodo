import 'package:dev/features/home/viewmodel/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/local_user_provider.dart';
import '../model/hive_task_model.dart';
import '../repository/task_repository.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tasks = ref.watch(taskLocalRepositoryProvider).getLocalTasks();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Criar Nova Tarefa",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                      validator: (v) => v == null || v.trim().isEmpty
                          ? "Digite um nome"
                          : null,
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
                            Text(
                              completionDate == null
                                  ? "Escolher data de completar"
                                  : "${completionDate!.day}/${completionDate!.month}/${completionDate!.year}",
                              style: const TextStyle(fontSize: 16),
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
                        DropdownMenuItem(
                          value: "normal",
                          child: Text("Normal"),
                        ),
                        DropdownMenuItem(value: "alta", child: Text("Alta")),
                      ],
                      onChanged: (v) => setState(() => priority = v!),
                    ),

                    const SizedBox(height: 20),

                    // SELEÇÃO DE USUÁRIOS
                    InkWell(
                      onTap: () {
                        // 🔥 abrir modal para selecionar usuários
                        // você cria depois
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
                        child: const Row(
                          children: [
                            Icon(Icons.group_add),
                            SizedBox(width: 12),
                            Text("Selecionar responsáveis"),
                          ],
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
                        onPressed: () async {
                          final now = DateTime.now().toUtc();

                          final testTask = Task(
                            id: 'teste-1',
                            // id fixo só pra teste
                            title: 'Tarefa de Teste 2',
                            description:
                                'Esta é uma task de teste para verificar o Hive',
                            ownerId: ref.read(localUserProvider).value!.id,
                            assignedUserIds: [],
                            createdAt: now,
                            dueDate: now.add(const Duration(days: 7)),
                            // 1 semana depois
                            priority: 'normal',
                            completed: false,
                            isSynced: false,
                          );

                          // salvar localmente
                          await ref
                              .read(taskViewModel.notifier)
                              .createTask(testTask);

                          // conferir no console
                          final tasks = await ref
                              .read(taskLocalRepositoryProvider)
                              .getLocalTasks();
                          print(
                            'Tasks no Hive: ${tasks.map((t) => t.title).toList()}',
                          );
                        },

                        icon: const Icon(Icons.check),
                        label: const Text("Criar Tarefa"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
