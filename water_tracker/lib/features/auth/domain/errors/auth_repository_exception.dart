import 'package:supabase_flutter/supabase_flutter.dart';

/// Ошибки слоя [AuthRepository] (удобно показывать в SnackBar).
sealed class AuthRepositoryException implements Exception {
  const AuthRepositoryException(this.userMessage);

  final String userMessage;

  @override
  String toString() => userMessage;
}

final class AuthInvalidCredentialsFailure extends AuthRepositoryException {
  const AuthInvalidCredentialsFailure([super.userMessage = 'Неверный email или пароль']);
}

final class AuthEmailAlreadyRegisteredFailure extends AuthRepositoryException {
  const AuthEmailAlreadyRegisteredFailure([super.userMessage = 'Этот email уже зарегистрирован']);
}

final class AuthWeakPasswordFailure extends AuthRepositoryException {
  const AuthWeakPasswordFailure([super.userMessage = 'Слишком слабый пароль']);
}

final class AuthEmailNotConfirmedFailure extends AuthRepositoryException {
  const AuthEmailNotConfirmedFailure([super.userMessage = 'Подтвердите email перед входом']);
}

final class AuthRateLimitedFailure extends AuthRepositoryException {
  const AuthRateLimitedFailure([super.userMessage = 'Слишком много попыток. Попробуйте позже']);
}

final class AuthUnknownFailure extends AuthRepositoryException {
  const AuthUnknownFailure(super.userMessage, {this.code, this.statusCode});

  final String? code;
  final String? statusCode;
}

AuthRepositoryException mapGotrueAuthException(AuthException e) {
  if (e is AuthWeakPasswordException) {
    return AuthWeakPasswordFailure(e.message);
  }

  final String? code = e.code;
  final String lower = e.message.toLowerCase();

  switch (code) {
    case 'email_exists':
    case 'user_already_exists':
      return AuthEmailAlreadyRegisteredFailure(e.message);
    case 'email_not_confirmed':
      return AuthEmailNotConfirmedFailure(e.message);
    case 'weak_password':
      return AuthWeakPasswordFailure(e.message);
    case 'over_request_rate_limit':
    case 'over_email_send_rate_limit':
    case 'over_sms_send_rate_limit':
      return AuthRateLimitedFailure(e.message);
    default:
      if (lower.contains('invalid login') ||
          lower.contains('invalid email or password') ||
          code == 'invalid_credentials') {
        return AuthInvalidCredentialsFailure(e.message);
      }
      return AuthUnknownFailure(
        e.message.isNotEmpty ? e.message : 'Неизвестная ошибка авторизации',
        code: e.code,
        statusCode: e.statusCode,
      );
  }
}
