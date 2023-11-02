import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalendarView extends StatefulWidget {
   const CustomCalendarView({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.selectEndDateChange,
    this.selectStartDateChange,
    this.minimumDate,
    this.maximumDate,
    this.durationChange,
    this.selectedStartDate,
    this.selectedEndDate
  });

  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final Function(int)? durationChange; // Add durationChange function

  final Function(DateTime, DateTime)? selectEndDateChange;
final Function(DateTime, DateTime)? selectStartDateChange;

  factory CustomCalendarView.withselectedStartDate(
      {Key? key,
      DateTime? initialStartDate,
      DateTime? initialEndDate,
      Function(DateTime, DateTime)? selectEndDateChange,   
      Function(DateTime, DateTime)? selectStartDateChange,
      DateTime? minimumDate,
      DateTime? maximumDate,
      DateTime? selectedStartDate,
      DateTime? selectedEndDate}) {
    return CustomCalendarView(
      key: key,
      initialStartDate: initialStartDate,
      initialEndDate: initialEndDate,
      selectEndDateChange: selectEndDateChange,
selectStartDateChange: selectStartDateChange,      
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      selectedStartDate: selectedStartDate,
      selectedEndDate: selectedEndDate,
    );
  }

  @override
  _CustomCalendarViewState createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends State<CustomCalendarView> {
  List<DateTime> dateList = <DateTime>[];
  DateTime currentMonthDate = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;
  String? duration;

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    if (widget.initialStartDate != null) {
      startDate = widget.initialStartDate;
    }
    if (widget.initialEndDate != null) {
      endDate = widget.initialEndDate;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
    int previousMonthDay = 0;
    if (newDate.weekday < 7) {
      previousMonthDay = newDate.weekday;
      for (int i = 1; i <= previousMonthDay; i++) {
        dateList.add(newDate.subtract(Duration(days: previousMonthDay - i)));
      }
    }
    for (int i = 0; i < (42 - previousMonthDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0)
                .add(const EdgeInsets.symmetric(vertical: 5)),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                        onTap: () {
                          setState(() {
                            currentMonthDate = DateTime(
                              currentMonthDate.year,
                              currentMonthDate.month,
                              0,
                            );
                            setListOfDate(currentMonthDate);
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat('MMMM, yyyy').format(currentMonthDate),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                        onTap: () {
                          setState(() {
                            currentMonthDate = DateTime(
                              currentMonthDate.year,
                              currentMonthDate.month + 2,
                              0,
                            );
                            setListOfDate(currentMonthDate);
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 2),
            child: Row(
              children: getDaysNameUI(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Column(
              children: getDaysNoUI(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getDaysNameUI() {
    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(Expanded(
        child: Center(
          child: Text(
            DateFormat('EEE').format(dateList[i]),
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Gilmer',
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ));
    }
    return listUI;
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 2),
                      child: Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 1,
                            bottom: 1,
                            left: isStartDateRadius(date) ? 4 : 0,
                            right: isEndDateRadius(date) ? 4 : 0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: startDate != null && endDate != null
                                  ? getIsItStartAndEndDate(date) ||
                                          getIsInRange(date)
                                      ? Theme.of(context)
                                          .colorScheme
                                          .tertiary
                                          .withOpacity(0.4)
                                      : Colors.transparent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: isStartDateRadius(date)
                                    ? const Radius.circular(24.0)
                                    : const Radius.circular(0.0),
                                topLeft: isStartDateRadius(date)
                                    ? const Radius.circular(24.0)
                                    : const Radius.circular(0.0),
                                topRight: isEndDateRadius(date)
                                    ? const Radius.circular(24.0)
                                    : const Radius.circular(0.0),
                                bottomRight: isEndDateRadius(date)
                                    ? const Radius.circular(24.0)
                                    : const Radius.circular(0.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32.0)),
                        onTap: () {
                          if (currentMonthDate.month == date.month) {
                            if (widget.minimumDate != null &&
                                widget.maximumDate != null) {
                              final DateTime newMinimumDate = DateTime(
                                widget.minimumDate!.year,
                                widget.minimumDate!.month,
                                widget.minimumDate!.day - 1,
                              );
                              final DateTime newMaximumDate = DateTime(
                                widget.maximumDate!.year,
                                widget.maximumDate!.month,
                                widget.maximumDate!.day + 1,
                              );
                              if (date.isAfter(newMinimumDate) &&
                                  date.isBefore(newMaximumDate)) {
                                onDateClick(date);
                              }
                            } else if (widget.minimumDate != null) {
                              final DateTime newMinimumDate = DateTime(
                                widget.minimumDate!.year,
                                widget.minimumDate!.month,
                                widget.minimumDate!.day - 1,
                              );
                              if (date.isAfter(newMinimumDate)) {
                                onDateClick(date);
                              }
                            } else if (widget.maximumDate != null) {
                              final DateTime newMaximumDate = DateTime(
                                widget.maximumDate!.year,
                                widget.maximumDate!.month,
                                widget.maximumDate!.day + 1,
                              );
                              if (date.isBefore(newMaximumDate)) {
                                onDateClick(date);
                              }
                            } else {
                              onDateClick(date);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: getIsItStartAndEndDate(date)
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Colors.transparent,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(32.0)),
                              border: Border.all(
                                color: getIsItStartAndEndDate(date)
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: getIsItStartAndEndDate(date)
                                  ? <BoxShadow>[
                                      BoxShadow(
                                        color: Theme.of(context).hintColor,
                                        blurRadius: 4,
                                        offset: const Offset(0, 0),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontFamily: 'Gilmer',
                                  color: getIsItStartAndEndDate(date)
                                      ? Colors.white
                                      : currentMonthDate.month == date.month
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onBackground
                                          : Theme.of(context).hintColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width > 360
                                          ? 14
                                          : 14,
                                  fontWeight: getIsItStartAndEndDate(date)
                                      ? FontWeight.w700
                                      : FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 9,
                      right: 0,
                      left: 0,
                      child: Container(
                        height: 3,
                        width: 3,
                        decoration: BoxDecoration(
                          color: DateTime.now().day == date.day &&
                                  DateTime.now().month == date.month &&
                                  DateTime.now().year == date.year
                              ? getIsInRange(date)
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.secondary
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        count += 1;
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  bool getIsInRange(DateTime date) {
    if (startDate != null && endDate != null) {
      if (date.isAfter(startDate!) && date.isBefore(endDate!)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool getIsItStartAndEndDate(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month &&
        startDate!.year == date.year) {
      return true;
    } else if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month &&
        endDate!.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  bool isStartDateRadius(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month) {
      return true;
    } else if (date.weekday == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isEndDateRadius(DateTime date) {
    if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month) {
      return true;
    } else if (date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  void onDateClick(DateTime date) {
    if (startDate == null) {
      startDate = date;
    } else if (startDate != date && endDate == null) {
      endDate = date;
    } else if (startDate!.day == date.day && startDate!.month == date.month) {
      startDate = null;
    } else if (endDate!.day == date.day && endDate!.month == date.month) {
      endDate = null;
    }
    if (startDate == null && endDate != null) {
      startDate = endDate;
      endDate = null;
    }
    if (startDate != null && endDate != null) {
      if (!endDate!.isAfter(startDate!)) {
        final DateTime d = startDate!;
        startDate = endDate;
        endDate = d;
      }
      if (date.isBefore(startDate!)) {
        startDate = date;
      }
      if (date.isAfter(endDate!)) {
        endDate = date;
      }
    }
    int duration =
        calculateDuration(startDate, endDate); // Calculate the duration
    setState(() {
      try {
        widget.selectEndDateChange!(startDate!, endDate!);
        widget.selectStartDateChange!(startDate!, endDate!);
        widget.durationChange!(duration); // Notify the duration change
      } catch (_) {}
    });
  }

  int calculateDuration(DateTime? startDate, DateTime? endDate) {
    if (startDate != null && endDate != null) {
      final difference = endDate.difference(startDate);
      return difference.inDays;
    }
    return 0; // Default value if dates are not set
  }
}
