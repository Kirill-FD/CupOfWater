import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import 'package:water_tracker/core/security/client_rate_limiter.dart';
import 'package:water_tracker/core/security/input_sanitizer.dart';
import 'package:water_tracker/core/theme/app_colors.dart';
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:water_tracker/features/auth/data/auth_repository.dart';
import 'package:water_tracker/features/auth/domain/errors/auth_repository_exception.dart';
import 'package:water_tracker/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  static final RegExp _emailRegExp = RegExp(
    r'^[A-Za-z0-9.!#$%&*+/=?^_`{|}~-]+@([A-Za-z0-9-]+\.)+[A-Za-z0-9-]{2,}$',
  );

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _showPasswordWhilePressed = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(Object error) {
    if (!mounted) {
      return;
    }
    final String message;
    if (error is AuthRepositoryException) {
      message = error.userMessage;
    } else {
      message = error.toString();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _tooManyRequestsMessage(Duration wait, BuildContext context) {
    final int sec = wait.inSeconds <= 0 ? 1 : wait.inSeconds;
    final bool ru = Localizations.localeOf(context).languageCode == 'ru';
    if (ru) {
      return 'Слишком много попыток. Повторите через $sec c.';
    }
    return 'Too many attempts. Try again in $sec s.';
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) {
      return;
    }
    final String email = InputSanitizer.normalizeEmail(_emailController.text);
    final RateLimitResult limit = ClientRateLimiter.instance.consume(
      'auth-login:$email',
      maxAttempts: 5,
      window: const Duration(minutes: 1),
    );
    if (!limit.allowed) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_tooManyRequestsMessage(limit.retryAfter, context)),
          ),
        );
      }
      return;
    }
    setState(() => _isSubmitting = true);
    final AuthRepository repo = ref.read(authRepositoryProvider);
    try {
      await repo.signIn(
        email: email,
        password: _passwordController.text,
      );
      ClientRateLimiter.instance.reset('auth-login:$email');
    } on AuthRepositoryException catch (e) {
      _showError(e);
    } on AuthException catch (e) {
      _showError(mapGotrueAuthException(e));
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _holdToRevealIcon({
    required bool shown,
    required ValueChanged<bool> onChanged,
  }) {
    return Listener(
      onPointerDown: (_) => setState(() => onChanged(true)),
      onPointerUp: (_) => setState(() => onChanged(false)),
      onPointerCancel: (_) => setState(() => onChanged(false)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(
          shown ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.water_drop,
                    size: 72,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.appName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    autofillHints: const <String>[AutofillHints.email],
                    decoration: InputDecoration(
                      labelText: l.email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      final String v = value?.trim() ?? '';
                      if (v.isEmpty) {
                        return l.enterEmail;
                      }
                      if (!_emailRegExp.hasMatch(v)) {
                        return l.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPasswordWhilePressed,
                    decoration: InputDecoration(
                      labelText: l.password,
                      suffixIcon: _holdToRevealIcon(
                        shown: _showPasswordWhilePressed,
                        onChanged: (bool value) =>
                            _showPasswordWhilePressed = value,
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onSubmit(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      final String v = value ?? '';
                      if (v.isEmpty) {
                        return l.enterPassword;
                      }
                      if (v.length < 6) {
                        return l.minPassword;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: _isSubmitting ? null : _onSubmit,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l.login),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => context.push('/register'),
                    child: Text(l.noAccount),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
