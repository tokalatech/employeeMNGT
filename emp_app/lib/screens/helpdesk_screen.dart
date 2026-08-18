import 'package:flutter/material.dart';

import '../models/helpdesk_model.dart';
import '../services/helpdesk_service.dart';
import 'ticket_details_screen.dart';

class HelpdeskScreen extends StatelessWidget {
  const HelpdeskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = HelpdeskService();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateTicketDialog(context, service);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Ticket'),
      ),
      body: StreamBuilder<List<HelpdeskTicket>>(
        stream: service.watchMyTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Failed to load tickets\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final tickets = snapshot.data ?? <HelpdeskTicket>[];

          if (tickets.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.support_agent_outlined,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No support tickets',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create a ticket if you need help from HR or support.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              100,
            ),
            itemCount: tickets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final ticket = tickets[index];

              return _TicketCard(
                ticket: ticket,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TicketDetailsScreen(
                        ticketId: ticket.id,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showCreateTicketDialog(
      BuildContext context,
      HelpdeskService service,
      ) async {
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();

    HelpdeskCategory category = HelpdeskCategory.itSupport;
    HelpdeskPriority priority = HelpdeskPriority.medium;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Support Ticket'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        hintText: 'Enter ticket subject',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<HelpdeskCategory>(
                      value: category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: HelpdeskCategory.values.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            helpdeskCategoryToString(item),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            category = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<HelpdeskPriority>(
                      value: priority,
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      items: HelpdeskPriority.values.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            helpdeskPriorityToString(item),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            priority = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Describe your issue',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final subject = subjectController.text.trim();
                    final description =
                    descriptionController.text.trim();

                    if (subject.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter a subject.',
                          ),
                        ),
                      );
                      return;
                    }

                    if (description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter a description.',
                          ),
                        ),
                      );
                      return;
                    }

                    final ticket = HelpdeskTicket(
                      id: '',
                      ticketNumber: '',
                      subject: subject,
                      category: category,
                      priority: priority,
                      status: HelpdeskStatus.open,
                      createdAt: DateTime.now().toIso8601String(),
                      description: description,
                      messages: const [],
                    );

                    try {
                      await service.createTicket(ticket);

                      if (!dialogContext.mounted) return;

                      Navigator.pop(dialogContext);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Support ticket created successfully.',
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!dialogContext.mounted) return;

                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to create ticket: $e',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    subjectController.dispose();
    descriptionController.dispose();
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.ticket,
    required this.onTap,
  });

  final HelpdeskTicket ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.ticketNumber,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  _StatusChip(
                    status: ticket.status,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ticket.subject,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                ticket.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _SmallInfo(
                    icon: Icons.category_outlined,
                    text: helpdeskCategoryToString(
                      ticket.category,
                    ),
                  ),
                  const Spacer(),
                  _SmallInfo(
                    icon: Icons.flag_outlined,
                    text: helpdeskPriorityToString(
                      ticket.priority,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
  });

  final HelpdeskStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        helpdeskStatusToString(status),
        style: TextStyle(
          color: _statusColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Color get _statusColor {
    switch (status) {
      case HelpdeskStatus.open:
        return Colors.orange;
      case HelpdeskStatus.inProgress:
        return Colors.blue;
      case HelpdeskStatus.resolved:
        return Colors.green;
    }
  }
}

class _SmallInfo extends StatelessWidget {
  const _SmallInfo({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: Colors.grey,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}