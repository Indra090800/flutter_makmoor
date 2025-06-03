import '../../../data/model/response/product_response_model.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class ProductQuantity {
  final Product product;
  int qty;
  ProductQuantity({
    required this.product,
    required this.qty,
  });

  @override
  bool operator ==(covariant ProductQuantity other) {
    if (identical(this, other)) return true;
  
    return 
      other.product == product &&
      other.qty == qty;
  }

  @override
  int get hashCode => product.hashCode ^ qty.hashCode;
}
