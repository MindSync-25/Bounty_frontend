import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/bounty_colors.dart';
import 'package:go_router/go_router.dart';

/// [LoginPage] — Phase 1 placeholder login screen.
///
/// Phase 2: Hook up to AuthBloc → IUserService.login() → JWT storage.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // Phase 1: Simulate login delay, then navigate to map
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppRoutes.map);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BountyColors.backgroundDeep,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                // ── Logo ─────────────────────────────────────────────────────
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: BountyColors.neonCyan, width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: BountyColors.glowCyan,
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.blur_on,
                    color: BountyColors.neonCyan,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'BOUNTY GHOST',
                  style: GoogleFonts.poppins(
                    color: BountyColors.neonCyan,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  ),
                ),
                Text(
                  'Hyper-local P2P Marketplace',
                  style: GoogleFonts.poppins(
                    color: BountyColors.textSecondary,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 52),

                // ── Fields ───────────────────────────────────────────────────
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Enter a valid email'
                      : null,
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6)
                      ? 'Minimum 6 characters'
                      : null,
                ),

                const SizedBox(height: 28),

                // ── Login button ─────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: BountyColors.backgroundDeep,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            '👻  Enter the Ghost Zone',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Skip in Phase 1 ──────────────────────────────────────────
                TextButton(
                  onPressed: () => context.go(AppRoutes.map),
                  child: Text(
                    'Skip for now (Phase 1)',
                    style: GoogleFonts.poppins(
                      color: BountyColors.textDisabled,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
