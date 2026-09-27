enum AuthMode { login, register  }

extension AuthModeX on AuthMode {
  String get apiValue => this == AuthMode.register ? 'register' : 'login';
}