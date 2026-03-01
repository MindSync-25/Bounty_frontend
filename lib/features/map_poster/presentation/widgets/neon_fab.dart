import 'package:flutter/material.dart';
import '../../../../core/theme/bounty_colors.dart';

/// [NeonFab] — The signature Bounty Ghost floating action button.
///
/// Glows neon cyan. Pulses when submitting.
/// Tapping opens the "Post Bounty" bottom sheet.
class NeonFab extends StatelessWidget {
  const NeonFab({required this.onPressed, this.isSubmitting = false, super.key});

  final VoidCallback? onPressed;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: BountyColors.neonCyan.withAlpha(isSubmitting ? 100 : 60),
            blurRadius: isSubmitting ? 24 : 16,
            spreadRadius: isSubmitting ? 4 : 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: isSubmitting ? null : onPressed,
        tooltip: 'Post a Bounty',
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: BountyColors.backgroundDeep,
                  strokeWidth: 2.5,
                ),
              )
            : const Icon(Icons.add, size: 28),
      ),
    );
  }
}
