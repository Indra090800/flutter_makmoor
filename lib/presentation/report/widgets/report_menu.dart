import 'package:flutter/material.dart';
import '../../../components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../core/assets/assets.gen.dart';

class ReportMenu extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isActive;

  const ReportMenu({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        width: 180.0,
        height: 160.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? AppColors.green.withOpacity(0.13) : AppColors.white,
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(
            color: isActive ? AppColors.green : AppColors.stroke,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Assets.icons.report.svg(
              colorFilter: isActive
                  ? const ColorFilter.mode(
                      AppColors.green,
                      BlendMode.srcIn,
                    )
                  : null,
            ),
            const SpaceHeight(28.0),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.green : AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SpaceHeight(24.0),
          ],
        ),
      ),
    );
  }
}
