import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../bloc/order/order_bloc.dart';
import '../../../components/spaces.dart';
import '../models/product_quantity.dart';
import '../../../components/buttons.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../../../core/extensions/int_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../setting/services/printer_services.dart';
import '../../../data/model/response/table_model.dart';
import '../../../core/extensions/build_context_ext.dart';
import '../../table/blocs/get_table/get_table_bloc.dart';
import '../../../data/dataoutputs/print_dataoutputs.dart';
import '../../../data/datasource/auth_local_datasource.dart';
// success_payment_dialog.dart

class SuccessPaymentDialog extends StatefulWidget {
  const SuccessPaymentDialog({
    super.key,
    required this.data,
    required this.totalQty,
    required this.totalPrice,
    required this.totalTax,
    required this.totalDiscount,
    required this.subTotal,
    required this.normalPrice,
    required this.totalService,
    required this.draftName,
    this.table,
    required this.isDine,
  });

  final List<ProductQuantity> data;
  final int totalQty;
  final int totalPrice;
  final int totalTax;
  final int totalDiscount;
  final int subTotal;
  final int normalPrice;
  final int totalService;
  final String draftName;
  final TableModel? table;
  final bool isDine;

  @override
  State<SuccessPaymentDialog> createState() => _SuccessPaymentDialogState();
}

class _SuccessPaymentDialogState extends State<SuccessPaymentDialog> {
  Future<void> _safePrint(String role, Future<List<int>> Function() buildBytes) async {
    final mac = PrinterService().getPrinter(role);
    if (mac == null || mac.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Printer untuk $role belum disetel. Silakan atur di menu Kelola Printer.')),
      );
      return;
    }
    final bytes = await buildBytes();
    await PrinterService().printTo(role, bytes);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<CheckoutBloc>().add(const CheckoutEvent.started());
                  context.read<GetTableBloc>().add(const GetTableEvent.getTables());
                  context.popToRoot();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Icon(Icons.check_circle, size: 64, color: Colors.green)),
                  const SpaceHeight(16.0),
                  const Center(
                    child: Text(
                      'Pembayaran telah sukses dilakukan',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SpaceHeight(20.0),
                  const Text('METODE BAYAR'),
                  const SpaceHeight(5.0),
                  BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, state) {
                      final paymentMethod = state.maybeWhen(
                        orElse: () => 'Cash',
                        loaded: (model, orderId) => model.paymentMethod,
                      );
                      return Text(paymentMethod, style: const TextStyle(fontWeight: FontWeight.w700));
                    },
                  ),
                  const Divider(),
                  const Text('TOTAL TAGIHAN'),
                  Text(widget.totalPrice.currencyFormatRp, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const Divider(),
                  const Text('NOMINAL BAYAR'),
                  BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, state) {
                      final paymentAmount = state.maybeWhen(
                        orElse: () => 0,
                        loaded: (model, orderId) => model.paymentAmount,
                      );
                      return Text(paymentAmount.ceil().currencyFormatRp, style: const TextStyle(fontWeight: FontWeight.w700));
                    },
                  ),
                  const Divider(),
                  const Text('KEMBALIAN'),
                  BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, state) {
                      final paymentAmount = state.maybeWhen(
                        orElse: () => 0,
                        loaded: (model, orderId) => model.paymentAmount,
                      );
                      final diff = paymentAmount - widget.totalPrice;
                      return Text(diff.ceil().currencyFormatRp, style: const TextStyle(fontWeight: FontWeight.w700));
                    },
                  ),
                  const Divider(),
                  const Text('WAKTU PEMBAYARAN'),
                  Text(DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now()), style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SpaceHeight(20.0),
                  if (widget.isDine)
                    Row(
                      children: [
                        Flexible(
                          child: Button.filled(
                            onPressed: () => _safePrint('checker_bar', () async {
                              final sizeReceipt = await AuthLocalDataSource().getSizeReceipt();
                              return await PrintDataoutputs.instance.printChecker(
                                widget.data,
                                widget.table?.tableNumber ?? 0,
                                widget.draftName,
                                'Kasir',
                                int.parse(sizeReceipt),
                              );
                            }),
                            label: 'Print Checker Bar',
                          ),
                        ),
                        const SpaceWidth(8.0),
                        Flexible(
                          child: Button.filled(
                            onPressed: () => _safePrint('checker_dapur', () async {
                              final sizeReceipt = await AuthLocalDataSource().getSizeReceipt();
                              return await PrintDataoutputs.instance.printChecker(
                                widget.data,
                                widget.table?.tableNumber ?? 0,
                                widget.draftName,
                                'Kasir',
                                int.parse(sizeReceipt),
                              );
                            }),
                            label: 'Print Checker Dapur',
                          ),
                        ),
                      ],
                    ),
                  const SpaceHeight(16),
                  BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, state) {
                      final paymentAmount = state.maybeWhen(
                        orElse: () => 0,
                        loaded: (model, orderId) => model.paymentAmount,
                      );
                      if (paymentAmount == 0) return const SizedBox();

                      final kembalian = paymentAmount - widget.totalPrice;

                      return Button.filled(
                        onPressed: () => _safePrint('kasir', () async {
                          final sizeReceipt = await AuthLocalDataSource().getSizeReceipt();
                          return await PrintDataoutputs.instance.printOrderV3(
                            widget.data,
                            widget.totalQty,
                            widget.totalPrice,
                            'Cash',
                            paymentAmount,
                            kembalian,
                            widget.totalTax,
                            widget.totalDiscount,
                            widget.subTotal,
                            1,
                            'Kasir',
                            widget.draftName,
                            int.parse(sizeReceipt),
                          );
                        }),
                        label: 'Print Nota',
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
