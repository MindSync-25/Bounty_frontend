import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/bounty_colors.dart';
import '../bloc/map_poster_bloc.dart';
import '../bloc/map_poster_event.dart';

/// [PostBountySheet] — Full-screen overlay for creating a new bounty.
///
/// Slides up from the map. Validates and dispatches [SubmitNewBounty].
/// Phase 1: Uses hardcoded lat/lng. Phase 2: Uses GPS location from [location].
class PostBountySheet extends StatefulWidget {
  const PostBountySheet({super.key});

  @override
  State<PostBountySheet> createState() => _PostBountySheetState();
}

class _PostBountySheetState extends State<PostBountySheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _rewardCtrl = TextEditingController();

  String _selectedCategory = 'errand';
  Duration _expiresIn = const Duration(hours: 4);
  bool _isUrgent = false;

  static const List<_CategoryOption> _categories = [
    _CategoryOption('errand', '🛒', 'Errand'),
    _CategoryOption('delivery', '📦', 'Delivery'),
    _CategoryOption('tech', '💻', 'Tech'),
    _CategoryOption('creative', '🎨', 'Creative'),
    _CategoryOption('manual', '🔧', 'Manual'),
    _CategoryOption('other', '🎯', 'Other'),
  ];

  static const List<_ExpiryOption> _expiryOptions = [
    _ExpiryOption(Duration(hours: 1), '1 hour'),
    _ExpiryOption(Duration(hours: 4), '4 hours'),
    _ExpiryOption(Duration(hours: 12), '12 hours'),
    _ExpiryOption(Duration(hours: 24), '24 hours'),
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _rewardCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final reward = double.tryParse(_rewardCtrl.text.trim()) ?? 0;
    context.read<MapPosterBloc>().add(
          SubmitNewBounty(
            title: _titleCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            rewardCents: (reward * 100).round(),
            category: _selectedCategory,
            lat: 37.7751, // Phase 2: replace with real GPS
            lng: -122.4194,
            expiresIn: _expiresIn,
            isUrgent: _isUrgent,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BountyColors.mapOverlay,
      child: DraggableScrollableSheet(
        initialChildSize: 0.88,
        maxChildSize: 0.95,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: BountyColors.backgroundCard,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                top: BorderSide(color: BountyColors.neonCyan, width: 1.5),
                left: BorderSide(color: BountyColors.divider, width: 0.5),
                right: BorderSide(color: BountyColors.divider, width: 0.5),
              ),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  // ── Handle ─────────────────────────────────────────────────
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: BountyColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // ── Title ──────────────────────────────────────────────────
                  Row(
                    children: [
                      const Icon(Icons.add_circle_outline,
                          color: BountyColors.neonCyan),
                      const SizedBox(width: 10),
                      Text(
                        'Post a Bounty',
                        style: GoogleFonts.poppins(
                          color: BountyColors.neonCyan,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: BountyColors.textSecondary),
                        onPressed: () => context
                            .read<MapPosterBloc>()
                            .add(const DeselectBounty()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Title field ────────────────────────────────────────────
                  _Label('Bounty Title'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Pick up dry cleaning on Main St.',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),

                  const SizedBox(height: 16),

                  // ── Description ────────────────────────────────────────────
                  _Label('Details'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Describe exactly what you need...',
                      prefixIcon: Icon(Icons.description_outlined),
                      alignLabelWithHint: true,
                    ),
                    validator: (v) => (v == null || v.trim().length < 10)
                        ? 'Minimum 10 characters'
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // ── Category ───────────────────────────────────────────────
                  _Label('Category'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _categories.map((c) {
                      final selected = _selectedCategory == c.value;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = c.value),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: selected
                                ? BountyColors.glowCyan
                                : BountyColors.backgroundLayer,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? BountyColors.neonCyan
                                  : BountyColors.divider,
                              width: selected ? 1.5 : 0.5,
                            ),
                          ),
                          child: Text(
                            '${c.emoji} ${c.label}',
                            style: GoogleFonts.poppins(
                              color: selected
                                  ? BountyColors.neonCyan
                                  : BountyColors.textSecondary,
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // ── Reward ────────────────────────────────────────────────
                  _Label('Reward (USD)'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _rewardCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (v) {
                      final d = double.tryParse(v ?? '');
                      if (d == null || d <= 0) return 'Enter a valid reward';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ── Expiry ────────────────────────────────────────────────
                  _Label('Expires in'),
                  const SizedBox(height: 8),
                  Row(
                    children: _expiryOptions.map((o) {
                      final selected = _expiresIn == o.duration;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _expiresIn = o.duration),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: selected
                                  ? BountyColors.glowCyan
                                  : BountyColors.backgroundLayer,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selected
                                    ? BountyColors.neonCyan
                                    : BountyColors.divider,
                              ),
                            ),
                            child: Text(
                              o.label,
                              style: GoogleFonts.poppins(
                                color: selected
                                    ? BountyColors.neonCyan
                                    : BountyColors.textSecondary,
                                fontSize: 12,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // ── Urgent toggle ─────────────────────────────────────────
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: BountyColors.neonRed,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Mark as Urgent',
                        style: GoogleFonts.poppins(
                          color: BountyColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Switch(value: _isUrgent, onChanged: (v) => setState(() => _isUrgent = v)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Submit ────────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('👻  Post Bounty'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: BountyColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _CategoryOption {
  const _CategoryOption(this.value, this.emoji, this.label);
  final String value;
  final String emoji;
  final String label;
}

class _ExpiryOption {
  const _ExpiryOption(this.duration, this.label);
  final Duration duration;
  final String label;
}
