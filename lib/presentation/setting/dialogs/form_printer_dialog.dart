import '../models/printer_model.dart';
import 'package:flutter/material.dart';
import '../../../components/spaces.dart';
import '../../../components/buttons.dart';
import '../../../core/constants/colors.dart';
import '../../../components/custom_text_field.dart';
import '../../../core/extensions/build_context_ext.dart';
import '../../../components/custom_dropdown.dart' show CustomDropdown;

class FormPrinterDialog extends StatelessWidget {
  final PrinterModel? data;
  const FormPrinterDialog({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: data?.name ?? '');
    final ipAddressController =
        TextEditingController(text: data?.ipAddress ?? '');
    final sizeController = ValueNotifier<String>(data?.size ?? '58mm');
    final typeController =
        ValueNotifier<PrinterType>(data?.type ?? PrinterType.wifi);
    final isCutReceipt = ValueNotifier<bool>(false);
    final isOpenLychee = ValueNotifier<bool>(false);
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
          Text(data == null ? 'Tambah Printer' : 'Edit Printer'),
          const Spacer(),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: context.deviceWidth / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: nameController,
                label: 'Nama Printer',
                onChanged: (value) {},
              ),
              const SpaceHeight(24.0),
              CustomTextField(
                controller: ipAddressController,
                label: 'Alamat IP',
                onChanged: (value) {},
              ),
              const SpaceHeight(24.0),
              ValueListenableBuilder(
                valueListenable: sizeController,
                builder: (context, value, child) => CustomDropdown(
                  value: value,
                  items: const ['58mm', '80mm'],
                  label: 'Ukuruan Struk',
                  onChanged: (value) => sizeController.value = value ?? '',
                ),
              ),
              const SpaceHeight(24.0),
              ValueListenableBuilder(
                valueListenable: typeController,
                builder: (context, value, child) => CustomDropdown(
                  value: value.value,
                  items: [
                    PrinterType.wifi.value,
                    PrinterType.bluetooth.value,
                  ],
                  label: 'Type',
                  onChanged: (value) =>
                      typeController.value = PrinterType.fromValue(value ?? ''),
                ),
              ),
              const SpaceHeight(24.0),
              ValueListenableBuilder(
                valueListenable: isCutReceipt,
                builder: (context, value, child) => GestureDetector(
                  onTap: () => isCutReceipt.value = !value,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Potong struk setelah selesai cetak',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'hanya aktifkan jika printer kamu support',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    trailing: Checkbox(
                      value: value,
                      onChanged: (_) => isCutReceipt.value = !value,
                    ),
                    textColor: AppColors.green,
                  ),
                ),
              ),
              const SpaceHeight(24.0),
              ValueListenableBuilder(
                valueListenable: isOpenLychee,
                builder: (context, value, child) => GestureDetector(
                  onTap: () => isOpenLychee.value = !value,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Buka laci setelah selesai cetak',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'hanya aktifkan jika printer kamu support',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    trailing: Checkbox(
                      value: value,
                      onChanged: (_) => isOpenLychee.value = !value,
                    ),
                    textColor: AppColors.green,
                  ),
                ),
              ),
              const SpaceHeight(24.0),
              Button.filled(
                onPressed: () {
                  if (data == null) {
                    // TODO: do add printer
                  } else {
                    // TODO: do edit printer
                  }
                  context.pop();
                },
                label: data == null ? 'Simpan' : 'Perbarui',
              )
            ],
          ),
        ),
      ),
    );
  }
}
