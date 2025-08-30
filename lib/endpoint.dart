class Endpoint {
  static const socketUrl = 'https://369digital.org/z-product';
  static const cdnUrl = 'https://369digital.org';
}

String toAvatarUrl(String? avatar) {
  return '${Endpoint.cdnUrl}/$avatar';
}
