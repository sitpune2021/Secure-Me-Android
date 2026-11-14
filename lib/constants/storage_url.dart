class StorageUrl {
  StorageUrl._();

  static const String host = 'https://secureme.thecanatech.com';
  static const String storageBaseUrl = '$host/storage';

  static String buildImageUrl(String path) {
    if (path.isEmpty) return path;

    if (path.startsWith('http')) {
      if (path.contains('/storage/') || path.contains('/admin-assets/')) {
        return path;
      }

      if (!path.startsWith(host)) {
        final uri = Uri.tryParse(path);

        if (uri != null && uri.pathSegments.isNotEmpty) {
          return '$storageBaseUrl/${uri.pathSegments.last}';
        }
      }

      return path;
    }

    if (path.startsWith('/storage/') || path.startsWith('storage/')) {
      return '$host/${path.replaceFirst(RegExp(r'^/'), '')}';
    }

    return '$storageBaseUrl/$path';
  }
}
