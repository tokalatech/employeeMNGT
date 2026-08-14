import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1B4B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin & HR Command Center', style: TextStyle(color: Color(0xFF818CF8), fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('Executive HR Overview', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('Real-time workforce stats, today\'s attendance logs, pending leave approvals, and payroll overview.', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Employee'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), foregroundColor: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.attach_money, size: 16),
                      label: const Text('Process Payroll'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Expanded(child: StatCard(title: 'TOTAL WORKFORCE', value: '8', sub: '+2 this month', icon: Icons.group)),
              SizedBox(width: 16),
              Expanded(child: StatCard(title: 'TODAY\'S ATTENDANCE', value: '0%', sub: '0/8 Present', icon: Icons.check_circle_outline)),
              SizedBox(width: 16),
              Expanded(child: StatCard(title: 'PENDING REQUESTS', value: '2', sub: 'Requires Review', icon: Icons.pending_actions)),
              SizedBox(width: 16),
              Expanded(child: StatCard(title: 'MONTHLY PAYROLL EST.', value: '\$95,875', sub: 'Gross Base + HRA', icon: Icons.attach_money)),
            ],
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  final IconData icon;

  const StatCard({super.key, required this.title, required this.value, required this.sub, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              Icon(icon, color: const Color(0xFF6366F1), size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}