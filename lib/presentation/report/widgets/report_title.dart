import 'package:flutter/material.dart';
import '../../../components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../core/extensions/date_time_ext.dart';

class ReportTitle extends StatelessWidget {
  const ReportTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Report',
          style: TextStyle(
            color: AppColors.green,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SpaceHeight(4.0),
        Text(
          DateTime.now().toFormattedDate(),
          style: const TextStyle(
            color: AppColors.subtitle,
            fontSize: 16,
          ),
        ),
        const SpaceHeight(20.0),
        const Divider(),
      ],
    );
  }
}
