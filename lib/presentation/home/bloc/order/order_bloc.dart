import 'dart:developer';
import 'package:bloc/bloc.dart';
import '../../models/order_model.dart';
import '../../models/product_quantity.dart';
import '../../../../core/extensions/string_ext.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/auth_local_datasource.dart';
import '../../../../data/datasource/order_remote_datasource.dart';
import '../../../../data/datasource/product_local_datasource.dart';




part 'order_bloc.freezed.dart';
part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRemoteDatasource orderRemoteDatasource;
  OrderBloc(
    this.orderRemoteDatasource,
  ) : super(const _Initial()) {
    on<_Order>((event, emit) async {
      emit(const _Loading());
      log("Start 1");

      final subTotal = event.items.fold<int>(
          0,
          (previousValue, element) =>
              previousValue +
              (element.product.price!.toIntegerFromText * element.quantity));
      // final total = subTotal + event.tax + event.serviceCharge - event.discount;

      final totalItem = event.items.fold<int>(
          0, (previousValue, element) => previousValue + element.quantity);

      final userData = await AuthLocalDataSource().getAuthData();

      final dataInput = OrderModel(
        subTotal: subTotal,
        paymentAmount: event.paymentAmount,
        tax: event.tax,
        discount: event.discount,
        discountAmount: event.discountAmount,
        serviceCharge: event.serviceCharge,
        total: event.totalPriceFinal,
        paymentMethod: event.paymentMethod,
        totalItem: totalItem,
        idKasir: userData.user?.id ?? 1,
        namaKasir: userData.user?.name ?? 'Kasir A',
        transactionTime: DateTime.now().toIso8601String(),
        customerName: event.customerName,
        tableNumber: event.tableNumber,
        status: event.status,
        paymentStatus: event.paymentStatus,
        isSync: 0,
        orderItems: event.items,
      );
      log("Start 2");

      int id = await ProductLocalDatasource.instance.saveOrder(dataInput);

      final newData = dataInput.copyWith(id: id);
      final orderItem =
          await ProductLocalDatasource.instance.getOrderItemByOrderId(id);

      final newOrder = newData.copyWith(orderItems: orderItem);

      final value = await orderRemoteDatasource.saveOrder(newOrder);

      if (value) {
        await ProductLocalDatasource.instance.updateOrderIsSync(id);
      }

      log("ID: $id  | dataInput: ${newData.toMap()}");
      emit(_Loaded(
        newData,
        id,
      ));
    });
  }
}
