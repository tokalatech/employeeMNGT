import 'package:flutter/material.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final List<Announcement> announcements = [
    Announcement(
      type: 'EVENT',
      title: '🎉 Annual Q3 Townhall & Employee Recognition Awards',
      description:
      'Join us on Friday, August 22nd at 3:00 PM EST for our quarterly company-wide town hall meeting. We will share strategic updates, product roadmaps, and celebrate team achievements!',
      date: '2026-08-08',
      postedBy: 'Sarah Jenkins (VP HR)',
      pinned: true,
    ),
    Announcement(
      type: 'POLICY',
      title: '⚠️ Updated Remote Work & Hybrid Office Guidelines',
      description:
      'We have updated our flexible hybrid policy. Employees are encouraged to align with department leads for key team sync days. Please review the updated handbook in the Documents section.',
      date: '2026-08-04',
      postedBy: 'HR Operations',
      pinned: false,
    ),
    Announcement(
      type: 'URGENT',
      title: '📑 Open Enrollment for Health & Dental Benefits',
      description:
      'The annual open enrollment window for healthcare benefits begins on September 1st. Please review your elected coverage and make updates before September 15th.',
      date: '2026-08-02',
      postedBy: 'Priya Patel (Finance Lead)',
      pinned: false,
    ),
  ];

  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 25),
            _buildSummaryCards(),
            const SizedBox(height: 25),
            _buildFilterBar(),
            const SizedBox(height: 20),
            _buildAnnouncementList(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade900,
            Colors.deepPurple.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 850;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerText(),
                const SizedBox(height: 20),
                _broadcastButton(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _headerText(),
              ),
              const SizedBox(width: 20),
              _broadcastButton(),
            ],
          );
        },
      ),
    );
  }

  Widget _headerText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.indigoAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.indigoAccent.withOpacity(0.40),
                ),
              ),
              child: const Text(
                'Internal Communications',
                style: TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '· ${announcements.length} Active',
              style: TextStyle(
                color: Colors.blueGrey.shade300,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Announcements',
          style: TextStyle(
            color: Colors.white,
            fontSize: 31,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Publish company updates, policies, events, and important employee communications.',
          style: TextStyle(
            color: Colors.blueGrey.shade200,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _broadcastButton() {
    return ElevatedButton.icon(
      onPressed: _showBroadcastDialog,
      icon: const Icon(
        Icons.campaign_outlined,
        color: Colors.white,
      ),
      label: const Text(
        'Broadcast New Update',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigoAccent,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 4,
      ),
    );
  }

  // ============================================================
  // SUMMARY CARDS
  // ============================================================

  Widget _buildSummaryCards() {
    final eventCount = announcements
        .where((item) => item.type == 'EVENT')
        .length;

    final policyCount = announcements
        .where((item) => item.type == 'POLICY')
        .length;

    final urgentCount = announcements
        .where((item) => item.type == 'URGENT')
        .length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 850;

        final cards = [
          _summaryCard(
            title: 'TOTAL ANNOUNCEMENTS',
            value: '${announcements.length}',
            subtitle: 'Active updates',
            icon: Icons.campaign_outlined,
            iconColor: Colors.indigo,
          ),
          _summaryCard(
            title: 'EVENTS',
            value: '$eventCount',
            subtitle: 'Company events',
            icon: Icons.event_outlined,
            iconColor: Colors.blue,
          ),
          _summaryCard(
            title: 'POLICIES',
            value: '$policyCount',
            subtitle: 'Policy updates',
            icon: Icons.policy_outlined,
            iconColor: Colors.orange,
          ),
          _summaryCard(
            title: 'URGENT',
            value: '$urgentCount',
            subtitle: 'Important notices',
            icon: Icons.warning_amber_outlined,
            iconColor: Colors.redAccent,
          ),
        ];

        if (compact) {
          return Column(
            children: cards
                .map(
                  (card) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: card,
              ),
            )
                .toList(),
          );
        }

        return Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 18),
            Expanded(child: cards[1]),
            const SizedBox(width: 18),
            Expanded(child: cards[2]),
            const SizedBox(width: 18),
            Expanded(child: cards[3]),
          ],
        );
      },
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      height: 165,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.blueGrey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Color.fromARGB(255, 13, 27, 53),
              fontSize: 29,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.blueGrey.shade400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER BAR
  // ============================================================

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.blueGrey.shade100,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchBox(),
                const SizedBox(height: 14),
                _filterButtons(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _searchBox(),
              ),
              const SizedBox(width: 18),
              _filterButtons(),
            ],
          );
        },
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.blueGrey,
          ),
          hintText: 'Search announcements...',
          contentPadding: EdgeInsets.symmetric(
            vertical: 13,
          ),
        ),
      ),
    );
  }

  Widget _filterButtons() {
    final filters = [
      'All',
      'EVENT',
      'POLICY',
      'URGENT',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filters.map((filter) {
        final selected = selectedFilter == filter;

        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              selectedFilter = filter;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.indigo
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected
                    ? Colors.indigo
                    : Colors.grey.shade300,
              ),
            ),
            child: Text(
              filter == 'All' ? 'All' : _displayType(filter),
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.blueGrey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // ANNOUNCEMENT LIST
  // ============================================================

  Widget _buildAnnouncementList() {
    final filtered = selectedFilter == 'All'
        ? announcements
        : announcements
        .where(
          (item) => item.type == selectedFilter,
    )
        .toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.blueGrey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              22,
              24,
              18,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Published Announcements',
                    style: TextStyle(
                      color: Color.fromARGB(255, 10, 28, 54),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${filtered.length} Updates',
                  style: TextStyle(
                    color: Colors.blueGrey.shade500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Colors.blueGrey.shade100,
          ),
          if (filtered.isEmpty)
            _emptyState()
          else
            ...filtered.map(
                  (announcement) =>
                  _announcementCard(announcement),
            ),
        ],
      ),
    );
  }

  Widget _announcementCard(Announcement announcement) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        0,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _typeIcon(announcement.type),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 7,
                      children: [
                        _typeBadge(announcement.type),
                        if (announcement.pinned)
                          _pinnedBadge(),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      announcement.title,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 9, 27, 52),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'pin') {
                    _togglePin(announcement);
                  } else if (value == 'delete') {
                    _confirmDelete(announcement);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'pin',
                    child: Text(
                      announcement.pinned
                          ? 'Unpin'
                          : 'Pin Announcement',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            announcement.description,
            style: TextStyle(
              color: Colors.blueGrey.shade600,
              fontSize: 13,
              height: 1.55,
            ),
          ),

          const SizedBox(height: 18),

          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _infoItem(
                Icons.calendar_today_outlined,
                announcement.date,
              ),
              _infoItem(
                Icons.person_outline,
                announcement.postedBy,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _typeIcon(String type) {
    Color color;
    IconData icon;

    switch (type) {
      case 'EVENT':
        color = Colors.blue;
        icon = Icons.event_outlined;
        break;

      case 'POLICY':
        color = Colors.orange;
        icon = Icons.policy_outlined;
        break;

      case 'URGENT':
        color = Colors.redAccent;
        icon = Icons.warning_amber_outlined;
        break;

      default:
        color = Colors.indigo;
        icon = Icons.campaign_outlined;
    }

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        icon,
        color: color,
        size: 23,
      ),
    );
  }

  Widget _typeBadge(String type) {
    Color background;
    Color foreground;

    switch (type) {
      case 'EVENT':
        background = Colors.blue.shade50;
        foreground = Colors.blue.shade700;
        break;

      case 'POLICY':
        background = Colors.orange.shade50;
        foreground = Colors.orange.shade800;
        break;

      case 'URGENT':
        background = Colors.red.shade50;
        foreground = Colors.red.shade700;
        break;

      default:
        background = Colors.indigo.shade50;
        foreground = Colors.indigo.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _displayType(type),
        style: TextStyle(
          color: foreground,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _pinnedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'PINNED',
        style: TextStyle(
          color: Colors.amber.shade800,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _infoItem(
      IconData icon,
      String text,
      ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 17,
          color: Colors.blueGrey.shade400,
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: TextStyle(
            color: Colors.blueGrey.shade500,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.campaign_outlined,
              size: 55,
              color: Colors.blueGrey.shade200,
            ),
            const SizedBox(height: 14),
            Text(
              'No announcements found',
              style: TextStyle(
                color: Colors.blueGrey.shade600,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BROADCAST NEW UPDATE
  // ============================================================

  void _showBroadcastDialog() {
    String type = 'EVENT';

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Broadcast New Update',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Announcement Type',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: type,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'EVENT',
                            child: Text('Event'),
                          ),
                          DropdownMenuItem(
                            value: 'POLICY',
                            child: Text('Policy'),
                          ),
                          DropdownMenuItem(
                            value: 'URGENT',
                            child: Text('Urgent'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              type = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Title',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText:
                          'Enter announcement title...',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descriptionController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText:
                          'Enter announcement details...',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text
                        .trim()
                        .isEmpty ||
                        descriptionController.text
                            .trim()
                            .isEmpty) {
                      return;
                    }

                    setState(() {
                      announcements.insert(
                        0,
                        Announcement(
                          type: type,
                          title:
                          titleController.text.trim(),
                          description:
                          descriptionController.text
                              .trim(),
                          date: '2026-08-17',
                          postedBy:
                          'Sarah Jenkins (VP HR)',
                          pinned: false,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'New announcement published successfully.',
                        ),
                        backgroundColor: Colors.green,
                        behavior:
                        SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.indigoAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Publish',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  void _confirmDelete(
      Announcement announcement,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Delete Announcement?',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this announcement?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blueGrey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  announcements.remove(announcement);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Announcement deleted successfully.',
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // PIN / UNPIN
  // ============================================================

  void _togglePin(
      Announcement announcement,
      ) {
    setState(() {
      announcement.pinned = !announcement.pinned;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          announcement.pinned
              ? 'Announcement pinned.'
              : 'Announcement unpinned.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _displayType(String type) {
    switch (type) {
      case 'EVENT':
        return 'Event';
      case 'POLICY':
        return 'Policy';
      case 'URGENT':
        return 'Urgent';
      default:
        return type;
    }
  }
}

// ============================================================
// ANNOUNCEMENT MODEL
// ============================================================

class Announcement {
  final String type;
  final String title;
  final String description;
  final String date;
  final String postedBy;
  bool pinned;

  Announcement({
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    required this.postedBy,
    required this.pinned,
  });
}