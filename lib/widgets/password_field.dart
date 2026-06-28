import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/theme.dart';

/// Visibility state provider for a particular PasswordField instance.
/// Each field generates its own local provider using [StateProvider].

/// Password text field with show/hide toggle.
///
/// Uses [ConsumerStatefulWidget] to keep visibility state local.
class PasswordField extends ConsumerStatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.hintText = 'Password',
    this.labelText,
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction textInputAction;

  @override
  ConsumerState<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends ConsumerState<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofillHints: const [AutofillHints.password],
      style: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          size: 20,
          color: AppColors.textSecondary,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
            color: AppColors.textSecondary,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
          tooltip: _obscure ? 'Show password' : 'Hide password',
        ),
        constraints: const BoxConstraints(minHeight: AppSpacing.inputHeight),
      ),
    );
  }
}
