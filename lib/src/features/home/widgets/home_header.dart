import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_loader.dart';
import 'package:dw_barbershop/src/features/home/adm/home_adm_vm.dart';
import 'package:flutter/material.dart';

import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  final bool showFilter;
  const HomeHeader({super.key}) : showFilter = true;

  const HomeHeader.withouFilter({super.key}) : showFilter = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barbershop = ref.watch(getMyBarbershopProvider);
    return Container(
      padding: const EdgeInsets.all(24),
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage(ImageConstants.backgroundChair),
          fit: BoxFit.cover,
          opacity: .5,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          barbershop.maybeWhen(
            orElse: () {
              return const Center(
                child: BarbershopLoader(),
              );
            },
            data: (barbershopData) {
              return Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xffbdbdbd),
                    child: SizedBox.shrink(),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      barbershopData.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "editar",
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorsConstants.brow,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ref.read(homeAdmVmProvider.notifier).logout();
                    },
                    icon: const Icon(
                      BarbershopIcons.exit,
                      color: ColorsConstants.brow,
                      size: 32,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            "Bem Vindo",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Agende um cliente",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 40,
            ),
          ),
          Offstage(
            offstage: !showFilter,
            child: const SizedBox(height: 24),
          ),
          Offstage(
            offstage: !showFilter,
            child: TextFormField(
              decoration: const InputDecoration(
                  label: Text("Buscar colaborador"),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 24.0),
                    child: Icon(
                      BarbershopIcons.search,
                      color: ColorsConstants.brow,
                      size: 26,
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
