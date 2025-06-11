import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../components/search_input.dart';
import '../../../core/extensions/date_time_ext.dart';

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
              'MAKMOOR APPS',
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
            hintText: 'Search..',
          ),
        ),
      ],
    );
  }
}
