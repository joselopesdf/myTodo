abstract class UploadState {
  const UploadState();
}

// Estado inicial
class UploadInitial extends UploadState {
  const UploadInitial();
}

// Estado de carregamento
class UploadLoading extends UploadState {
  const UploadLoading();
}

// Estado de sucesso
class UploadSuccess extends UploadState {
  final String? imageUrl; // Pode ser URL ou path do storage

  const UploadSuccess({this.imageUrl});
}

// Estado de erro
class UploadError extends UploadState {
  final String message;

  const UploadError(this.message);
}


class UploadProgress extends UploadState {
  final double progress; // entre 0 e 1
  const UploadProgress(this.progress);
}
