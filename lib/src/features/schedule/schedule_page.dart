import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/core/ui/widgets/avatar_widget.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_icon.dart';
import 'package:dw_barbershop/src/core/ui/widgets/hours_panel.dart';
import 'package:dw_barbershop/src/features/schedule/schedule_state.dart';
import 'package:dw_barbershop/src/features/schedule/schedule_vm.dart';
import 'package:dw_barbershop/src/features/schedule/widgets/schedule_calendar.dart';
import 'package:dw_barbershop/src/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  static const nameRoute = "/schedule";

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  var showCalendar = false;

  var dateFormat = DateFormat("dd/MM/yyyy");

  final clientEC = TextEditingController();
  final dateEC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    clientEC.dispose();
    dateEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ModalRoute.of(context)!.settings.arguments as UserModel;

    final scheduleVm = ref.watch(scheduleVmProvider.notifier);

    final employeeData = switch (userModel) {
      UserModelADM(:final workDays, :final workHours) => (
          workDays: workDays!,
          workHours: workHours!,
        ),
      UserModelEmployee(:final workDays, :final workHours) => (
          workDays: workDays,
          workHours: workHours,
        ),
    };

    ref.listen(scheduleVmProvider.select((state) => state.status), (_, status) {
      switch (status) {
        case ScheduleStateStatus.initial:
          break;
        case ScheduleStateStatus.success:
          Messages.showSuccess("Cliente agendado com sucesso", context);
          Navigator.of(context).pop();
        case ScheduleStateStatus.error:
          Messages.showError("Erro ao registar agendamento", context);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Agendar cliente",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Center(
            child: Column(
              children: [
                const AvatarWidget(hideUploadButton: true),
                const SizedBox(height: 24),
                Text(
                  userModel.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 37),
                TextFormField(
                  onTapOutside: (_) => context.unfocus(),
                  controller: clientEC,
                  validator: Validatorless.required("Cliente obrigatório"),
                  decoration: const InputDecoration(labelText: 'Cliente'),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  readOnly: true,
                  controller: dateEC,
                  validator:
                      Validatorless.required("Selecione a data do agendamento"),
                  onTap: () {
                    setState(() {
                      showCalendar = true;
                    });
                    context.unfocus();
                  },
                  decoration: const InputDecoration(
                    labelText: 'Selecione uma data',
                    hintText: "Selecione uma data",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    suffixIcon: Icon(
                      BarbershopIcons.calendar,
                      color: ColorsConstants.brow,
                      size: 18,
                    ),
                  ),
                ),
                Offstage(
                  offstage: !showCalendar,
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      ScheduleCalendar(
                        workDays: employeeData.workDays,
                        cancelPressed: () {
                          setState(() {
                            showCalendar = false;
                          });
                        },
                        okPressed: (DateTime value) {
                          setState(() {
                            dateEC.text = dateFormat.format(value);
                            scheduleVm.dateSelect(value);
                            showCalendar = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                HoursPanel.singleSelection(
                  starTime: 6,
                  endTime: 23,
                  onHoursPressed: scheduleVm.hourSelect,
                  enableTimes: employeeData.workHours,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    switch (formKey.currentState?.validate()) {
                      case false || null:
                        Messages.showError("Dados incomletos", context);
                      case true:
                        final hourSelected = ref.watch(scheduleVmProvider
                            .select((state) => state.scheduleHour != null));
                        if (hourSelected) {
                          scheduleVm.register(
                            userModel: userModel,
                            clientName: clientEC.text,
                          );
                        } else {
                          Messages.showError(
                              "Por favor selecione um horário de atendimento",
                              context);
                        }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56)),
                  child: const Text("AGENDAR"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
