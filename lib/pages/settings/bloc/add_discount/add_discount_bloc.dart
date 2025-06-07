import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/discount_remote_datasource.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

part 'add_discount_bloc.freezed.dart';
part 'add_discount_event.dart';
part 'add_discount_state.dart';

class AddDiscountBloc extends Bloc<AddDiscountEvent, AddDiscountState> {
  final DiscountRemoteDatasource discountRemoteDatasource;
  AddDiscountBloc(
    this.discountRemoteDatasource,
  ) : super(const _Initial()) {
    on<_$AddDiscount>((event, emit) async {
      emit(const _Loading());
      final result = await discountRemoteDatasource.addDiscounts(
        event.name,
        event.description,
        event.value,
      );

      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(const _Success()),
      );
    });
  }
}
