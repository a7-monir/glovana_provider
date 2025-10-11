import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/app_theme.dart';
import '../core/design/app_image.dart';
import '../core/logic/cache_helper.dart';
import '../core/logic/helper_methods.dart';
import 'auth/login/view.dart';
import 'home_nav/view.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _bgController;
  late Animation<Color?> _bgColor;

  bool _moveToRight = false;
  bool _moveBack = false;
  bool _showText = false;
  bool _showShapes = false;

  @override
  void initState() {
    super.initState();

    // Background color animation
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _bgColor = ColorTween(
      begin: AppTheme.primary, // dark red
      end: AppTheme.bgLightColor, // splash background
    ).animate(_bgController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSequence();
    });
  }

  Future<void> _startSequence() async {
    // Step 0: Start background transition
    _bgController.forward();

    // Step 1: Move logo to right edge
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _moveToRight = true);

    // Step 2: Move back to left beside text
    await Future.delayed(const Duration(milliseconds: 2500));
    setState(() => _moveBack = true);

    // Step 3: Show text
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _showText = true);

    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _showShapes = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      CacheHelper.isAuthed ?

      navigateTo(HomeNavView(),keepHistory: false)
          : navigateTo(LoginView(),keepHistory: false);
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _bgColor.value,
          body: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedOpacity(
                opacity: _showShapes ? 1 : 0,
                duration: const Duration(seconds: 1),
                child: Image.asset("assets/images/splash_bg.png", fit: BoxFit.cover),
              ),
              // Background shapes
              // Positioned.fill(
              //   child: Image.asset(
              //     "assets/images/splash_bg.png",
              //     fit: BoxFit.cover,
              //   ),
              // ),

              // Foreground animation
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Text (hidden first, fades in later)
                    Container(
                      width: screenWidth,

                      child: Padding(
                        padding: EdgeInsets.only(left: 70.w),
                        child: AnimatedOpacity(
                          opacity: _showText ? 1 : 0,
                          duration: const Duration(milliseconds: 800),
                          child: AppImage(
                            "glovana_text.png", // exported text-only image
                            height: 64.h,
                            width: 254.w,
                          ),
                        ),
                      ),
                    ),

                    // Logo animation
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeInOut,
                      left:
                          !_moveToRight
                              ? screenWidth / 2 -
                                  35
                                      .w // center
                              : !_moveBack
                              ? screenWidth -
                                  80
                                      .w // full right
                              : screenWidth / 2 - 170.w, // beside text
                      child: Image.asset(
                        "assets/images/logo.png", // exported logo only
                        width: 67.h,
                        height: 67.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
