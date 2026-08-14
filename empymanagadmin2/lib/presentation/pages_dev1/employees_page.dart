import 'package:flutter/material.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Employee Directory', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('Manage company workforce and roles', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Employee'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Employee')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Department')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Alex Rivera')),
                  const DataCell(Text('Software Engineer')),
                  const DataCell(Text('Engineering')),
                  DataCell(Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)),
                    child: const Text('Active', style: TextStyle(color: Colors.green, fontSize: 12)),
                  )),
                  DataCell(IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}