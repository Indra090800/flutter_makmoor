import 'package:shared_preferences/shared_preferences.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
// printer_service.dart

class PrinterService {
  static final PrinterService _instance = PrinterService._internal();
  factory PrinterService() => _instance;
  PrinterService._internal();

  final Map<String, String> _printerMacs = {
    'kasir': '',
    'dapur': '',
    'bar': '',
  };

  Future<void> loadSavedPrinters() async {
    final prefs = await SharedPreferences.getInstance();
    for (var role in _printerMacs.keys) {
      _printerMacs[role] = prefs.getString('printer_mac_$role') ?? '';
    }
  }

  Future<void> savePrinter(String role, String mac) async {
    _printerMacs[role] = mac;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer_mac_$role', mac);
  }

  String? getPrinter(String role) => _printerMacs[role];

  Future<void> printTo(String role, List<int> bytes) async {
    final mac = _printerMacs[role];
    if (mac == null || mac.isEmpty) {
      print("No printer assigned for role: $role");
      return;
    }

    final connected = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    if (connected) {
      await PrintBluetoothThermal.writeBytes(bytes);
      await PrintBluetoothThermal.disconnect;
    } else {
      print("Failed to connect to printer ($mac) for role: $role");
    }
  }

  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
  }

  Map<String, String> get allPrinters => _printerMacs;
}
