import 'package:flutter/material.dart';
import '../../../components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../../../core/assets/assets.gen.dart';
import '../../../core/extensions/int_ext.dart';
import '../../../core/constants/variable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/string_ext.dart';
import '../../../data/model/response/product_response_model.dart';

class ProductCard extends StatelessWidget {
  final Product data;
  final VoidCallback onCartButton;

  const ProductCard({
    super.key,
    required this.data,
    required this.onCartButton,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ALERT STOK MENIPIS DI LUAR BORDER CARD
        if ((data.stock ?? 0) <= 20)
          Positioned(
            top: 10,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (data.stock ?? 0) <= 5
                    ? Colors.redAccent
                    : Colors.orangeAccent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                (data.stock ?? 0) <= 5
                    ? 'Segera isi stok'
                    : 'Stok sisa : ${data.stock}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // KONTEN CARD
        GestureDetector(
          onTap: () {
            context.read<CheckoutBloc>().add(CheckoutEvent.addItem(data));
          },
          child: Container(
            margin: const EdgeInsets.only(
                top: 8), // beri ruang atas agar alert tidak tertimpa
            padding: const EdgeInsets.all(16.0),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: AppColors.card),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceHeight(8),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.disabled.withOpacity(0.4),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40.0)),
                        child: Image.network(
                          data.image!.contains('http')
                              ? data.image!
                              : '${Variable.baseUrl}/${data.image}',
                          width: 60,
                          height: 60,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${data.name}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            data.category?.name ?? '-',
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            data.price!.toIntegerFromText.currencyFormatRp,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                // IKON KERANJANG / JUMLAH
                BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => const SizedBox(),
                      loaded: (products, _, __, ___, ____, _____, ______,
                          _______, ________) {
                        return products.any((e) => e.product == data)
                            ? products
                                        .firstWhere((e) => e.product == data)
                                        .quantity >
                                    0
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9.0)),
                                        color: AppColors.green,
                                      ),
                                      child: Center(
                                        child: Text(
                                          products
                                              .firstWhere(
                                                  (e) => e.product == data)
                                              .quantity
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      width: 36,
                                      height: 36,
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(9.0)),
                                        color: AppColors.green,
                                      ),
                                      child: Assets.icons.shoppingBasket.svg(),
                                    ),
                                  )
                            : Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9.0)),
                                    color: AppColors.green,
                                  ),
                                  child: Assets.icons.shoppingBasket.svg(),
                                ),
                              );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
