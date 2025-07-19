import 'package:flutter/material.dart';

Color getDayCellColor(
  bool isStartDate,
  bool isEndDate,
  bool isInRange,
  bool isToday,
) {
  if (isStartDate || isEndDate) {
    return Color(0xFF667eea);
  } else if (isInRange) {
    return Color(0xFF667eea).withOpacity(0.2);
  } else if (isToday) {
    return Colors.transparent;
  }
  return Colors.transparent;
}

String getSelectedRangeText({DateTime? startDate, DateTime? endDate}) {
  if (startDate != null && endDate != null) {
    return '${formatDate(startDate)} - ${formatDate(endDate)}';
  } else if (startDate != null) {
    return 'From ${formatDate(startDate)}';
  }
  return '';
}

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String formatQuickRange(DateTimeRange range) {
  return '${range.start.day}/${range.start.month} - ${range.end.day}/${range.end.month}';
}

IconData getQuickOptionIcon(String title) {
  switch (title) {
    case 'Today':
      return Icons.today;
    case 'This Week':
      return Icons.view_week;
    case 'This Month':
      return Icons.calendar_view_month;
    case 'Last 7 Days':
      return Icons.date_range;
    case 'Last 30 Days':
      return Icons.calendar_month;
    case 'Last 3 Months':
      return Icons.calendar_view_week;
    default:
      return Icons.date_range;
  }
}

DateTimeRange getTodayRange() {
  final today = DateTime.now();
  return DateTimeRange(
    start: DateTime(today.year, today.month, today.day),
    end: DateTime(today.year, today.month, today.day, 23, 59, 59),
  );
}

DateTimeRange getThisWeekRange() {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(Duration(days: 6));
  return DateTimeRange(
    start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
    end: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
  );
}

DateTimeRange getThisMonthRange() {
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0);
  return DateTimeRange(
    start: startOfMonth,
    end: DateTime(
      endOfMonth.year,
      endOfMonth.month,
      endOfMonth.day,
      23,
      59,
      59,
    ),
  );
}

DateTimeRange getLast7DaysRange() {
  final now = DateTime.now();
  final start = now.subtract(Duration(days: 6));
  return DateTimeRange(
    start: DateTime(start.year, start.month, start.day),
    end: DateTime(now.year, now.month, now.day, 23, 59, 59),
  );
}

DateTimeRange getLast30DaysRange() {
  final now = DateTime.now();
  final start = now.subtract(Duration(days: 29));
  return DateTimeRange(
    start: DateTime(start.year, start.month, start.day),
    end: DateTime(now.year, now.month, now.day, 23, 59, 59),
  );
}

DateTimeRange getLast3MonthsRange() {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month - 3, now.day);
  return DateTimeRange(
    start: start,
    end: DateTime(now.year, now.month, now.day, 23, 59, 59),
  );
}
