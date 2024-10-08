import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:toefl/models/test/test_status.dart';
import 'package:toefl/remote/local/shared_pref/test_shared_preferences.dart';
import 'package:toefl/routes/route_key.dart';

import '../../state_management/mini_test_provider.dart';

class MiniOpeningPage extends ConsumerStatefulWidget {
  const MiniOpeningPage(
      {super.key,
      required this.packetId,
      required this.isRetake,
      required this.packetName});

  final String packetId;
  final bool isRetake;
  final String packetName;

  @override
  ConsumerState<MiniOpeningPage> createState() => _OpeningLoadingPageState();
}

class _OpeningLoadingPageState extends ConsumerState<MiniOpeningPage> {
  @override
  void initState() {
    super.initState();
    _onInit();
  }

  Future<void> _onInit() async {
    final TestSharedPreference sharedPref = TestSharedPreference();
    final status = await sharedPref.getMiniStatus();

    DateTime startDate = DateTime.now();
    if (status != null) {
      startDate = DateTime.parse(status.startTime);
    } else {
      await sharedPref.saveMiniStatus(TestStatus(
          id: widget.packetId,
          startTime: DateTime.now().toIso8601String(),
          name: widget.packetName,
          resetTable: true,
          isRetake: widget.isRetake));
    }
    await ref.read(miniTestProvider.notifier).onInit();
    await Future.delayed(const Duration(seconds: 4));

    final diff = DateTime.now().difference(startDate);
    if (!mounted) {
      return;
    } else {
      Navigator.pushNamed(
        context,
        RouteKey.miniTest,
        arguments: {
          "diffInSeconds": diff.inSeconds + 4,
          "isRetake": widget.isRetake,
        },
      ).then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network(
            "https://lottie.host/c080fa2a-87c1-4aa5-bb96-084c344dcb9b/keRDXyBfpb.json"),
      ),
    );
  }
}
