import 'dart:async';
import 'home_page.dart';
import '../widgets/nav_item.dart';
import '../../auth/login_page.dart';
import 'package:flutter/material.dart';
import '../../sales/pages/sales_page.dart';
import '../../table/pages/table_page.dart';
import '../../../core/constants/colors.dart';
import '../../report/pages/report_page.dart';
import '../../../core/assets/assets.gen.dart';
import '../../setting/pages/settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/bloc/logout/logout_bloc.dart';
import '../../../core/extensions/build_context_ext.dart';
import '../bloc/online_checker/online_checker_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../setting/bloc/sync_order/sync_order_bloc.dart';
import '../../../data/datasource/auth_local_datasource.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(
      isTable: false,
    ),
    const TablePage(),
    const ReportPage(),
    SalesPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    StreamSubscription<List<ConnectivityResult>> subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> connectivityResult) {
      // Received changes in available connectivity types!
      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        // Mobile network available.
        context
            .read<OnlineCheckerBloc>()
            .add(const OnlineCheckerEvent.check(true));
      } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
        // Wi-fi is available.
        context
            .read<OnlineCheckerBloc>()
            .add(const OnlineCheckerEvent.check(true));
        // Note for Android:
        // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      } else {
        // Neither mobile network nor Wi-fi available.
        context
            .read<OnlineCheckerBloc>()
            .add(const OnlineCheckerEvent.check(false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: context.deviceHeight - 20.0,
                child: ColoredBox(
                  color: AppColors.green,
                  child: ListView(
                    children: [
                      NavItem(
                        iconPath: Assets.icons.homeResto.path,
                        isActive: _selectedIndex == 0,
                        tooltip: 'POS',
                        onTap: () => _onItemTapped(0),
                      ),
                      NavItem(
                        iconPath: Assets.icons.kelolaProduk.path,
                        isActive: _selectedIndex == 1,
                        tooltip: 'Table Management',
                        onTap: () => _onItemTapped(1),
                      ),
                      NavItem(
                        iconPath: Assets.icons.dashboard.path,
                        isActive: _selectedIndex == 2,
                        tooltip: 'Report Page',
                        onTap: () => _onItemTapped(2),
                      ),
                      NavItem(
                        iconPath: Assets.icons.dashboard.path,
                        isActive: _selectedIndex == 3,
                        tooltip: 'Transaction',
                        onTap: () => _onItemTapped(3),
                      ),
                      NavItem(
                        iconPath: Assets.icons.setting.path,
                        isActive: _selectedIndex == 4,
                        tooltip: 'Settings Page',
                        onTap: () => _onItemTapped(4),
                      ),
                      //container flag online/offline
                      BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () => Tooltip(
                              message: 'Not Connected',
                              child: Container(
                                width: 40,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(
                                  Icons.signal_wifi_off,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            online: () {
                              context.read<SyncOrderBloc>().add(
                                    const SyncOrderEvent.syncOrder(),
                                  );
                              return Tooltip(
                                message: 'Connected',
                                child: Container(
                                  width: 40,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 16),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.green,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: const Icon(
                                    Icons.wifi,
                                    color: AppColors.white,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      BlocListener<LogoutBloc, LogoutState>(
                        listener: (context, state) {
                          state.maybeMap(
                            orElse: () {},
                            error: (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message),
                                  backgroundColor: AppColors.red,
                                ),
                              );
                            },
                            success: (value) {
                              AuthLocalDataSource().removeAuthData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logout success'),
                                  backgroundColor: AppColors.green,
                                ),
                              );
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const LoginPage();
                              }));
                            },
                          );
                        },
                        child: NavItem(
                          iconPath: Assets.icons.logout.path,
                          isActive: false,
                          tooltip: 'Logout',
                          onTap: () {
                            context
                                .read<LogoutBloc>()
                                .add(const LogoutEvent.logout());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 20,
              height: double.infinity,
              color: Colors.yellow,
            ),
            Expanded(
              flex: 10,
              child: _pages[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}
