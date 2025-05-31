import '../../../../core/core.dart';
import 'package:flutter/material.dart';
import '../../../../components/components.dart';


class HomeTitle extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value)? onChanged;

  const HomeTitle({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Makmoor',
              style: TextStyle(
                color: AppColors.green,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              DateTime.now().toFormattedDate(),
              style: const TextStyle(
                color: AppColors.green,
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 300.0,
          child: SearchInput(
            controller: controller,
            onChanged: onChanged,
            hintText: 'Search for food, coffe, etc..',
          ),
        ),
      ],
    );
  }
}
