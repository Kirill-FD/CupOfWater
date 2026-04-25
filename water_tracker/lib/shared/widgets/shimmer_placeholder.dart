// Скелетоны на базе [shimmer] — для списков/карточек.

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:water_tracker/core/theme/app_colors.dart';

class ShimmerListPlaceholder extends StatelessWidget {
  const ShimmerListPlaceholder({
    super.key,
    this.tiles = 4,
  });

  final int tiles;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tiles,
      itemBuilder: (BuildContext c, int i) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: ShimmerListTileLine(),
        );
      },
    );
  }
}

class ShimmerListTileLine extends StatelessWidget {
  const ShimmerListTileLine({super.key});

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color base = dark
        ? const Color(0xFF2A2F3A)
        : const Color(0xFFECF2F7);
    final Color hi = dark ? const Color(0xFF3A4555) : Colors.white;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: hi,
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 14,
                  width: 120,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 64,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerChartBox extends StatelessWidget {
  const ShimmerChartBox({super.key, this.height = 300});
  final double height;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: dark ? const Color(0xFF2A2F3A) : const Color(0xFFECF2F7),
      highlightColor: dark ? const Color(0xFF3A4555) : Colors.white,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF2A2F3A) : const Color(0xFFECF2F7),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class ShimmerCircleStat extends StatelessWidget {
  const ShimmerCircleStat({super.key, this.diameter = 200});
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: dark ? const Color(0xFF2A2F3A) : const Color(0xFFECF2F7),
      highlightColor: dark ? const Color(0xFF3A4555) : Colors.white,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
