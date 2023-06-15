import 'package:flutter/material.dart';

import '../../../models/province.dart';

class DropdownWidget extends StatelessWidget {
  final List<Province> provinces;
  final String selectedProvinceId;
  final ValueChanged<String> onChanged;
  final String label;

  const DropdownWidget({
    required this.provinces,
    required this.selectedProvinceId,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เฉพาะร้านค้าใน $label',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedProvinceId,
              onChanged: (String? newVal) {
                onChanged(newVal!);
              },
              items: provinces.map((province) {
                return DropdownMenuItem<String>(
                  value: province.id,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(province.provinceThai),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
