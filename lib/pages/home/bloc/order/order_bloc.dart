import 'package:bloc/bloc.dart';
import '../../models/order_model.dart';
import '../../models/product_quantity.dart';
import '../../../../core/extensions/string_ext.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/auth_local_datasource.dart';
import '../../../../data/datasource/product_local_datasource.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const _Initial()) {
    on<_Order>((event, emit) async {
      emit(const _Loading());

      //save local storage
      final subTotal = event.items.fold(
          0,
          (previousValue, element) =>
              previousValue +
              (element.product.price!.toIntegerFromText * element.quantity));
      final total = subTotal + event.tax + event.serviceCharge - event.discount;

      final totalItems = event.items.fold(
          0, (previousValue, element) => previousValue + element.quantity);

      final userData = await AuthLocalDataSource().getAuthData();

      final dataInput = OrderModel(
          subTotal: subTotal,
          discount: event.discount,
          tax: event.tax,
          serviceCharge: event.serviceCharge,
          paymentAmount: event.paymentAmount,
          total: total,
          paymentMethod: 'Cash',
          totalItem: totalItems,
          idKasir: userData.user!.id!,
          namaKasir: userData.user!.name!,
          transactionTime: DateTime.now().toIso8601String(),
          isSync: 0,
          orderItems: event.items);

      await ProductLocalDatasource.instance.saveOrder(dataInput);

      emit(_Loaded(dataInput));
    });
  }
}
