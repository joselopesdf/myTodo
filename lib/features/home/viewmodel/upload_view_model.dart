import 'dart:io';
import 'package:dev/core/providers/connection_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/local_user_provider.dart';

import '../../auth/repository/login_repository.dart';
import '../state/upload_state.dart';

final profileUploadProvider =
    NotifierProvider.autoDispose<ProfileUploadNotifier, UploadState>(
      ProfileUploadNotifier.new,
    );

Future<void> _deleteOldPhotoIfNeeded(
  String? oldUrl,
  FirebaseStorage storage,
) async {
  if (oldUrl == null) return;

  try {
    // Só deleta se for URL do Firebase Storage
    if (!oldUrl.contains("firebasestorage")) return;

    final ref = storage.refFromURL(oldUrl);
    await ref.delete();
  } catch (e) {
    // Ignora erros: pode estar offline ou foto pode não existir
  }
}

class ProfileUploadNotifier extends Notifier<UploadState> {
  @override
  UploadState build() {
    return const UploadInitial();
  }

  Future<void> uploadProfile({
    File? file,
    String? url,
    bool isFile = true,
  }) async {
    state = const UploadLoading();

    try {
      final store = ref.read(firestoreProvider);

      final user = ref.read(localUserProvider);

      bool online = ref.read(isOnlineProvider);

      final storage = ref.read(fireStorage);

      if (!online) {
        state = const UploadError("Usuário Sem Internet para Fazer Upload !");
        return;
      }

      if (user.value == null) {
        state = const UploadError("Usuário não encontrado");
        return;
      }

      String? finalUrl;
      final String? oldPhoto = user.value?.photo;

      if (!isFile) {
        finalUrl = url;

        await store.collection("users").doc(user.value?.id).update({
          "photo": finalUrl,
        });

        await ref.read(localUserProvider.notifier).updateUserPhoto(finalUrl!);

        await _deleteOldPhotoIfNeeded(oldPhoto, storage);
      } else {
        if (file == null) {
          state = const UploadError("Arquivo inválido");
          return;
        }

        // Caminho da imagem: users/{userId}/profile.jpg
        final refImage = storage.ref().child(
          "users/${user.value?.id}/profile.jpg",
        );

        // Faz upload do arquivo
        await refImage.putFile(file);

        // Pega URL final da imagem
        finalUrl = await refImage.getDownloadURL();

        // Atualiza Firestore
        await store.collection("users").doc(user.value?.id).update({
          "photo": finalUrl,
        });

        // Atualiza LocalStorage
        await ref.read(localUserProvider.notifier).updateUserPhoto(finalUrl);
      }

      state = UploadSuccess(imageUrl: finalUrl);
    } catch (e) {
      state = UploadError("Erro ao fazer upload: ${e.toString()}");
    }
  }

  /// Reseta o estado
  void reset() {
    state = const UploadInitial();
  }
}
