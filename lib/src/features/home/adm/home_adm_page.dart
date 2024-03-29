import 'dart:developer';

import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_icon.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/employee/register/employee_register_page.dart';
import 'package:dw_barbershop/src/features/home/adm/home_adm_vm.dart';
import 'package:dw_barbershop/src/features/home/adm/widgets/home_employee_tile.dart';
import 'package:dw_barbershop/src/features/home/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/home_adm_state.dart';

class HomeAdmPage extends ConsumerWidget {
  const HomeAdmPage({super.key});

  static const nameRoute = "/home/adm";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeAdmVmProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: ColorsConstants.brow,
        onPressed: () async {
          await Navigator.of(context).pushNamed(EmployeeRegisterPage.nameRoute);
          ref.invalidate(getMeProvider);
          ref.invalidate(homeAdmVmProvider);
        },
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 12,
          child: Icon(
            BarbershopIcons.addEmployee,
            color: ColorsConstants.brow,
          ),
        ),
      ),
      body: homeState.when(data: (HomeAdmState data) {
        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: HomeHeader(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    HomeEmployeeTile(employee: data.employees[index]),
                childCount: data.employees.length,
              ),
            ),
          ],
        );
      }, error: (Object error, StackTrace stackTrace) {
        log(
          "Erro ao carregar colaboradores",
          error: error,
          stackTrace: stackTrace,
        );
        return const Center(
          child: Text("Erro ao carregar página"),
        );
      }, loading: () {
        return const BarbershopLoader();
      }),
    );
  }
}
