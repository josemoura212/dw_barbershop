import 'dart:developer';

import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:dw_barbershop/src/core/ui/widgets/weekdays_panel.dart';
import 'package:dw_barbershop/src/features/employee/register/employee_register_state.dart';
import 'package:dw_barbershop/src/features/employee/register/employee_register_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../model/barbershop_model.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  static const nameRoute = "/employee/register";

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  var registerADM = false;
  final formKey = GlobalKey<FormState>();

  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  bool obscure = true;

  void obscurePassword() {
    setState(() {
      obscure = !obscure;
    });
  }

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeRegisterVm = ref.watch(employeeRegisterVmProvider.notifier);
    final barbershopAsyncValue = ref.watch(getMyBarbershopProvider);

    ref.listen(employeeRegisterVmProvider.select((state) => state.status),
        (_, status) {
      switch (status) {
        case EmployeeRegisterStateStatus.initial:
          break;
        case EmployeeRegisterStateStatus.success:
          Messages.showSuccess("Colaborador cadastrado com sucesso", context);
          Navigator.of(context).pop();
        case EmployeeRegisterStateStatus.error:
          Messages.showError("Erro ao registrar colaborador", context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cadastrar colaborador",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: barbershopAsyncValue.when(
        data: (BarbershopModel barbershopModel) {
          final BarbershopModel(:openingDays, :openingHours) = barbershopModel;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AvatarWidget(),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Checkbox.adaptive(
                            value: registerADM,
                            onChanged: (value) {
                              setState(() {
                                registerADM = !registerADM;
                                employeeRegisterVm.setRegisterADM(registerADM);
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              "Sou admistrador e quero me cadastrar como colaborador",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Offstage(
                        offstage: registerADM,
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            TextFormField(
                              onTapOutside: (_) => context.unfocus(),
                              controller: nameEC,
                              validator: registerADM
                                  ? null
                                  : Validatorless.required("Nome obrigatório"),
                              decoration: const InputDecoration(
                                label: Text("Nome"),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: emailEC,
                              onTapOutside: (_) => context.unfocus(),
                              validator: registerADM
                                  ? null
                                  : Validatorless.multiple([
                                      Validatorless.required(
                                          "E-mail obrigatório"),
                                      Validatorless.email("E-mail inválido"),
                                    ]),
                              decoration: const InputDecoration(
                                label: Text("E-mail"),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: passwordEC,
                              obscureText: obscure,
                              onTapOutside: (_) => context.unfocus(),
                              validator: registerADM
                                  ? null
                                  : Validatorless.multiple([
                                      Validatorless.required(
                                          "senha obrigatório"),
                                      Validatorless.min(6,
                                          "Senha deve conter pelo menos 6 caracteres"),
                                    ]),
                              decoration: InputDecoration(
                                label: const Text("Senha"),
                                suffixIcon: Visibility(
                                  visible: obscure,
                                  replacement: GestureDetector(
                                    onTap: obscurePassword,
                                    child: const Icon(Icons.visibility_off),
                                  ),
                                  child: GestureDetector(
                                    onTap: obscurePassword,
                                    child: const Icon(Icons.visibility),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      WeekdaysPanel(
                        onDayPressed: employeeRegisterVm.addOrRemoveWorkdays,
                        enableDays: openingDays,
                      ),
                      const SizedBox(height: 24),
                      HoursPanel(
                        starTime: 6,
                        endTime: 23,
                        onHoursPressed: employeeRegisterVm.addOrRemoveWorkhours,
                        enableTimes: openingHours,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56)),
                        child: const Text('CADASTRAR COLABORADOR'),
                        onPressed: () {
                          switch (formKey.currentState?.validate()) {
                            case false || null:
                              Messages.showError(
                                  "Existem campos inválidos", context);
                            case true:
                              final EmployeeRegisterState(
                                workdays: List(isNotEmpty: hasWorkDays),
                                workhours: List(isNotEmpty: hasworkhours),
                              ) = ref.watch(employeeRegisterVmProvider);

                              if (!hasWorkDays || !hasworkhours) {
                                Messages.showError(
                                    "Por favor selecione os dias das semana e horário de atendimento",
                                    context);
                                return;
                              }

                              final name = nameEC.text;
                              final email = emailEC.text;
                              final passaword = passwordEC.text;

                              employeeRegisterVm.register(
                                name: name,
                                email: email,
                                password: passaword,
                              );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        error: (Object error, StackTrace stackTrace) {
          log(
            "Erro ao carregar a página",
            error: error,
            stackTrace: stackTrace,
          );
          return const Center(
            child: Text("Erro ao carregar a página"),
          );
        },
        loading: () => const BarbershopLoader(),
      ),
    );
  }
}
