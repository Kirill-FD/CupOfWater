import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:water_tracker/core/legal/legal_urls.dart';
import 'package:water_tracker/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Политика конфиденциальности: встроенная страница по публичному URL + открытие во внешнем браузере.
class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(LegalUrls.privacyPolicy);
  }

  Future<void> _openInExternalBrowser(BuildContext context) async {
    final AppLocalizations l = AppLocalizations.of(context);
    final bool ok = await launchUrl(
      LegalUrls.privacyPolicy,
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.privacyOpenFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.privacy),
        actions: <Widget>[
          IconButton(
            tooltip: 'Open in browser',
            icon: const Icon(Icons.open_in_new),
            onPressed: () => unawaited(_openInExternalBrowser(context)),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
