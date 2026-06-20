import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glovana_provider/generated/locale_keys.g.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentCalendarDialog extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, int> appointmentCounts;

  const AppointmentCalendarDialog({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.appointmentCounts,
  });

  @override
  State<AppointmentCalendarDialog> createState() =>
      _AppointmentCalendarDialogState();
}

class _AppointmentCalendarDialogState extends State<AppointmentCalendarDialog> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedDay;
  }

  DateTime _normalizeDay(DateTime day) {
    return DateTime(day.year, day.month, day.day);
  }

  List<Object> _eventsForDay(DateTime day) {
    final count = widget.appointmentCounts[_normalizeDay(day)] ?? 0;
    if (count <= 0) {
      return const [];
    }
    return List<Object>.generate(count, (index) => index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.all(18.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    LocaleKeys.date.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  LocaleKeys.appointments.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TableCalendar<Object>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2035, 12, 31),
              focusedDay: _focusedDay,
              locale: context.locale.languageCode,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              selectedDayPredicate: (day) {
                final selectedDay = widget.selectedDay;
                return selectedDay != null && isSameDay(day, selectedDay);
              },
              onDaySelected: (selectedDay, focusedDay) {
                Navigator.of(context).pop(_normalizeDay(selectedDay));
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: _eventsForDay,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.chevron_left_rounded,
                  size: 24.r,
                  color: theme.primaryColor,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right_rounded,
                  size: 24.r,
                  color: theme.primaryColor,
                ),
                titleTextStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.hintColor,
                ),
                weekendStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.hintColor,
                ),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                markersMaxCount: 1,
                markerSize: 7.r,
                markerDecoration: BoxDecoration(
                  color: theme.primaryColor,
                  shape: BoxShape.circle,
                ),
                markerMargin: EdgeInsets.only(top: 2.h),
                todayDecoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
                selectedDecoration: BoxDecoration(
                  color: theme.primaryColor,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: theme.secondaryHeaderColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
                defaultTextStyle: TextStyle(fontSize: 14.sp),
                weekendTextStyle: TextStyle(fontSize: 14.sp),
                outsideTextStyle: TextStyle(
                  fontSize: 13.sp,
                  color: theme.hintColor.withValues(alpha: 0.65),
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) {
                    return null;
                  }

                  return Positioned(
                    bottom: 6.h,
                    child: Container(
                      width: 7.r,
                      height: 7.r,
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor,
                          width: 1.2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
