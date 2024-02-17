import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
enum ScheduleStateStatus { initial, success, error }

class ScheduleState {
  final ScheduleStateStatus status;
  final int? scheduleHour;
  final DateTime? scheduleDate;

  ScheduleState.inital() : this(status: ScheduleStateStatus.initial);

  ScheduleState({required this.status, this.scheduleHour, this.scheduleDate});

  ScheduleState copyWith(
      {ScheduleStateStatus? state,
      ValueGetter<int?>? scheduleHour,
      ValueGetter<DateTime?>? scheduleDate}) {
    return ScheduleState(
        status: state ?? status,
        scheduleHour: scheduleHour != null ? scheduleHour() : this.scheduleHour,
        scheduleDate:
            scheduleDate != null ? scheduleDate() : this.scheduleDate);
  }
}
