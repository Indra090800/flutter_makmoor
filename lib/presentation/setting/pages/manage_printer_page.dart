import 'package:flutter/material.dart';
import '../services/printer_services.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';


// manage_printer_page.dart

class ManagePrinterPage extends StatefulWidget {
  const ManagePrinterPage({super.key});

  @override
  State<ManagePrinterPage> createState() => _ManagePrinterPageState();
}

class _ManagePrinterPageState extends State<ManagePrinterPage> {
  List<BluetoothInfo> devices = [];
  String selectedRole = 'kasir';
  final List<String> printerRoles = ['kasir', 'dapur', 'bar'];

  @override
  void initState() {
    super.initState();
    PrinterService().loadSavedPrinters();
    getBluetoothDevices();
  }

  Future<void> getBluetoothDevices() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    final paired = await PrintBluetoothThermal.pairedBluetooths;
    setState(() {
      devices = paired;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedMac = PrinterService().getPrinter(selectedRole);

    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Printer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Role Printer'),
            DropdownButton<String>(
              value: selectedRole,
              items: printerRoles.map((role) => DropdownMenuItem(
                value: role,
                child: Text(role.toUpperCase()),
              )).toList(),
              onChanged: (value) => setState(() => selectedRole = value!),
            ),
            const SizedBox(height: 16),
            const Text('Pilih Printer'),
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  final isSelected = device.macAdress == selectedMac;
                  return ListTile(
                    title: Text(device.name),
                    subtitle: Text(device.macAdress),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () async {
                      await PrinterService().savePrinter(selectedRole, device.macAdress);
                      setState(() {});
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final bytes = await generateSampleTicket();
                await PrinterService().printTo(selectedRole, bytes);
              },
              child: const Text('Print Tes ke Role Ini'),
            )
          ],
        ),
      ),
    );
  }

  Future<List<int>> generateSampleTicket() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];
    bytes += generator.text('TES CETAK ${selectedRole.toUpperCase()}');
    bytes += generator.feed(2);
    return bytes;
  }
}
