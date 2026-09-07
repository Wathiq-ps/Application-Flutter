import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/config/routes/routes_names.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/images_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {


  static const double _figmaWidth = 393;
  static const double _figmaHeight = 852;
  static const double _firstLogoStartSize = 71;
  static const double _firstLogoEndSize = 132;
  static const double _firstLogoFigmaOffsetX = 0.5;
  static const double _groupLogoWidth = 178;
  static const double _groupLogoHeight = 117;

  late AnimationController _logoController;
  late AnimationController _fadeController;
  late AnimationController _backgroundController;
  late AnimationController _groupLogoController;
  late Animation<double> _logoScale;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _groupLogoScale;
  late Animation<double> _groupLogoFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScale = Tween<double>(
      begin: _firstLogoStartSize / _firstLogoEndSize,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );


    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOut,
      ),
    );
    _groupLogoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _groupLogoScale = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _groupLogoController,
        curve: Curves.easeOutBack,
      ),
    );

    _groupLogoFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _groupLogoController,
        curve: Curves.easeIn,
      ),
    );

    startAnimation();
  }
  Future<void> startAnimation() async {
    await _logoController.forward();
    await _fadeController.forward();
    await _backgroundController.forward();
    await _groupLogoController.forward();
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    context.go(
      RouteNames.onboardingScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final widthScale = screenSize.width / _figmaWidth;
    final heightScale = screenSize.height / _figmaHeight;

    final scale = widthScale < heightScale
        ? widthScale
        : heightScale;

    final firstLogoStartSize =
        _firstLogoStartSize * scale;

    final firstLogoEndSize =
        _firstLogoEndSize * scale;

    final firstLogoOffsetX =
        _firstLogoFigmaOffsetX * scale;

    final groupLogoWidth =
        _groupLogoWidth * scale;

    final groupLogoHeight =
        _groupLogoHeight * scale;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _backgroundController,
        _logoController,
        _fadeController,
        _groupLogoController,
      ]),
      builder: (context, child) {
        return Scaffold(
          body: SizedBox.expand(
            child: ColoredBox(
              color: Color.lerp(
               AppColors.white,
                AppColors.primary,
                _backgroundAnimation.value,
              )!,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: Transform.translate(
                        offset: Offset(
                          firstLogoOffsetX,
                          0,
                        ),
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Image.asset(
                            ImagePath.shakeHands,
                            width: firstLogoEndSize,
                            height: firstLogoEndSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),


                    Opacity(
                      opacity: _groupLogoFade.value,
                      child: Transform.scale(
                        scale: _groupLogoScale.value,
                        child: SizedBox(
                          width: groupLogoWidth,
                          height: groupLogoHeight,
                          child: Image.asset(
                          ImagePath.splashWathiqGroup,
                            width: groupLogoWidth,
                            height: groupLogoHeight,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    _backgroundController.dispose();
    _groupLogoController.dispose();

    super.dispose();
  }
}
