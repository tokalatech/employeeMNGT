import 'package:flutter/material.dart';

class HelpdeskPage extends StatefulWidget {
  const HelpdeskPage({super.key});

  @override
  State<HelpdeskPage> createState() => _HelpdeskPageState();
}

class _HelpdeskPageState extends State<HelpdeskPage> {
  int selectedTicketIndex = 0;

  final TextEditingController responseController =
  TextEditingController();

  final List<HelpdeskTicket> tickets = [
    HelpdeskTicket(
      id: 'TICK-1024',
      title: 'Overtime Allowance Discrepancy for July 2026',
      category: 'PAYROLL',
      date: '2026-08-05',
      status: 'IN PROGRESS',
    ),
    HelpdeskTicket(
      id: 'TICK-1025',
      title: 'Request for Secondary 4K Monitor',
      category: 'IT_HARDWARE',
      date: '2026-08-09',
      status: 'OPEN',
    ),
  ];

  String get selectedStatus =>
      tickets[selectedTicketIndex].status;

  @override
  void dispose() {
    responseController.dispose();
    super.dispose();
  }

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
                      horizontal: isMobile ? 16 : 7,
                      vertical: 0,
                    ),
                    child: Column(
                      children: [
                        _buildHeader(isMobile),
                        const SizedBox(height: 27),
                        if (isMobile)
                          _buildMobileLayout()
                        else
                          _buildDesktopLayout(),
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
        vertical: 25,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF125A6B),
            Color(0xFF103B4A),
            Color(0xFF111A2D),
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
          _buildPortalBadge(),
          const SizedBox(height: 14),
          _buildHeaderTitle(),
          const SizedBox(height: 7),
          _buildHeaderDescription(),
          const SizedBox(height: 18),
          _buildNewTicketButton(),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                _buildPortalBadge(),
                const SizedBox(height: 12),
                _buildHeaderTitle(),
                const SizedBox(height: 6),
                _buildHeaderDescription(),
              ],
            ),
          ),
          _buildNewTicketButton(),
        ],
      ),
    );
  }

  Widget _buildPortalBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF008CA9).withOpacity(.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00B5D9),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.support_agent_outlined,
            size: 16,
            color: Color(0xFF42D9FF),
          ),
          SizedBox(width: 5),
          Text(
            'Employee Support Portal',
            style: TextStyle(
              color: Color(0xFF43D8FA),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return const Text(
      'Helpdesk & Resolution Hub',
      style: TextStyle(
        color: Colors.white,
        fontSize: 27,
        fontWeight: FontWeight.w800,
        letterSpacing: -.5,
      ),
    );
  }

  Widget _buildHeaderDescription() {
    return const Text(
      'Submit payroll queries, IT hardware requests, attendance corrections, and benefits support tickets.',
      style: TextStyle(
        color: Color(0xFF9EE8F7),
        fontSize: 13,
      ),
    );
  }

  Widget _buildNewTicketButton() {
    return ElevatedButton.icon(
      onPressed: _raiseNewTicket,
      icon: const Icon(
        Icons.add,
        size: 19,
      ),
      label: const Text(
        'Raise New Support Ticket',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF08AFD5),
        foregroundColor: Colors.white,
        elevation: 5,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildDesktopLayout() {
    return SizedBox(
      height: 618,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 438,
            child: _buildTicketList(),
          ),
          const SizedBox(width: 27),
          Expanded(
            child: _buildTicketDetails(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildTicketList(),
        const SizedBox(height: 20),
        _buildTicketDetails(),
      ],
    );
  }

  // ============================================================
  // TICKET LIST
  // ============================================================

  Widget _buildTicketList() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        18,
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
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 4,
              bottom: 13,
            ),
            child: Text(
              'YOUR TICKETS (2)',
              style: TextStyle(
                color: Color(0xFF526A85),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          for (int i = 0; i < tickets.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: _buildTicketCard(i),
            ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(int index) {
    final ticket = tickets[index];
    final bool selected = selectedTicketIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        setState(() {
          selectedTicketIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(
          15,
          14,
          15,
          14,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF2FDFF)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected
                ? const Color(0xFF00B6DE)
                : const Color(0xFFE5EAF0),
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ticket.id,
                  style: const TextStyle(
                    color: Color(0xFF008CB9),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                _buildStatusBadge(ticket.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ticket.title,
              style: const TextStyle(
                color: Color(0xFF07182F),
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  ticket.category,
                  style: const TextStyle(
                    color: Color(0xFF7890A9),
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Text(
                  ticket.date,
                  style: const TextStyle(
                    color: Color(0xFF7890A9),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final bool inProgress = status == 'IN PROGRESS';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: inProgress
            ? const Color(0xFFFFF2C8)
            : const Color(0xFFFFE1E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: inProgress
              ? const Color(0xFF9C6200)
              : const Color(0xFFCE1939),
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ============================================================
  // TICKET DETAILS
  // ============================================================

  Widget _buildTicketDetails() {
    final ticket = tickets[selectedTicketIndex];

    return Container(
      width: double.infinity,
      height: 618,
      padding: const EdgeInsets.fromLTRB(
        27,
        27,
        27,
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
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailsHeader(ticket),
          const SizedBox(height: 18),
          Expanded(
            child: selectedTicketIndex == 0
                ? _buildMessages()
                : _buildEmptyMessages(),
          ),
          const SizedBox(height: 18),
          _buildResponseBox(),
        ],
      ),
    );
  }

  Widget _buildDetailsHeader(
      HelpdeskTicket ticket,
      ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        ticket.id,
                        style: const TextStyle(
                          color: Color(0xFF009CC7),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                          const Color(0xFFF1F5F9),
                          borderRadius:
                          BorderRadius.circular(4),
                        ),
                        child: Text(
                          ticket.category,
                          style: const TextStyle(
                            color: Color(0xFF637A94),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ticket.title,
                    style: const TextStyle(
                      color: Color(0xFF06182F),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Created by Alex Mercer on ${ticket.date}',
                    style: const TextStyle(
                      color: Color(0xFF7890A9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            _buildStatusDropdown(),
          ],
        ),
        const SizedBox(height: 17),
        Container(
          height: 1,
          color: const Color(0xFFE8EDF2),
        ),
      ],
    );
  }

  // ============================================================
  // STATUS DROPDOWN
  // ============================================================

  Widget _buildStatusDropdown() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Status:',
          style: TextStyle(
            color: Color(0xFF617994),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 41,
          padding: const EdgeInsets.only(left: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFDDE5EE),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedStatus,
              icon: const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                ),
              ),
              style: const TextStyle(
                color: Color(0xFF12233C),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'OPEN',
                  child: Text('OPEN'),
                ),
                DropdownMenuItem(
                  value: 'IN PROGRESS',
                  child: Text('IN PROGRESS'),
                ),
                DropdownMenuItem(
                  value: 'RESOLVED',
                  child: Text('RESOLVED'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  tickets[selectedTicketIndex].status =
                      value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MESSAGES
  // ============================================================

  Widget _buildMessages() {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildMessage(
          name: 'Alex Mercer',
          role: 'EMPLOYEE',
          time: '2026-08-05 09:30 AM',
          text:
          'Please review the weekend shift log from July 18th.',
          employee: true,
        ),
        const SizedBox(height: 14),
        _buildMessage(
          name: 'Sarah Jenkins',
          role: 'ADMIN',
          time: '2026-08-05 11:15 AM',
          text:
          'Hi Alex, we are cross-checking the attendance system logs with your manager.',
          employee: false,
        ),
      ],
    );
  }

  Widget _buildMessage({
    required String name,
    required String role,
    required String time,
    required String text,
    required bool employee,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        18,
        15,
        18,
        17,
      ),
      decoration: BoxDecoration(
        color: employee
            ? const Color(0xFFF6F8FA)
            : const Color(0xFFEFFEFF),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: employee
              ? const Color(0xFFE9EEF3)
              : const Color(0xFFB8F1F8),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 17,
                color: Color(0xFF8AA0B7),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF13233B),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 7),
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: employee
                      ? const Color(0xFFE5EAF0)
                      : const Color(0xFFDDEEF7),
                  borderRadius:
                  BorderRadius.circular(4),
                ),
                child: Text(
                  role,
                  style: const TextStyle(
                    color: Color(0xFF617994),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: const TextStyle(
                  color: Color(0xFF8499AF),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF18314E),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMessages() {
    return const Center(
      child: Text(
        'No messages yet.',
        style: TextStyle(
          color: Color(0xFF879BB0),
          fontSize: 13,
        ),
      ),
    );
  }

  // ============================================================
  // RESPONSE BOX
  // ============================================================

  Widget _buildResponseBox() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: responseController,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              hintText:
              'Type your response or update message...',
              hintStyle: const TextStyle(
                color: Color(0xFF879BB0),
                fontSize: 12,
              ),
              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: Color(0xFFDCE4ED),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: Color(0xFFDCE4ED),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: Color(0xFF0BA9D1),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 9),
        SizedBox(
          height: 43,
          child: ElevatedButton.icon(
            onPressed: _sendMessage,
            icon: const Icon(
              Icons.send_outlined,
              size: 17,
            ),
            label: const Text(
              'Send',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
              const Color(0xFF009CC6),
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 17,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  void _sendMessage() {
    final String message =
    responseController.text.trim();

    if (message.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Message sent successfully',
        ),
      ),
    );

    responseController.clear();
  }

  void _raiseNewTicket() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Raise New Support Ticket',
        ),
      ),
    );
  }
}

// ============================================================
// MODEL
// ============================================================

class HelpdeskTicket {
  final String id;
  final String title;
  final String category;
  final String date;
  String status;

  HelpdeskTicket({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.status,
  });
}