import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/features/auth/register/barbershop/barbershop_register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import 'user_register_vm.dart';

class UserRegisterPage extends ConsumerStatefulWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  static const nameRoute = "/auth/register/user";

  @override
  ConsumerState<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends ConsumerState<UserRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  bool obscure = true;

  void obscurePassword() {
    setState(() {
      obscure = !obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userRegistervm = ref.watch(userRegisterVmProvider.notifier);

    ref.listen(userRegisterVmProvider, (_, state) {
      switch (state) {
        case UserRegisterAdmStateStatus.inital:
          break;
        case UserRegisterAdmStateStatus.success:
          Navigator.of(context).pushNamed(BarbershopRegisterPage.nameRoute);
        case UserRegisterAdmStateStatus.error:
          Messages.showError(
              "Erro ao registrar usuário administrador", context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameEC,
                  onTapOutside: (_) => context.unfocus(),
                  validator: Validatorless.required("Nome obrigatório"),
                  decoration: const InputDecoration(
                    label: Text("Nome"),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: emailEC,
                  onTapOutside: (_) => context.unfocus(),
                  validator: Validatorless.multiple([
                    Validatorless.required("E-mail obrigatório"),
                    Validatorless.email("E-mail inválido"),
                  ]),
                  decoration: const InputDecoration(
                    label: Text("E-mail"),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: passwordEC,
                  onTapOutside: (_) => context.unfocus(),
                  validator: Validatorless.multiple([
                    Validatorless.required("Senha obrigatória"),
                    Validatorless.min(
                        6, "Senha deve ter no minimo 6 caracteres")
                  ]),
                  obscureText: obscure,
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
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  obscureText: obscure,
                  onTapOutside: (_) => context.unfocus(),
                  validator: Validatorless.multiple([
                    Validatorless.required("Senha obrigatória"),
                    Validatorless.compare(passwordEC, "As senhas não conferem"),
                  ]),
                  decoration: InputDecoration(
                    label: const Text("Confirmar Senha"),
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
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56)),
                  onPressed: () {
                    switch (formKey.currentState?.validate()) {
                      case null || false:
                        Messages.showError("Formulario inválido", context);
                      case true:
                        userRegistervm.register(
                          name: nameEC.text,
                          email: emailEC.text,
                          password: passwordEC.text,
                        );
                    }
                  },
                  child: const Text("Criar conta"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
