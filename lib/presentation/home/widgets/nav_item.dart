import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';




class NavItem extends StatelessWidget {
  final String iconPath;
  final bool isActive;
  final VoidCallback onTap;
  final Color color;
  final String tooltip; // Tambahan parameter tooltip

  const NavItem({
    super.key,
    required this.iconPath,
    required this.isActive,
    required this.onTap,
    this.color = AppColors.white,
    required this.tooltip, // Wajib diisi
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          child: ColoredBox(
            color: isActive
                ? AppColors.disabled.withOpacity(0.25)
                : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: tooltip,
                    child: SizedBox(
                      width: 25.0,
                      height: 25.0,
                      child: SvgPicture.asset(
                        iconPath,
                        colorFilter: ColorFilter.mode(
                          color,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}