import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../auth/model/login_model.dart';
import '../../auth/viewmodel/login_view_model.dart';
// provider normalUsersProvider

class MultiUserPicker extends ConsumerStatefulWidget {
  final List<String>? initiallySelectedIds;
  final void Function(List<String> selectedIds) onSelectionChanged;

  const MultiUserPicker({
    super.key,
    this.initiallySelectedIds,
    required this.onSelectionChanged,
  });

  @override
  ConsumerState<MultiUserPicker> createState() => _MultiUserPickerState();
}

class _MultiUserPickerState extends ConsumerState<MultiUserPicker> {
  List<User> selectedUsers = [];

  @override
  void initState() {
    super.initState();
    selectedUsers = [];
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(normalUsersProvider);

    return usersAsync.when(
      data: (users) => InkWell(
        onTap: () async {
          final result = await showDialog<List<User>>(
            context: context,
            builder: (_) => MultiSelectDialog<User>(
              items: users
                  .map((u) => MultiSelectItem<User>(u, u.name))
                  .toList(),
              initialValue: selectedUsers,
              searchable: true,
              title: const Text("Selecionar responsáveis"),
              confirmText: const Text("OK"),
              cancelText: const Text("Cancelar"),
            ),
          );

          if (result != null) {
            setState(() => selectedUsers = result);
            widget.onSelectionChanged(result.map((u) => u.id).toList());
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.group_add),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  selectedUsers.isEmpty
                      ? "Selecionar responsáveis"
                      : "${selectedUsers.length} usuário(s) selecionado(s)",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erro: $e')),
    );
  }
}
