import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/datasource/order_remote_datasource.dart';
import '../../../../data/model/response/summary_response_model.dart';


part 'summary_event.dart';
part 'summary_state.dart';
part 'summary_bloc.freezed.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final OrderRemoteDatasource datasource;
  SummaryBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_GetSummary>((event, emit) async {
      emit(const _Loading());
      final result = await datasource.getSummaryByRangeDate(
          event.startDate, event.endDate);
      result.fold((l) => emit(_Error(l)), (r) => emit(_Success(r.data!)));
    });
  }
}
