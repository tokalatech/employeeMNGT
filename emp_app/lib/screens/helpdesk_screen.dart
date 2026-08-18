import 'package:flutter/material.dart';

import '../models/helpdesk_model.dart';
import '../services/helpdesk_service.dart';

class TicketDetailsScreen extends StatelessWidget {
  const TicketDetailsScreen({
    super.key,
    required this.ticketId,
  });

  final String ticketId;

  @override
  Widget build(BuildContext context) {
    final helpdeskService = HelpdeskService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
      ),
      body: FutureBuilder<HelpdeskTicket?>(
        future: helpdeskService.getTicketById(ticketId),
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
                  'Failed to load ticket\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final ticket = snapshot.data;

          if (ticket == null) {
            return const Center(
              child: Text(
                'Ticket not found',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Ticket number
              Text(
                ticket.ticketNumber,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 6),

              // Real subject
              Text(
                ticket.subject,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 20),

              // Status / Priority / Category
              _InfoCard(
                title: 'Status',
                value: helpdeskStatusToString(ticket.status),
              ),

              _InfoCard(
                title: 'Priority',
                value: helpdeskPriorityToString(ticket.priority),
              ),

              _InfoCard(
                title: 'Category',
                value: helpdeskCategoryToString(ticket.category),
              ),

              _InfoCard(
                title: 'Created',
                value: ticket.createdAt,
              ),

              // Description
              const SizedBox(height: 10),

              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    ticket.description.isEmpty
                        ? 'No description provided.'
                        : ticket.description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Conversation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              // Real Firebase messages
              StreamBuilder<List<HelpdeskMessage>>(
                stream: helpdeskService.watchMessages(ticket.id),
                builder: (context, messageSnapshot) {
                  if (messageSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (messageSnapshot.hasError) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Failed to load messages\n'
                              '${messageSnapshot.error}',
                        ),
                      ),
                    );
                  }

                  final messages =
                      messageSnapshot.data ?? <HelpdeskMessage>[];

                  if (messages.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'No messages yet.',
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: messages
                        .map(
                          (message) => _MessageCard(
                        message: message,
                      ),
                    )
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Reply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showReplyDialog(
                      context,
                      ticket,
                      helpdeskService,
                    );
                  },
                  icon: const Icon(Icons.reply),
                  label: const Text('Send Reply'),
                ),
              ),

              const SizedBox(height: 12),

              // Status update
              if (ticket.status != HelpdeskStatus.resolved)
                OutlinedButton.icon(
                  onPressed: () async {
                    await helpdeskService.updateTicketStatus(
                      ticket.id,
                      HelpdeskStatus.resolved,
                    );

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Ticket marked as resolved',
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Mark as Resolved'),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showReplyDialog(
      BuildContext context,
      HelpdeskTicket ticket,
      HelpdeskService service,
      ) async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Send Reply'),
          content: TextField(
            controller: controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter your reply',
              border: OutlineInputBorder(),
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
                final text = controller.text.trim();

                if (text.isEmpty) {
                  return;
                }

                final message = HelpdeskMessage(
                  id: '',
                  senderName: 'You',
                  senderAvatar: '',
                  isStaff: false,
                  text: text,
                  timestamp: DateTime.now().toIso8601String(),
                );

                try {
                  await service.addMessage(
                    ticket.id,
                    message,
                  );

                  if (!dialogContext.mounted) return;

                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Reply sent successfully',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!dialogContext.mounted) return;

                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to send reply: $e',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.message,
  });

  final HelpdeskMessage message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  child: Text(
                    message.senderName.isEmpty
                        ? '?'
                        : message.senderName[0].toUpperCase(),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.senderName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        message.isStaff
                            ? 'Support Staff'
                            : 'Employee',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  message.timestamp,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              message.text,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}