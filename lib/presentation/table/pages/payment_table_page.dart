import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../components/spaces.dart';
import '../../../components/buttons.dart';
import '../models/draft_order_model.dart';
import '../../home/widgets/order_menu.dart';
import '../../../core/constants/colors.dart';
import '../../home/bloc/order/order_bloc.dart';
import '../../../core/extensions/int_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/models/product_quantity.dart';
import '../../../core/extensions/string_ext.dart';
import '../../home/dialog/payment_qris_dialog.dart';
import '../../home/bloc/checkout/checkout_bloc.dart';
import '../../../data/model/response/table_model.dart';
import '../../home/widgets/success_payment_dialog.dart';
import '../../../core/extensions/build_context_ext.dart';
import '../../home/bloc/status_table/status_table_bloc.dart';
import '../../../data/datasource/product_local_datasource.dart';
import '../../home/bloc/get_table_status/get_table_status_bloc.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PaymentTablePage extends StatefulWidget {
  final DraftOrderModel? draftOrder;
  final TableModel? table;
  const PaymentTablePage({
    Key? key,
    this.draftOrder,
    this.table,
  }) : super(key: key);

  @override
  State<PaymentTablePage> createState() => _PaymentTablePageState();
}

class _PaymentTablePageState extends State<PaymentTablePage> {
  final totalPriceController = TextEditingController();
  final customerController = TextEditingController();
  bool isCash = true;
  int totalPriceFinal = 0;
  int discountAmountFinal = 0;
  @override
  void initState() {
    context
        .read<GetTableStatusBloc>()
        .add(GetTableStatusEvent.getTablesStatus('available'));
    super.initState();
  }

  @override
  void dispose() {
    totalPriceController.dispose();
    customerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Hero(
        tag: 'confirmation_screen',
        child: Scaffold(
          body: Row(
            children: [
              // LEFT CONTENT
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Konfirmasi',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Orders Table ${widget.table?.tableNumber}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                height: 60.0,
                                width: 60.0,
                                decoration: const BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(8.0),
                        const Divider(),
                        const SpaceHeight(24.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Item',
                              style: TextStyle(
                                color: AppColors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 160,
                            ),
                            SizedBox(
                              width: 50.0,
                              child: Text(
                                'Qty',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                'Price',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SpaceHeight(8),
                        const Divider(),
                        const SpaceHeight(8),
                        BlocBuilder<CheckoutBloc, CheckoutState>(
                          builder: (context, state) {
                            return state.maybeWhen(
                              orElse: () => const Center(
                                child: Text('No Items'),
                              ),
                              loaded: (products,
                                  discountModel,
                                  discount,
                                  discountAmount,
                                  tax,
                                  serviceCharge,
                                  totalQuantity,
                                  totalPrice,
                                  draftName) {
                                if (products.isEmpty) {
                                  return const Center(
                                    child: Text('No Items'),
                                  );
                                }
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      OrderMenu(data: products[index]),
                                  separatorBuilder: (context, index) =>
                                      const SpaceHeight(16.0),
                                  itemCount: products.length,
                                );
                              },
                            );
                          },
                        ),
                        const SpaceHeight(16.0),

                        const SpaceHeight(8.0),
                        const Divider(),
                        const SpaceHeight(8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sub total',
                              style: TextStyle(color: AppColors.grey),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final price = state.maybeWhen(
                                    orElse: () => 0,
                                    loaded: (products,
                                            discountModel,
                                            discount,
                                            discountAmount,
                                            tax,
                                            serviceCharge,
                                            totalQuantity,
                                            totalPrice,
                                            draftName) =>
                                        products.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              (element.product.price!
                                                      .toIntegerFromText *
                                                  element.quantity),
                                        ));
                                return Text(
                                  price.currencyFormatRp,
                                  style: const TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(16.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Diskon',
                              style: TextStyle(color: AppColors.grey),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final discount = state.maybeWhen(
                                    orElse: () => 0,
                                    loaded: (products,
                                        discountModel,
                                        discount,
                                        discountAmount,
                                        tax,
                                        serviceCharge,
                                        totalQuantity,
                                        totalPrice,
                                        draftName) {
                                      log("discountAmount: $discountAmount");
                                      return discountAmount;
                                    });

                                discountAmountFinal = discount.toInt();

                                return Text(
                                  discount.toInt().currencyFormatRp,
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Pajak PB1',
                              style: TextStyle(color: AppColors.grey),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final tax = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) =>
                                      tax,
                                );
                                final price = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) =>
                                      products.fold(
                                    0,
                                    (previousValue, element) =>
                                        previousValue +
                                        (element.product.price!
                                                .toIntegerFromText *
                                            element.quantity),
                                  ),
                                );

                                final discount = state.maybeWhen(
                                    orElse: () => 0,
                                    loaded: (products,
                                        discountModel,
                                        discount,
                                        discountAmount,
                                        tax,
                                        serviceCharge,
                                        totalQuantity,
                                        totalPrice,
                                        draftName) {
                                      return discountAmount;
                                    });

                                final subTotal = price - discount;
                                final finalTax = subTotal * (tax / 100);
                                return Text(
                                  '$tax % (${finalTax.toInt().currencyFormatRp})',
                                  style: const TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(16.0),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Biaya Layanan',
                              style: TextStyle(color: AppColors.grey),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final tax = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) =>
                                      tax,
                                );
                                final price = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) =>
                                      products.fold(
                                    0,
                                    (previousValue, element) =>
                                        previousValue +
                                        (element.product.price!
                                                .toIntegerFromText *
                                            element.quantity),
                                  ),
                                );

                                final discount = state.maybeWhen(
                                    orElse: () => 0,
                                    loaded: (products,
                                        discountModel,
                                        discount,
                                        discountAmount,
                                        tax,
                                        serviceCharge,
                                        totalQuantity,
                                        totalPrice,
                                        draftName) {
                                      return discountAmount;
                                    });

                                final serviceCharge = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) =>
                                      serviceCharge,
                                );

                                final subTotal = price - discount;
                                final finalServiceCharge =
                                    subTotal * (serviceCharge / 100);

                                return Text(
                                  '$serviceCharge % (${finalServiceCharge.toInt().currencyFormatRp}) ',
                                  style: const TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final price = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) =>
                                      products.fold(
                                    0,
                                    (previousValue, element) =>
                                        previousValue +
                                        (element.product.price!
                                                .toIntegerFromText *
                                            element.quantity),
                                  ),
                                );

                                final discount = state.maybeWhen(
                                    orElse: () => 0,
                                    loaded: (products,
                                        discountModel,
                                        discount,
                                        discountAmount,
                                        tax,
                                        serviceCharge,
                                        totalQuantity,
                                        totalPrice,
                                        draftName) {
                                      return discountAmount;
                                    });

                                final serviceCharge = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) =>
                                      serviceCharge,
                                );

                                final tax = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) =>
                                      tax,
                                );

                                final subTotal = price - discount;
                                final finalTax = subTotal * (tax / 100);
                                final service =
                                    subTotal * (serviceCharge / 100);
                                final total = subTotal + finalTax + service;
                                totalPriceFinal = total.ceil();
                                totalPriceController.text =
                                    total.ceil().toString();
                                return Text(
                                  total.ceil().currencyFormatRp,
                                  style: const TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        // const SpaceHeight(20.0),
                        // Button.filled(
                        //   onPressed: () {},
                        //   label: 'Lanjutkan Pembayaran',
                        // ),
                      ],
                    ),
                  ),
                ),
              ),

              // RIGHT CONTENT
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pembayaran',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SpaceHeight(16.0),
                              const Divider(),
                              const SpaceHeight(8.0),
                              const Text(
                                'Customer',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SpaceHeight(12.0),
                              BlocBuilder<CheckoutBloc, CheckoutState>(
                                builder: (context, state) {
                                  return state.maybeWhen(
                                    orElse: () {
                                      return SizedBox.shrink();
                                    },
                                    loaded: (items,
                                        discountModel,
                                        discount,
                                        discountAmount,
                                        tax,
                                        serviceCharge,
                                        totalQuantity,
                                        totalPrice,
                                        draftName) {
                                      customerController.text = draftName;
                                      return TextFormField(
                                        readOnly: true,
                                        controller: customerController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          hintText: 'Nama Customer',
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              const SpaceHeight(8.0),
                              const Divider(),
                              const SpaceHeight(8.0),
                              const Text(
                                'Metode Bayar',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SpaceHeight(12.0),
                              Row(
                                children: [
                                  isCash
                                      ? Button.filled(
                                          width: 120.0,
                                          height: 50.0,
                                          onPressed: () {
                                            isCash = true;
                                            setState(() {});
                                          },
                                          label: 'Cash',
                                        )
                                      : Button.outlined(
                                          width: 120.0,
                                          height: 50.0,
                                          onPressed: () {
                                            isCash = true;
                                            setState(() {});
                                          },
                                          label: 'Cash',
                                        ),
                                  const SpaceWidth(8.0),
                                  isCash
                                      ? Button.outlined(
                                          width: 120.0,
                                          height: 50.0,
                                          onPressed: () {
                                            isCash = false;
                                            setState(() {});
                                          },
                                          label: 'QRIS',
                                        )
                                      : Button.filled(
                                          width: 120.0,
                                          height: 50.0,
                                          onPressed: () {
                                            isCash = false;
                                            setState(() {});
                                          },
                                          label: 'QRIS',
                                        ),
                                ],
                              ),
                              const SpaceHeight(8.0),
                              const Divider(),
                              const SpaceHeight(8.0),
                              const Text(
                                'Total Bayar',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SpaceHeight(12.0),
                              TextFormField(
                                controller: totalPriceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  hintText: 'Total harga',
                                ),
                              ),
                              const SpaceHeight(45.0),
                              Row(
                                children: [
                                  Button.filled(
                                    width: 150.0,
                                    onPressed: () {},
                                    label: 'UANG PAS',
                                  ),
                                  const SpaceWidth(20.0),
                                  Button.filled(
                                    width: 150.0,
                                    onPressed: () {},
                                    label: 'Rp 250.000',
                                  ),
                                  const SpaceWidth(20.0),
                                  Button.filled(
                                    width: 150.0,
                                    onPressed: () {},
                                    label: 'Rp 300.000',
                                  ),
                                ],
                              ),
                              const SpaceHeight(100.0),
                            ]),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ColoredBox(
                          color: AppColors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Button.outlined(
                                    onPressed: () => context.pop(),
                                    label: 'Batalkan',
                                  ),
                                ),
                                const SpaceWidth(8.0),
                                BlocListener<OrderBloc, OrderState>(
                                  listener: (context, state) {
                                    final newTable = TableModel(
                                      id: widget.table!.id,
                                      tableNumber: widget.table!.tableNumber,
                                      status: 'available',
                                      orderId: 0,
                                      paymentAmount: 0,
                                      startTime:
                                          DateTime.now().toIso8601String(),
                                    );
                                    context.read<StatusTableBloc>().add(
                                          StatusTableEvent.statusTabel(
                                            newTable,
                                          ),
                                        );
                                    ProductLocalDatasource.instance
                                        .removeDraftOrderById(
                                            widget.draftOrder!.id!);
                                  },
                                  child:
                                      BlocBuilder<CheckoutBloc, CheckoutState>(
                                    builder: (context, state) {
                                      final discount = state.maybeWhen(
                                          orElse: () => 0,
                                          loaded: (products,
                                              discountModel,
                                              discount,
                                              discountAmount,
                                              tax,
                                              serviceCharge,
                                              totalQuantity,
                                              totalPrice,
                                              draftName) {
                                            if (discountModel == null) {
                                              return 0;
                                            }
                                            return discountModel!.value!
                                                .replaceAll('.00', '')
                                                .toIntegerFromText;
                                          });

                                      final price = state.maybeWhen(
                                        orElse: () => 0,
                                        loaded: (products,
                                                discountModel,
                                                discount,
                                                discountAmount,
                                                tax,
                                                serviceCharge,
                                                totalQuantity,
                                                totalPrice,
                                                draftName) =>
                                            products.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              (element.product.price!
                                                      .toIntegerFromText *
                                                  element.quantity),
                                        ),
                                      );

                                      final subTotal =
                                          price - (discount / 100 * price);
                                      final totalDiscount =
                                          discount / 100 * price;
                                      final finalTax = subTotal * 0.11;

                                      List<ProductQuantity> items =
                                          state.maybeWhen(
                                        orElse: () => [],
                                        loaded: (products,
                                                discountModel,
                                                discount,
                                                discountAmount,
                                                tax,
                                                serviceCharge,
                                                totalQuantity,
                                                totalPrice,
                                                draftName) =>
                                            products,
                                      );
                                      final totalQty = items.fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue + element.quantity,
                                      );

                                      final totalPrice = subTotal + finalTax;

                                      return Flexible(
                                        child: Button.filled(
                                          onPressed: () async {
                                            if (isCash) {
                                              context.read<OrderBloc>().add(
                                                  OrderEvent.order(
                                                      items,
                                                      discount,
                                                      discountAmountFinal,
                                                      finalTax.toInt(),
                                                      0,
                                                      totalPriceController.text
                                                          .toIntegerFromText,
                                                      customerController.text,
                                                      widget.table?.id ?? 0,
                                                      'completed',
                                                      'paid',
                                                      isCash ? 'Cash' : 'Qris',
                                                      totalPriceFinal));

                                              await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) =>
                                                    SuccessPaymentDialog(
                                                  data: items,
                                                  totalQty: totalQty,
                                                  totalPrice:
                                                      totalPriceFinal.toInt(),
                                                  totalTax: finalTax.toInt(),
                                                  totalDiscount:
                                                      totalDiscount.toInt(),
                                                  subTotal: subTotal.toInt(),
                                                  normalPrice: price,
                                                  totalService: 0,
                                                  draftName:
                                                      customerController.text,
                                                ),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    PaymentQrisDialog(
                                                  price: totalPrice.toInt(),
                                                  items: items,
                                                  totalQty: totalQty,
                                                  tax: finalTax.toInt(),
                                                  discountAmount:
                                                      totalDiscount.toInt(),
                                                  subTotal: subTotal.toInt(),
                                                  customerName:
                                                      customerController.text,
                                                  discount: discount,
                                                  paymentAmount:
                                                      totalPriceController.text
                                                          .toIntegerFromText,
                                                  paymentMethod: 'Qris',
                                                  tableNumber: widget
                                                          .table?.tableNumber ??
                                                      0,
                                                  paymentStatus: 'paid',
                                                  serviceCharge: 0,
                                                  status: 'completed',
                                                ),
                                              );
                                            }
                                          },
                                          label: 'Bayar',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
