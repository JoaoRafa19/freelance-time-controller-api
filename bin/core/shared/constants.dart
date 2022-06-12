

enum Strings {
  acesstoken,
}

extension StringsExtension on Strings {
  String get value {
    switch (this) {
      case Strings.acesstoken:
        return 'x-access-token';

      default:
        return '';
    }
  }
}

