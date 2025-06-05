import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/order_remote_datasource.dart';
import '../../../../data/datasource/product_local_datasource.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

part 'sync_order_bloc.freezed.dart';
part 'sync_order_event.dart';
part 'sync_order_state.dart';

class SyncOrderBloc extends Bloc<SyncOrderEvent, SyncOrderState> {
  final OrderRemoteDatasource orderRemoteDatasource;
  SyncOrderBloc(
    this.orderRemoteDatasource,
  ) : super(const _Initial()) {
    on<SyncOrderEvent>((event, emit) async {
      emit(const _Loading());

      final dataOrderNotSynced =
          await ProductLocalDatasource.instance.getOrderByIsNotSync();
      for (var order in dataOrderNotSynced) {
        final orderItem =
            await ProductLocalDatasource.instance.getOrderById(order.id!);
        final newOrder = order.copyWith(orderItems: orderItem);
        final result = await orderRemoteDatasource.saveOrder(newOrder);
        if (result) {
          await ProductLocalDatasource.instance.updateOrderIsSync(order.id!);
        } else {
          emit(const _Error('Sync Order Failed'));
          return;
        }
      }
      emit(const _Loaded());
    });
  }
}
