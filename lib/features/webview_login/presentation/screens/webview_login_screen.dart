import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:defindia3/core/constants/app_colors.dart';
import 'package:defindia3/features/credentials/domain/entities/credential_entity.dart';
import 'package:defindia3/features/webview_login/domain/entities/site_config_entity.dart';

class WebviewLoginArgs {
  final CredentialEntity credential;
  final String username;
  final String password;
  final SiteConfigEntity? config;

  WebviewLoginArgs({
    required this.credential,
    required this.username,
    required this.password,
    this.config,
  });
}

class WebviewLoginScreen extends StatefulWidget {
  final WebviewLoginArgs args;

  const WebviewLoginScreen({
    super.key,
    required this.args,
  });

  @override
  State<WebviewLoginScreen> createState() => _WebviewLoginScreenState();
}

class _WebviewLoginScreenState extends State<WebviewLoginScreen> {
  InAppWebViewController? _controller;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    final String? rawUrl =
        widget.args.credential.siteUrl ?? widget.args.config?.url;
    final uri = rawUrl != null && rawUrl.isNotEmpty
        ? Uri.tryParse(rawUrl)
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.args.credential.siteName),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller?.reload();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_progress < 1.0)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: AppColors.border,
              color: AppColors.primary,
              minHeight: 2,
            ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: uri != null
                  ? URLRequest(url: WebUri.uri(uri))
                  : null,
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useOnLoadResource: true,
              ),
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              onLoadStop: (controller, url) async {
                // Thoda delay taaki DOM / React form fully ready ho jaye
                await Future.delayed(const Duration(milliseconds: 800));
                await _injectCredentials(controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _injectCredentials(InAppWebViewController controller) async {
    final u = widget.args.username.replaceAll('"', '\\"');
    final p = widget.args.password.replaceAll('"', '\\"');

    // Pehle config ka selector, warna Netflix-type generic selectors
    final userSelector =
        widget.args.config?.usernameSelector ??
            'input[name="userLoginId"], input[type="email"], input[name="email"], input[type="text"]';
    final passSelector =
        widget.args.config?.passwordSelector ??
            'input[name="password"], input[type="password"]';

    final js = '''
      (function() {
        try {
          console.log('DEF autofill script start');

          function setReactInputValue(input, value) {
            if (!input) return;
            var lastValue = input.value;
            input.value = value;

            // React 16/17+ ke liye value tracker update
            var tracker = input._valueTracker;
            if (tracker) {
              tracker.setValue(lastValue);
            }

            input.dispatchEvent(new Event('input', { bubbles: true }));
            input.dispatchEvent(new Event('change', { bubbles: true }));
          }

          var userInput = document.querySelector('$userSelector');
          var passInput = document.querySelector('$passSelector');

          console.log('DEF autofill: userInput=' + userInput + ', passInput=' + passInput);

          if (userInput) {
            setReactInputValue(userInput, "$u");
          }

          if (passInput) {
            setReactInputValue(passInput, "$p");
          }

          if (passInput) {
            passInput.focus();
          } else if (userInput) {
            userInput.focus();
          }

          console.log('DEF autofill script done');
        } catch (e) {
          console.log('DEF autofill error: ' + e);
        }
      })();
    ''';

    await controller.evaluateJavascript(source: js);
  }
}
