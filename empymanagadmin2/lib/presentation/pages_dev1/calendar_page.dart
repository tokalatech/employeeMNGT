import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String selectedFilter = 'ALL';

  final List<String> filters = [
    'ALL',
    'HOLIDAY',
    'LEAVE',
    'EVENT',
  ];

  // August 2026 events shown in the screenshot.
  final Map<int, List<CalendarEvent>> events = {
    5: [
      CalendarEvent(
        icon: '🤒',
        title: 'Emily (SICK)',
        type: EventType.leave,
      ),
    ],
    6: [
      CalendarEvent(
        icon: '🤒',
        title: 'Emily (SICK)',
        type: EventType.leave,
      ),
    ],
    10: [
      CalendarEvent(
        icon: '🌈',
        title: 'Sophia (PAID)',
        type: EventType.leave,
      ),
      CalendarEvent(
        icon: '🎂',
        title: "Sophia's Birthday",
        type: EventType.event,
      ),
    ],
    11: [
      CalendarEvent(
        icon: '🌈',
        title: 'Sophia (PAID)',
        type: EventType.leave,
      ),
    ],
    12: [
      CalendarEvent(
        icon: '🌈',
        title: 'Sophia (PAID)',
        type: EventType.leave,
      ),
    ],
    13: [
      CalendarEvent(
        icon: '🌈',
        title: 'Sophia (PAID)',
        type: EventType.leave,
      ),
    ],
    14: [
      CalendarEvent(
        icon: '🌈',
        title: 'Sophia (PAID)',
        type: EventType.leave,
      ),
    ],
    15: [
      CalendarEvent(
        icon: '🇮🇳',
        title: 'Independence Day',
        type: EventType.holiday,
      ),
      CalendarEvent(
        icon: '🇮🇳',
        title: 'IN Independence Day',
        type: EventType.holiday,
      ),
    ],
    22: [
      CalendarEvent(
        icon: '📢',
        title: 'Q3 All-Hands Townhall',
        type: EventType.event,
      ),
    ],
    31: [
      CalendarEvent(
        icon: '👜',
        title: 'Monthly Payroll Run',
        type: EventType.payroll,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 850;

            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1370,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 7,
                    ),
                    child: Column(
                      children: [
                        _buildHeader(isMobile),
                        const SizedBox(height: 27),
                        _buildCalendarContainer(isMobile),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 27,
        vertical: isMobile ? 22 : 27,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF075B50),
            Color(0xFF104E52),
            Color(0xFF11182F),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(17),
          bottomRight: Radius.circular(17),
        ),
      ),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderBadge(),
          const SizedBox(height: 14),
          _buildHeaderTitle(),
          const SizedBox(height: 6),
          _buildHeaderDescription(),
          const SizedBox(height: 18),
          _buildFilterButtons(true),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _buildHeaderBadge(),
                const SizedBox(height: 13),
                const Text(
                  'August 2026',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Centralized schedule tracking holidays, approved leaves, payroll processing deadlines, birthdays, and all-hands townhalls.',
                  style: TextStyle(
                    color: Color(0xFFB6D6D4),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          _buildFilterButtons(false),
        ],
      ),
    );
  }

  Widget _buildHeaderBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF00765F).withOpacity(.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF009B79),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            color: Color(0xFF52E4BA),
            size: 15,
          ),
          SizedBox(width: 7),
          Text(
            'Company Master Calendar',
            style: TextStyle(
              color: Color(0xFF51E5BB),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return const Text(
      'August 2026',
      style: TextStyle(
        color: Colors.white,
        fontSize: 27,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildHeaderDescription() {
    return const Text(
      'Centralized schedule tracking holidays, approved leaves, payroll processing deadlines, birthdays, and all-hands townhalls.',
      style: TextStyle(
        color: Color(0xFFB6D6D4),
        fontSize: 13,
        height: 1.4,
      ),
    );
  }

  // ============================================================
  // FILTER BUTTONS
  // ============================================================

  Widget _buildFilterButtons(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF273247),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFF485469),
        ),
      ),
      child: Row(
        mainAxisSize:
        isMobile ? MainAxisSize.max : MainAxisSize.min,
        children: filters.map((filter) {
          final bool selected = selectedFilter == filter;

          return Expanded(
            flex: isMobile ? 1 : 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilter = filter;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF00AF79)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  filter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(0xFFD6DDE8),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // CALENDAR CONTAINER
  // ============================================================

  Widget _buildCalendarContainer(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isMobile ? 12 : 27,
        25,
        isMobile ? 12 : 27,
        27,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFDCE3EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isMobile
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 1080,
          child: _buildCalendar(),
        ),
      )
          : _buildCalendar(),
    );
  }

  // ============================================================
  // CALENDAR
  // ============================================================

  Widget _buildCalendar() {
    const List<String> weekdays = [
      'SUN',
      'MON',
      'TUE',
      'WED',
      'THU',
      'FRI',
      'SAT',
    ];

    final List<int?> days = _buildAugustDays();

    return Column(
      children: [
        // Weekday names
        Row(
          children: weekdays.map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    color: Color(0xFF8294AD),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 13),

        // Calendar rows
        ...List.generate(5, (rowIndex) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: rowIndex == 4 ? 0 : 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(7, (columnIndex) {
                final int index =
                    rowIndex * 7 + columnIndex;

                final int? day =
                index < days.length ? days[index] : null;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: columnIndex == 6 ? 0 : 8,
                    ),
                    child: _buildDayCell(day),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }

  // ============================================================
  // BUILD AUGUST 2026
  // ============================================================

  List<int?> _buildAugustDays() {
    // August 1, 2026 is Saturday.
    final List<int?> days = [];

    // Empty cells before August 1.
    days.addAll([
      null,
      null,
      null,
      null,
      null,
      null,
    ]);

    // August 1 - 31.
    for (int day = 1; day <= 31; day++) {
      days.add(day);
    }

    return days;
  }

  // ============================================================
  // DAY CELL
  // ============================================================

  Widget _buildDayCell(int? day) {
    if (day == null) {
      return Container(
        height: 113,
        decoration: BoxDecoration(
          color: const Color(0xFFFBFCFD),
          borderRadius: BorderRadius.circular(13),
        ),
      );
    }

    final bool isToday = day == 12;

    final List<CalendarEvent> visibleEvents =
    _getVisibleEvents(day);

    return Container(
      height: 113,
      padding: const EdgeInsets.fromLTRB(
        9,
        9,
        8,
        7,
      ),
      decoration: BoxDecoration(
        color: isToday
            ? const Color(0xFFF9FFFC)
            : Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: isToday
              ? const Color(0xFF00B886)
              : const Color(0xFFE5EBF1),
          width: isToday ? 1.5 : 1,
        ),
        boxShadow: isToday
            ? [
          BoxShadow(
            color: const Color(0xFF00B886)
                .withOpacity(.10),
            blurRadius: 4,
          ),
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // Day number
          Row(
            children: [
              if (isToday)
                Container(
                  width: 33,
                  height: 29,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A875),
                    borderRadius:
                    BorderRadius.circular(13),
                  ),
                  child: const Text(
                    '12',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
              else
                Text(
                  '$day',
                  style: const TextStyle(
                    color: Color(0xFF173250),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              if (isToday) ...[
                const Spacer(),
                const Text(
                  'TODAY',
                  style: TextStyle(
                    color: Color(0xFF009E76),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 7),

          // Events
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: visibleEvents
                    .map(
                      (event) =>
                      _buildEvent(event),
                )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EVENTS
  // ============================================================

  List<CalendarEvent> _getVisibleEvents(int day) {
    final dayEvents = events[day] ?? [];

    if (selectedFilter == 'ALL') {
      return dayEvents;
    }

    return dayEvents.where((event) {
      switch (selectedFilter) {
        case 'HOLIDAY':
          return event.type == EventType.holiday;

        case 'LEAVE':
          return event.type == EventType.leave;

        case 'EVENT':
          return event.type == EventType.event ||
              event.type == EventType.payroll;

        default:
          return true;
      }
    }).toList();
  }

  Widget _buildEvent(CalendarEvent event) {
    Color backgroundColor;
    Color textColor;

    switch (event.type) {
      case EventType.leave:
        backgroundColor = const Color(0xFFDDE4FF);
        textColor = const Color(0xFF3B48A7);
        break;

      case EventType.holiday:
        backgroundColor = const Color(0xFFFFDFE3);
        textColor = const Color(0xFFC93650);
        break;

      case EventType.event:
        backgroundColor = const Color(0xFFC9F5DF);
        textColor = const Color(0xFF087B58);
        break;

      case EventType.payroll:
        backgroundColor = const Color(0xFFFFEFC4);
        textColor = const Color(0xFFB86600);
        break;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${event.icon} ${event.title}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ================================================================
// EVENT MODEL
// ================================================================

enum EventType {
  holiday,
  leave,
  event,
  payroll,
}

class CalendarEvent {
  final String icon;
  final String title;
  final EventType type;

  const CalendarEvent({
    required this.icon,
    required this.title,
    required this.type,
  });
}