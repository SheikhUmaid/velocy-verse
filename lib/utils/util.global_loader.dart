// lib/widgets/global_loader.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:VelocyTaxzz/providers/provider.loader.dart';

class GlobalLoader extends StatelessWidget {
  const GlobalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<LoaderProvider>().isLoading;

    if (!isLoading) return const SizedBox.shrink(); // nothing to show
    debugPrint("Loader Byuuild");
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
