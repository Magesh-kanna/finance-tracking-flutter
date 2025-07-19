import 'package:flutter/material.dart';

class CustomDateRangePicker extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange? initialDateRange;

  const CustomDateRangePicker({
    Key? key,
    required this.firstDate,
    required this.lastDate,
    this.initialDateRange,
  }) : super(key: key);

  @override
  _CustomDateRangePickerState createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;
  late PageController _pageController;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialDateRange?.start;
    _endDate = widget.initialDateRange?.end;
    _currentMonth = DateTime.now();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667eea).withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 50,
            height: 5,
            margin: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Color(0xFF667eea).withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Header
          _buildHeader(),
          // Quick select options
          _buildQuickSelectOptions(),
          // Custom date selection
          Expanded(child: _buildDateSelection()),
          // Action buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF667eea).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.date_range,
              color: Color(0xFF667eea).withOpacity(0.9),
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Date Range',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF667eea),
                  ),
                ),
                if (_startDate != null || _endDate != null)
                  Text(
                    _getSelectedRangeText(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF667eea),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSelectOptions() {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildQuickOption('Today', _getTodayRange()),
          _buildQuickOption('This Week', _getThisWeekRange()),
          _buildQuickOption('This Month', _getThisMonthRange()),
          _buildQuickOption('Last 7 Days', _getLast7DaysRange()),
          _buildQuickOption('Last 30 Days', _getLast30DaysRange()),
          _buildQuickOption('Last 3 Months', _getLast3MonthsRange()),
        ],
      ),
    );
  }

  Widget _buildQuickOption(String title, DateTimeRange range) {
    bool isSelected = _startDate == range.start && _endDate == range.end;

    return Container(
      width: 110,
      margin: EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _startDate = range.start;
            _endDate = range.end;
          });
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(colors: [Color(0xFF667eea), Color(0xFF667eea)])
                : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Color(0xFF667eea) : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Color(0xFF667eea),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getQuickOptionIcon(title),
                color: isSelected ? Colors.white : Color(0xFF667eea),
                size: 24,
              ),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Color(0xFF667eea),
                ),
              ),
              SizedBox(height: 4),
              Text(
                _formatQuickRange(range),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      // child: ClipRRect(
      //   borderRadius: BorderRadius.circular(20),
      //   child: Theme(
      //     data: Theme.of(context).copyWith(
      //       colorScheme: ColorScheme.light(
      //         primary: Color(0xFF667eea),
      //         onPrimary: Colors.black,
      //         surface: Colors.white,
      //         onSurface: Color(0xFF667eea),
      //       ),
      //       textButtonTheme: TextButtonThemeData(
      //         style: TextButton.styleFrom(foregroundColor: Color(0xFF667eea)),
      //       ),
      //     ),
      //     child: CalendarDatePicker(
      //       initialDate: _startDate ?? DateTime.now(),
      //       firstDate: widget.firstDate,
      //       lastDate: widget.lastDate,
      //       onDateChanged: (date) {
      //         setState(() {
      //           if (_startDate == null ||
      //               (_startDate != null && _endDate != null)) {
      //             _startDate = date;
      //             _endDate = null;
      //           } else if (_endDate == null) {
      //             if (date.isBefore(_startDate!)) {
      //               _endDate = _startDate;
      //               _startDate = date;
      //             } else {
      //               _endDate = date;
      //             }
      //           }
      //         });
      //       },
      //     ),
      //   ),
      // ),
      child: _buildCustomCalendar(),
    );
  }

  Widget _buildCustomCalendar() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Calendar header with month navigation
          _buildCalendarHeader(currentMonth),
          SizedBox(height: 16),
          // Days of week
          _buildDaysOfWeekHeader(),
          SizedBox(height: 8),
          // Calendar grid
          _buildCalendarGrid(currentMonth),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(DateTime month) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month - 1,
              );
            });
          },
          icon: Icon(Icons.chevron_left, color: Color(0xFF667eea)),
        ),
        Text(
          '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF667eea),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _currentMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month + 1,
              );
            });
          },
          icon: Icon(Icons.chevron_right, color: Color(0xFF667eea)),
        ),
      ],
    );
  }

  Widget _buildDaysOfWeekHeader() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      children: days
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid(DateTime month) {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    // Add empty cells for days before the first day of the month
    for (int i = 0; i < firstDayWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      dayWidgets.add(_buildDayCell(date));
    }

    return Expanded(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 7,
        children: dayWidgets,
      ),
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isStartDate =
        _startDate != null &&
        date.year == _startDate!.year &&
        date.month == _startDate!.month &&
        date.day == _startDate!.day;

    final isEndDate =
        _endDate != null &&
        date.year == _endDate!.year &&
        date.month == _endDate!.month &&
        date.day == _endDate!.day;

    final isInRange =
        _startDate != null &&
        _endDate != null &&
        date.isAfter(_startDate!) &&
        date.isBefore(_endDate!);

    final isToday =
        date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;

    final isSelectable =
        !date.isBefore(widget.firstDate) && !date.isAfter(widget.lastDate);

    return GestureDetector(
      onTap: isSelectable
          ? () {
              setState(() {
                if (_startDate == null ||
                    (_startDate != null && _endDate != null)) {
                  _startDate = date;
                  _endDate = null;
                } else if (_endDate == null) {
                  if (date.isBefore(_startDate!)) {
                    _endDate = _startDate;
                    _startDate = date;
                  } else {
                    _endDate = date;
                  }
                }
              });
            }
          : null,
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _getDayCellColor(isStartDate, isEndDate, isInRange, isToday),
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isStartDate && !isEndDate
              ? Border.all(color: Color(0xFF667eea), width: 1.5)
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: _getDayTextColor(
                isStartDate,
                isEndDate,
                isInRange,
                isSelectable,
              ),
              fontWeight: (isStartDate || isEndDate)
                  ? FontWeight.bold
                  : isToday
                  ? FontWeight.w600
                  : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Color _getDayCellColor(
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

  Color _getDayTextColor(
    bool isStartDate,
    bool isEndDate,
    bool isInRange,
    bool isSelectable,
  ) {
    if (isStartDate || isEndDate) {
      return Colors.white;
    } else if (isInRange) {
      return Color(0xFF667eea);
    } else if (!isSelectable) {
      return Colors.grey.shade400;
    }
    return Colors.grey.shade700;
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: (_startDate != null && _endDate != null)
                  ? () {
                      Navigator.pop(
                        context,
                        DateTimeRange(start: _startDate!, end: _endDate!),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF667eea),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Apply',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSelectedRangeText() {
    if (_startDate != null && _endDate != null) {
      return '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}';
    } else if (_startDate != null) {
      return 'From ${_formatDate(_startDate!)}';
    }
    return '';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatQuickRange(DateTimeRange range) {
    return '${range.start.day}/${range.start.month} - ${range.end.day}/${range.end.month}';
  }

  IconData _getQuickOptionIcon(String title) {
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

  DateTimeRange _getTodayRange() {
    final today = DateTime.now();
    return DateTimeRange(
      start: DateTime(today.year, today.month, today.day),
      end: DateTime(today.year, today.month, today.day, 23, 59, 59),
    );
  }

  DateTimeRange _getThisWeekRange() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    return DateTimeRange(
      start: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      end: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59),
    );
  }

  DateTimeRange _getThisMonthRange() {
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

  DateTimeRange _getLast7DaysRange() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: 6));
    return DateTimeRange(
      start: DateTime(start.year, start.month, start.day),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  DateTimeRange _getLast30DaysRange() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: 29));
    return DateTimeRange(
      start: DateTime(start.year, start.month, start.day),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  DateTimeRange _getLast3MonthsRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 3, now.day);
    return DateTimeRange(
      start: start,
      end: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }
}
