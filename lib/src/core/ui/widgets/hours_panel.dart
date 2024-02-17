// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../constants.dart';

class HoursPanel extends StatefulWidget {
  final List<int>? enableTimes;
  final int starTime;
  final int endTime;
  final ValueChanged<int> onHoursPressed;
  final bool singleSelecttion;
  const HoursPanel({
    super.key,
    this.enableTimes,
    required this.starTime,
    required this.endTime,
    required this.onHoursPressed,
  }) : singleSelecttion = false;

  const HoursPanel.singleSelection({
    super.key,
    this.enableTimes,
    required this.starTime,
    required this.endTime,
    required this.onHoursPressed,
  }) : singleSelecttion = true;

  @override
  State<HoursPanel> createState() => _HoursPanelState();
}

class _HoursPanelState extends State<HoursPanel> {
  int? lastSelection;

  @override
  Widget build(BuildContext context) {
    final HoursPanel(:singleSelecttion) = widget;
    return Column(
      children: [
        const Text(
          "Selecione os horários de atendimento",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (int i = widget.starTime; i <= widget.endTime; i++)
              TimeButton(
                enableTimes: widget.enableTimes,
                label: "${i.toString().padLeft(2, "0")}:00",
                value: i,
                onHoursPressed: (timeSelected) {
                  setState(() {
                    if (singleSelecttion) {
                      if (lastSelection == timeSelected) {
                        lastSelection = null;
                      } else {
                        lastSelection = timeSelected;
                      }
                    }
                  });
                  widget.onHoursPressed(timeSelected);
                },
                singleSelection: singleSelecttion,
                timeSelected: lastSelection,
              ),
          ],
        )
      ],
    );
  }
}

class TimeButton extends StatefulWidget {
  final List<int>? enableTimes;
  final String label;
  final int value;
  final ValueChanged<int> onHoursPressed;
  final bool singleSelection;
  final int? timeSelected;
  const TimeButton({
    Key? key,
    this.enableTimes,
    required this.label,
    required this.value,
    required this.onHoursPressed,
    required this.singleSelection,
    this.timeSelected,
  }) : super(key: key);

  @override
  State<TimeButton> createState() => _TimeButtonState();
}

class _TimeButtonState extends State<TimeButton> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final TimeButton(
      :enableTimes,
      :value,
      :label,
      :onHoursPressed,
      :singleSelection,
      :timeSelected
    ) = widget;
    if (singleSelection) {
      if (timeSelected != null) {
        if (timeSelected == value) {
          selected = true;
        } else {
          selected = false;
        }
      }
    }

    final textColor = selected ? Colors.white : ColorsConstants.grey;
    var buttonColor = selected ? ColorsConstants.brow : Colors.white;
    final buttonBorderColor =
        selected ? ColorsConstants.brow : ColorsConstants.grey;

    final disableTime = enableTimes != null && !enableTimes.contains(value);

    if (disableTime) {
      buttonColor = Colors.grey[400]!;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: disableTime
          ? null
          : () {
              onHoursPressed(value);
              setState(() {
                selected = !selected;
              });
            },
      child: Container(
        width: 64,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: buttonColor,
          border: Border.all(color: buttonBorderColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
