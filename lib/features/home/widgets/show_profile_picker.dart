import 'package:dev/features/home/state/upload_state.dart';
import 'package:dev/features/home/widgets/profile_picture.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/upload_view_model.dart';

Future<void> showProfileImagePickerDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    // evita fechar tocando fora
    builder: (context) {
      final uploadState = ref.watch(profileUploadProvider);

      return AlertDialog(
        alignment: Alignment.center,

        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.4,

          child: uploadState is! UploadLoading
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      ProfileImagePicker(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          TextButton(
                            onPressed: () {
                              ref.read(profileUploadProvider.notifier).reset();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancelar"),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          // seu widget original
        ),
      );
    },
  );
}
