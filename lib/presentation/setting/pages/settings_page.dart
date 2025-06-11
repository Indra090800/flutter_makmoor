import 'tax_page.dart';
import 'product_page.dart';
import 'discount_page.dart';
import 'sync_data_page.dart';
import 'server_key_page.dart';
import 'manage_printer_page.dart';
import 'package:flutter/material.dart';
import '../../../components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../core/assets/assets.gen.dart';
import '../../../data/datasource/auth_local_datasource.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int currentIndex = 0;
  String? role;

  void indexValue(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setRole();
  }

  void setRole() {
    AuthLocalDataSource().getAuthData().then((value) {
      setState(() {
        role = value.user!.role;
      });
    });
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
                  role != null && role! != 'admin'
                      ? const SizedBox()
                      : ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          leading: Assets.icons.kelolaProduk
                              .svg(color: AppColors.green),
                          title: const Text('Manage Products'),
                          subtitle: const Text('Manage products in your store'),
                          textColor: AppColors.green,
                          tileColor: currentIndex == 0
                              ? AppColors.blueLight
                              : Colors.transparent,
                          onTap: () => indexValue(0),
                        ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading:
                        Assets.icons.kelolaDiskon.svg(color: AppColors.green),
                    title: const Text('Kelola Diskon'),
                    subtitle: const Text('Kelola Diskon Pelanggan'),
                    textColor: AppColors.green,
                    tileColor: currentIndex == 1
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(1),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading:
                        Assets.icons.kelolaPrinter.svg(color: AppColors.green),
                    title: const Text('Kelola Printer'),
                    subtitle: const Text('Tambah atau hapus printer'),
                    textColor: AppColors.green,
                    tileColor: currentIndex == 2
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(2),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading:
                        Assets.icons.kelolaPajak.svg(color: AppColors.green),
                    title: const Text('Perhitungan Biaya'),
                    subtitle: const Text('Kelola biaya diluar biaya modal'),
                    textColor: AppColors.green,
                    tileColor: currentIndex == 3
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(3),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading:
                        Assets.icons.kelolaPajak.svg(color: AppColors.green),
                    title: const Text('Sync Data'),
                    subtitle:
                        const Text('Sinkronisasi data dari dan ke server'),
                    textColor: AppColors.green,
                    tileColor: currentIndex == 4
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(4),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: Image.asset(Assets.images.manageQr.path,
                        color: AppColors.green, fit: BoxFit.contain),
                    title: const Text('QR Key Setting'),
                    subtitle: const Text('QR Key Configuration'),
                    textColor: AppColors.green,
                    tileColor: currentIndex == 6
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(6),
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
                  children: [
                    role != null && role! != 'admin'
                        ? SizedBox()
                        : ProductPage(),
                    DiscountPage(),
                    ManagePrinterPage(),
                    TaxPage(),
                    SyncDataPage(),
                    ProductPage(),
                    ServerKeyPage()
                    // Text('tax'),
                    // ManageDiscount(),
                    // ManagePrinterPage(),
                    // ManageTax(),
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
