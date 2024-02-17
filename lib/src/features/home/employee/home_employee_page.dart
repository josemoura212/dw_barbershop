import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/employee/schedule/employee_schedule_page.dart';
import 'package:dw_barbershop/src/features/home/employee/home_employee_provider.dart';
import 'package:dw_barbershop/src/features/home/widgets/home_header.dart';
import 'package:dw_barbershop/src/features/schedule/schedule_page.dart';
import 'package:dw_barbershop/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeEmployeePage extends ConsumerWidget {
  const HomeEmployeePage({super.key});
  static const nameRoute = "/home/employee";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModelAsync = ref.watch(getMeProvider);
    return Scaffold(
      body: userModelAsync.when(
        loading: () => const BarbershopLoader(),
        error: (error, stackTrace) {
          return const Center(
            child: Text("Erro ao carregar página"),
          );
        },
        data: (user) {
          final UserModel(:id, :name) = user;
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: HomeHeader.withouFilter(),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const AvatarWidget(
                        hideUploadButton: true,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: MediaQuery.sizeOf(context).width * .7,
                        height: 108,
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorsConstants.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer(
                              builder: (context, ref, child) {
                                final totalAsync = ref
                                    .watch(getTotalSchedulesTodayProvider(id));
                                return totalAsync.when(
                                  error: (error, stackTrace) {
                                    return const Center(
                                      child: Text(
                                          "Erro ao carregar total de agendamentos"),
                                    );
                                  },
                                  loading: () => const BarbershopLoader(),
                                  skipLoadingOnRefresh: false,
                                  data: (totalSchedule) {
                                    return Text(
                                      "$totalSchedule",
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        color: ColorsConstants.brow,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const Text(
                              "Hoje",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).pushNamed(
                              SchedulePage.nameRoute,
                              arguments: user);
                          ref.invalidate(getTotalSchedulesTodayProvider);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        child: const Text("AGENDAR CLIENTE"),
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              EmployeeSchedulePage.nameRoute,
                              arguments: user);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                        ),
                        child: const Text("VER AGENDA"),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
