part of 'add_discount_bloc.dart';

@freezed
class AddDiscountEvent with _$AddDiscountEvent {
  const factory AddDiscountEvent.started() = _Started;
  const factory AddDiscountEvent.addDiscounts(
    String name,
    String description,
    int value,
  ) = _$AddDiscount;

  
}
