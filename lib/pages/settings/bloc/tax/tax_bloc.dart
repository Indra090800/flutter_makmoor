import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/tax_remote_datasource.dart';
import '../../../../data/model/response/tax_discount_model.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first


part 'tax_bloc.freezed.dart';
part 'tax_event.dart';
part 'tax_state.dart';

class TaxBloc extends Bloc<TaxEvent, TaxState> {
  final TaxRemoteDatasource taxRemoteDatasource;
  TaxBloc(
    this.taxRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetTax>((event, emit)async {
      emit(const _Loading());
      final result = await taxRemoteDatasource.getTaxs();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data!)),
      );
    });
  }
}
