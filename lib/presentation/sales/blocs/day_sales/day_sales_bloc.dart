import 'package:bloc/bloc.dart';
import '../../../home/models/order_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/product_local_datasource.dart';



part 'day_sales_event.dart';
part 'day_sales_state.dart';
part 'day_sales_bloc.freezed.dart';

class DaySalesBloc extends Bloc<DaySalesEvent, DaySalesState> {
  final ProductLocalDatasource datasource;
  DaySalesBloc(this.datasource) : super(const _Initial()) {
    on<_GetDaySales>((event, emit) async {
      emit(const _Loading());
      final result =
          await datasource.getAllOrder(event.date);
      emit(_Loaded(result));
    });
  }
}
