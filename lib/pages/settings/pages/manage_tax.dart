import '../models/tax_model.dart';
import '../widgets/add_data.dart';
import 'package:flutter/material.dart';
import '../widgets/settings_title.dart';
import '../dialogs/form_tax_dialog.dart';
import '../widgets/manage_tax_card.dart';
import '../../home/widgets/custom_tab_bar.dart';


class TaxPage extends StatefulWidget {
  const TaxPage({super.key});

  @override
  State<TaxPage> createState() => _TaxPageState();
}

class _TaxPageState extends State<TaxPage> {
  final List<TaxModel> items = [
    TaxModel(name: 'Biaya Layanan', type: TaxType.layanan, value: 5),
    TaxModel(name: 'Pajak', type: TaxType.pajak, value: 11),
  ];

  void onEditTap(TaxModel item) {
    showDialog(
      context: context,
      builder: (context) => FormTaxDialog(data: item),
    );
  }

  void onAddDataTap() {
    showDialog(
      context: context,
      builder: (context) => const FormTaxDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SettingsTitle('Perhitungan Biaya'),
          const SizedBox(height: 24),
          CustomTabBar(
            tabTitles: const ['Layanan', 'Pajak'],
            initialTabIndex: 0,
            tabViews: [
              // LAYANAN TAB
              SizedBox(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: items
                          .where((element) => element.type.isLayanan)
                          .toList()
                          .length +
                      1,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.85,
                    crossAxisCount: 3,
                    crossAxisSpacing: 30.0,
                    mainAxisSpacing: 30.0,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return AddData(
                        title: 'Tambah Perhitungan',
                        onPressed: onAddDataTap,
                      );
                    }
                    final item = items
                        .where((element) => element.type.isLayanan)
                        .toList()[index - 1];
                    return ManageTaxCard(
                      data: item,
                      onEditTap: () => onEditTap(item),
                    );
                  },
                ),
              ),

              // PAJAK TAB
              SizedBox(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: items
                          .where((element) => element.type.isPajak)
                          .toList()
                          .length +
                      1,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.85,
                    crossAxisCount: 3,
                    crossAxisSpacing: 30.0,
                    mainAxisSpacing: 30.0,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return AddData(
                        title: 'Tambah Perhitungan',
                        onPressed: onAddDataTap,
                      );
                    }
                    final item = items
                        .where((element) => element.type.isPajak)
                        .toList()[index - 1];
                    return ManageTaxCard(
                      data: item,
                      onEditTap: () => onEditTap(item),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}