import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes_app/features/components/auth/providers/auth_provider.dart';
import 'package:notes_app/init/lang/locale_keys.g.dart';
import 'package:provider/provider.dart';

class GoogleSignInButton extends StatelessWidget {
  final AuthProvider authProvider;
  final Function(AuthProvider) handleGoogleSignIn;

  const GoogleSignInButton({
    super.key,
    required this.authProvider,
    required this.handleGoogleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return IconButton(
      onPressed: () => handleGoogleSignIn(authProvider),
      icon: SvgPicture.asset(
        'assets/icons/google.svg',
        width: 22,
        height: 22,
      ),
      tooltip: LocaleKeys.auth_sign_in_google.tr(),
    );
  }
}
