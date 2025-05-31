import 'home_page.dart';
import '../widgets/nav_item.dart';
import 'manage_printer_page.dart';
import '../../../../core/core.dart';
import 'package:flutter/material.dart';
import '../../report/pages/report_page.dart';
import '../../settings/pages/settings_page.dart';


class MainNavDesktop extends StatefulWidget {
  const MainNavDesktop({super.key});

  @override
  State<MainNavDesktop> createState() => _MainNavDesktopState();
}

class _MainNavDesktopState extends State<MainNavDesktop> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    // const Center(child: Text('This is page 3')),
    const ReportPage(),
    const ManagePrinterPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            SingleChildScrollView(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(16.0)),
                child: SizedBox(
                  height: context.deviceHeight - 20.0,
                  child: ColoredBox(
                    color: AppColors.green,
                    child: Column(
                      children: [
                        NavItem(
                          iconPath: Assets.icons.homeResto.path,
                          isActive: _selectedIndex == 0,
                          onTap: () => _onItemTapped(0),
                        ),
                        NavItem(
                          iconPath: Assets.icons.discount.path,
                          isActive: _selectedIndex == 1,
                          onTap: () => _onItemTapped(1),
                        ),
                        NavItem(
                          iconPath: Assets.icons.dashboard.path,
                          isActive: _selectedIndex == 2,
                          onTap: () => _onItemTapped(2),
                        ),
                        NavItem(
                          iconPath: Assets.icons.setting.path,
                          isActive: _selectedIndex == 3,
                          onTap: () => _onItemTapped(3),
                        ),
                        NavItem(
                          iconPath: Assets.icons.logout.path,
                          isActive: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }
}
