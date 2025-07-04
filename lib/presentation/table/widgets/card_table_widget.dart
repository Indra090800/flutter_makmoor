import 'dart:developer';
import 'package:flutter/material.dart';
import '../../home/pages/home_page.dart';
import '../../../components/buttons.dart';
import '../models/draft_order_model.dart';
import '../pages/payment_table_page.dart';
import '../../../core/constants/colors.dart';
import '../../home/pages/dashboard_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/date_time_ext.dart';
import '../../home/bloc/checkout/checkout_bloc.dart';
import '../../../data/model/response/table_model.dart';
import '../../../core/extensions/build_context_ext.dart';
import '../../home/bloc/status_table/status_table_bloc.dart';
import '../../../data/datasource/product_local_datasource.dart';

class CardTableWidget extends StatefulWidget {
  final TableModel table;
  const CardTableWidget({
    super.key,
    required this.table,
  });

  @override
  State<CardTableWidget> createState() => _CardTableWidgetState();
}

class _CardTableWidgetState extends State<CardTableWidget> {
  DraftOrderModel? data;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    if (widget.table.status != 'available') {
      data = await ProductLocalDatasource.instance
          .getDraftOrderById(widget.table.orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(
            color: widget.table.status == 'available'
                ? AppColors.green
                : AppColors.red,
            width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Table ${widget.table.tableNumber}',
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.table.status == 'available'
                ? widget.table.status
                : "${widget.table.status} - ${DateTime.parse(widget.table.startTime).toFormattedTime()}",
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Button.filled(
              color: widget.table.status == 'available'
                  ? AppColors.green
                  : AppColors.red,
              onPressed: () async {
                if (widget.table.status == 'available') {
                  context.push(HomePage(
                    isTable: true,
                    table: widget.table,
                  ));
                } else {
                  if (data == null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardPage(),
                      ),
                    );
                    final newTable = TableModel(
                      id: widget.table!.id,
                      tableNumber: widget.table!.tableNumber,
                      status: 'available',
                      orderId: 0,
                      paymentAmount: 0,
                      startTime: DateTime.now().toIso8601String(),
                    );
                    context.read<StatusTableBloc>().add(
                          StatusTableEvent.statusTabel(
                            newTable,
                          ),
                        );
                  } else {
                    context.read<CheckoutBloc>().add(
                          CheckoutEvent.loadDraftOrder(data!),
                        );
                    log("Data Draft Order: ${data!.toMap()}");
                    context.push(PaymentTablePage(
                      table: widget.table,
                      draftOrder: data!,
                    ));
                  }
                }
                //   await showDialog<void>(
                //     context: context,
                //     barrierDismissible: true,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //         title: const Text('Close Table?'),
                //         content: SingleChildScrollView(
                //           child: ListBody(
                //             children: <Widget>[
                //               Text('Apakah anda yakin ingin menutup meja ini?'),
                //               SpaceHeight(16.0),
                //               CustomTextField(
                //                 controller: TextEditingController(
                //                     text: table.paymentAmount.currencyFormatRp),
                //                 label: 'Total',
                //                 readOnly: true,
                //               )
                //             ],
                //           ),
                //         ),
                //         actions: <Widget>[
                //           ElevatedButton(
                //             style: ElevatedButton.styleFrom(
                //               backgroundColor: AppColors.red,
                //             ),
                //             onPressed: () {
                //               Navigator.pop(context);
                //             },
                //             child: const Text(
                //               "No",
                //               style: TextStyle(color: Colors.white),
                //             ),
                //           ),
                //           BlocConsumer<StatusTableBloc, StatusTableState>(
                //             listener: (context, state) {
                //               state.maybeWhen(
                //                 orElse: () {},
                //                 success: () {
                //                   context
                //                       .read<GetTableBloc>()
                //                       .add(const GetTableEvent.getTables());
                //                   Navigator.pop(context);
                //                 },
                //               );
                //             },
                //             builder: (context, state) {
                //               return ElevatedButton(
                //                 style: ElevatedButton.styleFrom(
                //                   backgroundColor: AppColors.green,
                //                 ),
                //                 onPressed: () {
                //                   ProductLocalDatasource.instance
                //                       .updatePaymentStatus(
                //                           table.orderId, 'paid', 'completed');
                //                   final newTable = TableModel(
                //                     id: table.id,
                //                     tableNumber: table.tableNumber,
                //                     status: 'available',
                //                     orderId: 0,
                //                     paymentAmount: 0,
                //                     startTime: DateTime.now().toIso8601String(),
                //                   );
                //                   context.read<StatusTableBloc>().add(
                //                         StatusTableEvent.statusTabel(
                //                           newTable,
                //                         ),
                //                       );
                //                 },
                //                 child: const Text(
                //                   "Payment",
                //                   style: TextStyle(color: Colors.white),
                //                 ),
                //               );
                //             },
                //           ),
                //         ],
                //       );
                //     },
                //   );
                // }
              },
              label: widget.table.status == 'available' ? 'Open' : 'Close')
        ],
      ),
    );
  }
}
