import 'package:flutter/material.dart';
import '../../../components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../core/assets/assets.gen.dart';

class ColumnButton extends StatelessWidget {
  final String label;
  final SvgGenImage svgGenImage;
  final VoidCallback onPressed;

  const ColumnButton({
    super.key,
    required this.label,
    required this.svgGenImage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.green),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: svgGenImage.svg(color: AppColors.green),
          ),
          const SpaceHeight(8.0),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.green,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
