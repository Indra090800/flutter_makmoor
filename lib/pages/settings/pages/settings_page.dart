import 'manage_tax.dart';
import 'sync_data_page.dart';
import 'manage_discount.dart';
import '../../../../core/core.dart';
import 'package:flutter/material.dart';
import '../../../../components/components.dart';
import '../../home/pages/manage_printer_page.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int currentIndex = 0;

  void indexValue(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // LEFT CONTENT
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SpaceHeight(16.0),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: Assets.icons.kelolaDiskon.svg(color: AppColors.green),
                    title: const Text('Kelola Diskon'),
                    subtitle: const Text('Kelola Diskon Pelanggan'),
                    textColor: AppColors.green,
                    tileColor: currentIndex == 0
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(0),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: Assets.icons.kelolaPrinter.svg(color: AppColors.green),
                    title: const Text('Kelola Printer'),
                    subtitle: const Text('Tambah atau hapus printer'),
                    textColor: AppColors.green,
                    tileColor: currentIndex == 1
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(1),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: Assets.icons.kelolaPajak.svg(color: AppColors.green),
                    title: const Text('Perhitungan Biaya'),
                    subtitle: const Text('Kelola biaya diluar biaya modal'),
                    textColor: AppColors.green,
                    tileColor: currentIndex == 2
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(2),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: Assets.icons.layanan.svg(color: AppColors.green),
                    title: const Text('Sync Data'),
                    subtitle: const Text('Sinkronisasi data dari dan ke server'),
                    textColor: AppColors.green,
                    tileColor: currentIndex == 3
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(3),
                  ),
                ],
              ),
            ),
          ),

          // RIGHT CONTENT
          Expanded(
            flex: 4,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IndexedStack(
                  index: currentIndex,
                  children: const [
                    ManageDiscount(),
                    ManagePrinterPage(),
                    TaxPage(),
                    SyncDataPage(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
