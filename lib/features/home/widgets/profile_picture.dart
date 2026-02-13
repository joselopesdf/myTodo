import 'dart:async';
import 'dart:io';
import 'package:dev/features/home/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/providers/local_user_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/widget/online.dart';
import '../../auth/viewmodel/login_view_model.dart';
import '../state/upload_state.dart';
import '../viewmodel/upload_view_model.dart';

class ProfileImagePicker extends ConsumerStatefulWidget {
  const ProfileImagePicker({super.key});

  @override
  ConsumerState<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends ConsumerState<ProfileImagePicker> {
  File? _imageFile;
  String? _imageUrl;
  String? _errorMessage;
  bool _isUrlValidating = false;

  final TextEditingController _urlController = TextEditingController();

  /// Seleciona imagem da galeria
  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        setState(() {
          _imageFile = File(picked.path);
          _imageUrl = null;
          _errorMessage = null;
          _urlController.clear();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Erro ao selecionar imagem da galeria";
      });
    }
  }

  /// Valida se a URL realmente carrega uma imagem
  Future<bool> validateImageUrl(String url) async {
    final completer = Completer<bool>();

    try {
      final image = NetworkImage(url);
      final stream = image.resolve(const ImageConfiguration());
      final listener = ImageStreamListener(
        (info, _) => completer.complete(true),
        onError: (error, _) => completer.complete(false),
      );

      stream.addListener(listener);
      final isValid = await completer.future;
      stream.removeListener(listener);
      return isValid;
    } catch (_) {
      return false;
    }
  }

  /// Define URL como imagem de perfil
  Future<void> _setUrlImage() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      setState(() {
        _errorMessage = "URL não pode ser vazia";
        _imageFile = null;
        _imageUrl = null;
      });
      return;
    }

    final isValidSyntax = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    if (!isValidSyntax ||
        !(url.startsWith('http://') || url.startsWith('https://'))) {
      setState(() {
        _errorMessage = "URL inválida";
        _imageFile = null;
        _imageUrl = null;
      });
      return;
    }

    setState(() {
      _isUrlValidating = true;
      _errorMessage = null;
    });

    final isValid = await validateImageUrl(url);

    if (!isValid) {
      setState(() {
        _errorMessage = "Não foi possível carregar a imagem da URL";
        _imageFile = null;
        _imageUrl = null;
        _isUrlValidating = false;
      });
      return;
    }

    setState(() {
      _imageFile = null;
      _imageUrl = url;
      _errorMessage = null;
      _isUrlValidating = false;
    });
  }

  /// Limpar imagem selecionada
  void _clearImage() {
    setState(() {
      _imageFile = null;
      _imageUrl = null;
      _errorMessage = null;
      _urlController.clear();
    });
    ref.read(profileUploadProvider.notifier).reset();
  }

  /// Dispara upload manual
  Future<void> _uploadImage() async {
    final notifier = ref.read(profileUploadProvider.notifier);

    if (_imageFile != null) {
      await notifier.uploadProfile(file: _imageFile, isFile: true);
    } else if (_imageUrl != null && _imageUrl!.trim().isNotEmpty) {
      await notifier.uploadProfile(url: _imageUrl, isFile: false);
    } else {
      return;
    }
  }

  /// Preview da imagem
  Widget _buildPreview() {
    if (_errorMessage != null) {
      return Column(
        children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 8),
          Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
        ],
      );
    }

    if (_imageFile != null) {
      return CircleAvatar(radius: 50, backgroundImage: FileImage(_imageFile!));
    }

    if (_imageUrl != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: CachedNetworkImageProvider(_imageUrl!),
        onBackgroundImageError: (_, __) {
          setState(() {
            _errorMessage = "Não foi possível carregar a imagem da URL";
            _imageUrl = null;
          });
        },
      );
    }

    return const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50));
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(profileUploadProvider);
    final showUploadButton = _imageFile != null || _imageUrl != null;

    ref.listen<UploadState>(profileUploadProvider, (previous, next) {
      if (next is UploadSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
      }
      // else if (next is UploadSuccess && localUser.value!.role == 'user') {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     Navigator.of(context).pop();
      //   });
      // }
      else if (next is UploadError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(next.message)));
        });
      }

      // }
    });

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPreview(),
          const SizedBox(height: 10),
          if (_isUrlValidating || uploadState is UploadLoading)
            const CircularProgressIndicator()
          else ...[
            ElevatedButton(
              onPressed: _pickFromGallery,
              child: const Text('Selecionar da Galeria'),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        hintText: 'Coloque URL',
                      ),
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        onPressed: _setUrlImage,
                        icon: const Icon(Icons.check),
                      ),
                      IconButton(
                        onPressed: _clearImage,
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (showUploadButton)
              ElevatedButton(
                onPressed: _uploadImage,
                child: const Text('Fazer Upload'),
              ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();

    super.dispose();
  }
}
