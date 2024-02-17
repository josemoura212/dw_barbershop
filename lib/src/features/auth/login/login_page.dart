import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/features/auth/login/login_state.dart';
import 'package:dw_barbershop/src/features/auth/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/ui/helpers/messages.dart';
import '../register/user/user_register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const nameRoute = "/auth/login";

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
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
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginVm(:login) = ref.watch(loginVmProvider.notifier);

    ref.listen(loginVmProvider, (previus, next) {
      switch (next) {
        case LoginState(status: LoginStateStatus.initial):
          break;
        case LoginState(status: LoginStateStatus.error, :final errorMessage?):
          Messages.showError(errorMessage, context);
        case LoginState(
            status: LoginStateStatus.error,
          ):
          Messages.showError("Erro ao realizar login", context);
        case LoginState(status: LoginStateStatus.admLogin):
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/home/adm", (route) => false);
          break;
        case LoginState(status: LoginStateStatus.employeeLogin):
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/home/employee", (route) => false);
          break;
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstants.backgroundChair),
              opacity: 0.2,
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageConstants.imageLogo),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            onTapOutside: (_) => context.unfocus(),
                            validator: Validatorless.multiple([
                              Validatorless.required("E-mail obrigatório"),
                              Validatorless.email("E-mail inválido"),
                            ]),
                            controller: emailEC,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: "E-mail",
                              hintText: "E-mail",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            onTapOutside: (_) => context.unfocus(),
                            validator: Validatorless.multiple([
                              Validatorless.required("Senha obrigatório"),
                              Validatorless.min(6,
                                  "Senha deve conter pelo menos 6 caracteres"),
                            ]),
                            controller: passwordEC,
                            obscureText: obscure,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "Senha",
                              hintText: "Senha",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: const TextStyle(color: Colors.black),
                              hintStyle: const TextStyle(color: Colors.black),
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
                            height: 16,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Esqueceu a senha?",
                              style: TextStyle(
                                color: ColorsConstants.brow,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(58),
                            ),
                            onPressed: () {
                              switch (formKey.currentState?.validate()) {
                                case (false || null):
                                  Messages.showError(
                                      "Campos inválidos", context);
                                  break;
                                case true:
                                  login(emailEC.text, passwordEC.text);
                              }
                            },
                            child: const Text("Acessar"),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(UserRegisterPage.nameRoute);
                          },
                          child: const Text(
                            "Criar conta",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
