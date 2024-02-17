// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_icon.dart';

class AvatarWidget extends StatelessWidget {
  final bool hideUploadButton;
  const AvatarWidget({
    Key? key,
    this.hideUploadButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 102,
      height: 102,
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstants.avatar),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Offstage(
              offstage: hideUploadButton,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 4,
                    color: ColorsConstants.brow,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  BarbershopIcons.addEmployee,
                  color: ColorsConstants.brow,
                  size: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
