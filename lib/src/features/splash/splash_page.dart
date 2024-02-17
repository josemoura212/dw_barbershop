import 'dart:async';
import 'dart:developer';

import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/features/auth/login/login_page.dart';
import 'package:dw_barbershop/src/features/home/adm/home_adm_page.dart';
import 'package:dw_barbershop/src/features/splash/splash_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const nameRoute = "/";

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  var _scale = 10.0;
  var _animationOpacityLogo = 0.0;

  double get _logoAnimationWidth => 100 * _scale;
  double get _logoAnimationHeight => 120 * _scale;

  var endAnimation = false;
  Timer? redirectTime;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animationOpacityLogo = 1.0;
        _scale = 1.0;
      });
    });
    super.initState();
  }

  void _redirect(String routeName) {
    if (!endAnimation) {
      redirectTime?.cancel();
      redirectTime = Timer(const Duration(milliseconds: 300), () {
        _redirect(routeName);
      });
    } else {
      redirectTime?.cancel();
      switch (routeName) {
        case LoginPage.nameRoute:
          Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              settings: const RouteSettings(name: LoginPage.nameRoute),
              pageBuilder: (
                context,
                animation,
                secondaryAnimation,
              ) {
                return const LoginPage();
              },
              transitionsBuilder: (
                _,
                animation,
                __,
                child,
              ) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
            (route) => false,
          );
        case _:
          Navigator.of(context)
              .pushNamedAndRemoveUntil(routeName, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashVmProvider, (_, state) {
      state.whenOrNull(
        error: (error, stackTrace) {
          log("Erro ao validaro login", error: error, stackTrace: stackTrace);
          Messages.showError("Erro ao validar o login", context);
          _redirect(LoginPage.nameRoute);
        },
        data: (data) {
          switch (data) {
            case SplashState.loggedADM:
              _redirect(HomeAdmPage.nameRoute);
            case SplashState.loggedEployee:
              _redirect("/home/employee");
            case _:
              _redirect(LoginPage.nameRoute);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstants.backgroundChair),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 3),
            curve: Curves.easeIn,
            opacity: _animationOpacityLogo,
            onEnd: () {
              setState(() {
                endAnimation = true;
              });
            },
            child: AnimatedContainer(
              width: _logoAnimationWidth,
              height: _logoAnimationHeight,
              duration: const Duration(seconds: 3),
              curve: Curves.linearToEaseOut,
              child: Image.asset(
                ImageConstants.imageLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
