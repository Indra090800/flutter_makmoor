import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabTitles;
  final int initialTabIndex;
  final List<Widget> tabViews;
  final ValueChanged<int>? onTap; // ✅ Tambahkan ini

  const CustomTabBar({
    super.key,
    required this.tabTitles,
    required this.initialTabIndex,
    required this.tabViews,
    this.onTap, // ✅ Tambahkan ini
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              widget.tabTitles.length,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onTap?.call(index); // ✅ Panggil jika tidak null
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  margin: const EdgeInsets.only(right: 32),
                  decoration: BoxDecoration(
                    border: _selectedIndex == index
                        ? const Border(
                            bottom: BorderSide(
                              width: 3.0,
                              color: AppColors.green,
                            ),
                          )
                        : null,
                  ),
                  child: Text(
                    widget.tabTitles[index],
                    style: const TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: widget.tabViews[_selectedIndex],
        ),
      ],
    );
  }
}
