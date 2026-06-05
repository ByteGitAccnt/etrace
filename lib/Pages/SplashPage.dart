import 'package:etrace/Model/UpdateStatus.dart';
import 'package:etrace/Api/AppUpdateService.dart';
import 'package:etrace/Notifiers/auth/AuthGate.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _initialize();
  }

  Future<void> _initialize() async {
    final UpdateStatus? result = await AppUpdateService().checkForUpdates();

    if (!mounted) return;

    if (result != null && result.updateAvailable) {
      _showUpdateDialog(result);
      return;
    }
    _goToNextPage();
  }

  void _showUpdateDialog(UpdateStatus result) {
    showDialog(
      context: context,
      barrierDismissible: !result.forceUpdate,

      builder: (_) {
        return AlertDialog(
          title: const Text("Update Available"),

          content: Text(
            result.forceUpdate
                ? "You must update the app to continue."
                : "A newer version is available.",
          ),

          actions: [
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(result.downloadUrl);
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              child: const Text("Update"),
            ),

            if (!result.forceUpdate)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _goToNextPage();
                },
                child: const Text("Later"),
              ),
          ],
        );
      },
    );
  }

  void _goToNextPage() {
    // login/home navigation
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthGate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
