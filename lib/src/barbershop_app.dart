import 'package:asyncstate/widget/async_state_builder.dart';
import 'package:dw_barbershop/src/core/ui/barbershop_nav_global_key.dart';
import 'package:dw_barbershop/src/core/ui/barbershop_theme.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/auth/login/login_page.dart';
import 'package:dw_barbershop/src/features/employee/register/employee_register_page.dart';
import 'package:dw_barbershop/src/features/employee/schedule/employee_schedule_page.dart';
import 'package:dw_barbershop/src/features/home/adm/home_adm_page.dart';
import 'package:dw_barbershop/src/features/home/employee/home_employee_page.dart';
import 'package:dw_barbershop/src/features/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/auth/register/barbershop/barbershop_register_page.dart';
import 'features/auth/register/user/user_register_page.dart';
import 'features/schedule/schedule_page.dart';

class BarbershopApp extends StatelessWidget {
  const BarbershopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const BarbershopLoader(),
      builder: (asyncNavigatorObserver) {
        return MaterialApp(
          title: "DW BarberShop",
          theme: BarbershopTheme.themeData,
          navigatorKey: BarbershopNavGlobalKey.instance.navKey,
          debugShowCheckedModeBanner: false,
          navigatorObservers: [asyncNavigatorObserver],
          routes: {
            SplashPage.nameRoute: (_) => const SplashPage(),
            LoginPage.nameRoute: (_) => const LoginPage(),
            HomeAdmPage.nameRoute: (_) => const HomeAdmPage(),
            HomeEmployeePage.nameRoute: (_) => const HomeEmployeePage(),
            UserRegisterPage.nameRoute: (_) => const UserRegisterPage(),
            BarbershopRegisterPage.nameRoute: (_) =>
                const BarbershopRegisterPage(),
            EmployeeRegisterPage.nameRoute: (_) => const EmployeeRegisterPage(),
            SchedulePage.nameRoute: (_) => const SchedulePage(),
            EmployeeSchedulePage.nameRoute: (_) => const EmployeeSchedulePage(),
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale("pt", "BR")],
          locale: const Locale("pt", "BR"),
        );
      },
    );
  }
}
