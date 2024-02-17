import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/model/schedule_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDs extends CalendarDataSource {
  AppointmentDs({required this.schedules});
  final List<ScheduleModel> schedules;
  @override
  List<dynamic>? get appointments {
    return schedules.map((e) {
      final ScheduleModel(
        date: DateTime(:year, :month, :day),
        :hour,
        :clientName,
      ) = e;

      final startTime = DateTime(year, month, day, hour, 0, 0);
      final endtime = DateTime(year, month, day, hour + 1, 0, 0);
      return Appointment(
        startTime: startTime,
        endTime: endtime,
        subject: clientName,
        color: ColorsConstants.brow,
      );
    }).toList();
  }
}
