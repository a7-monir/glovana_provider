import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_theme.dart';
import '../../../core/design/app_image.dart';

class SocialSignInButtons extends StatelessWidget {
  final VoidCallback onGoogleSignIn;
  final VoidCallback? onAppleSignIn;
  final bool isGoogleLoading, isAppleLoading;

  const SocialSignInButtons({
    super.key,
    required this.onGoogleSignIn,
    this.onAppleSignIn,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Sign-In Button
        _CircularSocialButton(
          isLoading: isGoogleLoading,
          onPressed: isGoogleLoading ? null : onGoogleSignIn,
          icon: 'google.png',
        ),

        SizedBox(width: 24.w),

        if (onAppleSignIn != null)
          Platform.isIOS && onAppleSignIn != null
              ? _CircularSocialButton(
                isLoading: isAppleLoading,
                onPressed: isAppleLoading ? null : onAppleSignIn!,
                icon: 'google.png',
              )
              : const SizedBox.shrink(),
      ],
    );
  }
}

class _CircularSocialButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String icon;
  bool isLoading;

  _CircularSocialButton({
    required this.onPressed,
    required this.icon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 57.w,
        height: 57.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F5F0), // Cream background
          shape: BoxShape.circle,
          boxShadow: [AppTheme.mainShadow],
          border: Border.all(
            color: const Color(0xFF5D2E2E).withValues(alpha: .08),
            width: 1,
          ),
        ),
        child:
            isLoading
                ? Center(
                  child: SizedBox(
                    height: 22.h,
                    width: 22.h,
                    child: CircularProgressIndicator(strokeWidth: 2.w),
                  ),
                )
                : Center(child: AppImage(icon, height: 37.h, width: 37.h)),
      ),
    );
  }
}

// Alternative version with slightly different styling
class SimpleSocialSignInButtons extends StatelessWidget {
  final VoidCallback onGoogleSignIn;
  final VoidCallback? onAppleSignIn;
  final bool isLoading;

  const SimpleSocialSignInButtons({
    super.key,
    required this.onGoogleSignIn,
    this.onAppleSignIn,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Sign-In
        _MinimalSocialButton(
          onPressed: isLoading ? null : onGoogleSignIn,
          icon: Image.asset(
            'assets/icons/google.png',
            height: 26.h,
            width: 26.w,
          ),
        ),

        SizedBox(width: 20.w),

        // Apple Sign-In
        if (onAppleSignIn != null)
          _MinimalSocialButton(
            onPressed: isLoading ? null : onAppleSignIn!,
            icon: Icon(Icons.apple, size: 26.sp, color: Colors.black87),
          ),
      ],
    );
  }
}

class _MinimalSocialButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;

  const _MinimalSocialButton({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
            spreadRadius: 0,
          ),
        ],
      ),
      child: IconButton(onPressed: onPressed, icon: icon, splashRadius: 30.r),
    );
  }
}
