import '../../../home/models/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/product_local_datasource.dart';



part 'last_order_table_event.dart';
part 'last_order_table_state.dart';
part 'last_order_table_bloc.freezed.dart';

class LastOrderTableBloc
    extends Bloc<LastOrderTableEvent, LastOrderTableState> {
  final ProductLocalDatasource datasource;
  LastOrderTableBloc(this.datasource)
      : super(const LastOrderTableState.initial()) {
    on<_LastOrderTable>((event, emit) async {
      emit(_Loading());
      final order = await datasource.getLastOrderTable(event.tableNumber);

      emit(_Success(order));
    });
  }
}
