// Lottie-оверлей капли на ~600 мс при добавлении воды.

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:water_tracker/core/theme/app_colors.dart';

const Duration kWaterDropOverlayDuration = Duration(milliseconds: 600);

void showWaterDropOverlay(NavigatorState nav) {
  if (!nav.mounted) {
    return;
  }
  final OverlayState? overlay = nav.overlay;
  if (overlay == null) {
    return;
  }
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (BuildContext context) {
      return IgnorePointer(
        child: Material(
          color: Colors.black12,
          child: Center(
            child: Lottie.asset(
              'assets/animations/drop.json',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
              repeat: false,
              errorBuilder: (
                BuildContext c,
                Object e,
                StackTrace? s,
              ) {
                return const Icon(
                  Icons.water_drop,
                  size: 120,
                  color: AppColors.primary,
                );
              },
            ),
          ),
        ),
      );
    },
  );
  overlay.insert(entry);
  Future<void>.delayed(kWaterDropOverlayDuration, () {
    entry.remove();
  });
}
