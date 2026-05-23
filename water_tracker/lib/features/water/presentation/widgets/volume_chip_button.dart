import 'package:flutter/material.dart';

import 'package:water_tracker/core/theme/app_colors.dart';

/// Кнопка быстрого объёма по макету (VolumeChip).
class VolumeChipButton extends StatelessWidget {
  const VolumeChipButton({
    super.key,
    required this.ml,
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  final int ml;
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool dark = theme.brightness == Brightness.dark;

    final BoxDecoration deco = active
        ? const BoxDecoration(
            gradient: AppColors.waterGradient,
            borderRadius: BorderRadius.all(Radius.circular(18)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0x332890D1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          )
        : BoxDecoration(
            color: dark
                ? Colors.white.withValues(alpha: 0.06)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
          );

    final Color fg = active ? Colors.white : theme.colorScheme.onSurface;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Ink(
            decoration: deco,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(icon, size: 22, color: fg),
                  const SizedBox(height: 6),
                  Text(
                    '$ml мл',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
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
