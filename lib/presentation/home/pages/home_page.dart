import '../dialog/tax_dialog.dart';
import 'confirm_payment_page.dart';
import '../widgets/home_title.dart';
import '../widgets/order_menu.dart';
import '../widgets/product_card.dart';
import 'package:flutter/material.dart';
import '../dialog/service_dialog.dart';
import '../widgets/column_button.dart';
import '../dialog/discount_dialog.dart';
import '../widgets/custom_tab_bar.dart';
import '../../../components/spaces.dart';
import '../../../components/buttons.dart';
import '../../../core/constants/colors.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../../../core/assets/assets.gen.dart';
import '../../../core/extensions/int_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/extensions/string_ext.dart';
import '../bloc/local_product/local_product_bloc.dart';
import '../../../data/model/response/table_model.dart';
import '../bloc/local_category/local_category_bloc.dart';
import '../../../core/extensions/build_context_ext.dart';
import '../../../data/datasource/auth_local_datasource.dart';
import '../../../data/model/response/product_response_model.dart';
import '../../../data/model/response/category_response_model.dart';

class HomePage extends StatefulWidget {
  final bool isTable;
  final TableModel? table;
  const HomePage({
    super.key,
    required this.isTable,
    this.table,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  int currentCategoryId = 0;
  int subTotal = 0;

  @override
  void initState() {
    super.initState();
    getKasir();
    context
        .read<LocalProductBloc>()
        .add(const LocalProductEvent.getLocalProduct());
    context
        .read<LocalCategoryBloc>()
        .add(const LocalCategoryEvent.getLocalCategory());
  }

  void onSearchChanged(String value) {
    setState(() {
      filteredProducts = allProducts
          .where((product) =>
              product.category?.id == currentCategoryId &&
              product.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void onCategoryTap(int id) {
    searchController.clear();
    setState(() {
      currentCategoryId = id;
      filteredProducts = allProducts
          .where((product) =>
              (id == 0 || product.category?.id == id) &&
              (searchController.text.isEmpty ||
                  product.name!
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase())))
          .toList();
    });
  }

  String? kasir;
  getKasir() async {
    final authData = await AuthLocalDataSource().getAuthData();
    kasir = authData.user!.name;
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'confirmation_screen',
      child: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 3,
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        HomeTitle(
                          controller: searchController,
                          onChanged: onSearchChanged,
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<LocalCategoryBloc, LocalCategoryState>(
                          builder: (context, categoryState) {
                            print('State: orElse');
                            return categoryState.maybeWhen(
                              orElse: () => SizedBox(),
                              loaded: (categories) {
                                final updatedCategories = [
                                  CategoryModel(
                                      id: 0,
                                      name:
                                          'Semua'), // Tambahkan kategori 'Semua'
                                  ...categories
                                ];

                                if (currentCategoryId == 0 &&
                                    updatedCategories.isNotEmpty) {
                                  currentCategoryId =
                                      updatedCategories.first.id!;
                                }

                                return CustomTabBar(
                                  tabTitles: updatedCategories
                                      .map((e) => e.name.toString())
                                      .toList(),
                                  initialTabIndex: 0,
                                  onTap: (index) => onCategoryTap(
                                      updatedCategories[index].id!),
                                  tabViews: updatedCategories.map((category) {
                                    return SizedBox(
                                      child: BlocBuilder<LocalProductBloc,
                                          LocalProductState>(
                                        builder: (context, productState) {
                                          return productState.maybeWhen(
                                            orElse: () =>
                                                const Center(child: _IsEmpty()),
                                            loading: () => const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            loaded: (products) {
                                              allProducts = products;

                                              // Filter jika bukan kategori semua
                                              final showingProducts = category.id == 0
                                                  ? (searchController.text.isEmpty
                                                      ? products
                                                      : products
                                                          .where((product) => product
                                                              .name!
                                                              .toLowerCase()
                                                              .contains(searchController
                                                                  .text
                                                                  .toLowerCase()))
                                                          .toList())
                                                  : products
                                                      .where((p) =>
                                                          p.category?.id ==
                                                              category.id &&
                                                          (searchController.text
                                                                  .isEmpty ||
                                                              p.name!
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      searchController.text.toLowerCase())))
                                                      .toList();

                                              if (showingProducts.isEmpty) {
                                                return const Center(
                                                    child: Text('No Items'));
                                              }

                                              return GridView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    showingProducts.length,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 0.85,
                                                  crossAxisCount: 3,
                                                  crossAxisSpacing: 30.0,
                                                  mainAxisSpacing: 30.0,
                                                ),
                                                itemBuilder: (context, index) {
                                                  return ProductCard(
                                                    data:
                                                        showingProducts[index],
                                                    onCartButton: () {},
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Orders',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Kasir : $kasir',
                                style: const TextStyle(
                                  color: AppColors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SpaceHeight(16.0),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Item',
                                style: TextStyle(
                                  color: AppColors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 130,
                              ),
                              SizedBox(
                                width: 50.0,
                                child: Text(
                                  'Qty',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  'Price',
                                  style: TextStyle(
                                    color: AppColors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SpaceHeight(8),
                          const Divider(),
                          const SpaceHeight(8),
                          BlocBuilder<CheckoutBloc, CheckoutState>(
                            builder: (context, state) {
                              return state.maybeWhen(
                                orElse: () => const Center(
                                  child: Text('No Items'),
                                ),
                                loaded: (products,
                                    discountModel,
                                    discount,
                                    discountAmount,
                                    tax,
                                    serviceCharge,
                                    totalQuantity,
                                    totalPrice,
                                    draftName) {
                                  if (products.isEmpty) {
                                    return const Center(
                                      child: Text('No Items'),
                                    );
                                  }
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        OrderMenu(data: products[index]),
                                    separatorBuilder: (context, index) =>
                                        const SpaceHeight(1.0),
                                    itemCount: products.length,
                                  );
                                },
                              );
                            },
                          ),
                          const SpaceHeight(8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ColumnButton(
                                label: 'Diskon',
                                svgGenImage: Assets.icons.diskon,
                                onPressed: () => showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const DiscountDialog(),
                                ),
                              ),
                              ColumnButton(
                                label: 'Pajak PB1',
                                svgGenImage: Assets.icons.pajak,
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => const TaxDialog(),
                                ),
                              ),
                              ColumnButton(
                                label: 'Layanan',
                                svgGenImage: Assets.icons.layanan,
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => const ServiceDialog(),
                                ),
                              ),
                            ],
                          ),
                          const SpaceHeight(8.0),
                          const Divider(),
                          const SpaceHeight(8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Pajak PB1',
                                style: TextStyle(color: AppColors.grey),
                              ),
                              BlocBuilder<CheckoutBloc, CheckoutState>(
                                builder: (context, state) {
                                  final tax = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) {
                                        if (products.isEmpty) {
                                          return 0;
                                        }
                                        return tax;
                                      });
                                  return Text(
                                    '$tax %',
                                    style: const TextStyle(
                                      color: AppColors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SpaceHeight(8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Layanan',
                                style: TextStyle(color: AppColors.grey),
                              ),
                              BlocBuilder<CheckoutBloc, CheckoutState>(
                                builder: (context, state) {
                                  final serviceCharge = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) {
                                        return serviceCharge;
                                      });
                                  return Text(
                                    '$serviceCharge %',
                                    style: const TextStyle(
                                      color: AppColors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SpaceHeight(8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Diskon',
                                style: TextStyle(color: AppColors.grey),
                              ),
                              BlocBuilder<CheckoutBloc, CheckoutState>(
                                builder: (context, state) {
                                  final discount = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) {
                                        if (discountModel == null) {
                                          return 0;
                                        }
                                        return discountModel.value!
                                            .replaceAll('.00', '')
                                            .toIntegerFromText;
                                      });
                                  return Text(
                                    '$discount %',
                                    style: const TextStyle(
                                      color: AppColors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SpaceHeight(8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sub total',
                                style: TextStyle(
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              BlocBuilder<CheckoutBloc, CheckoutState>(
                                builder: (context, state) {
                                  subTotal = state.maybeWhen(
                                      orElse: () => 0,
                                      loaded: (products,
                                          discountModel,
                                          discount,
                                          discountAmount,
                                          tax,
                                          serviceCharge,
                                          totalQuantity,
                                          totalPrice,
                                          draftName) {
                                        if (products.isEmpty) {
                                          return 0;
                                        }
                                        return products
                                            .map((e) =>
                                                e.product.price!
                                                    .toIntegerFromText *
                                                e.quantity)
                                            .reduce((value, element) =>
                                                value + element);
                                      });

                                  return Text(
                                    subTotal.currencyFormatRp,
                                    style: const TextStyle(
                                        color: AppColors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SpaceHeight(100.0),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ColoredBox(
                        color: AppColors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          child: Button.filled(
                            onPressed: () {
                              if (subTotal == 0) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Peringatan'),
                                    content: const Text(
                                        'Silakan pilih produk terlebih dahulu sebelum melanjutkan pembayaran.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                context.push(ConfirmPaymentPage(
                                  isTable: widget.isTable,
                                  table: widget.table,
                                ));
                              }
                            },
                            label: 'Lanjutkan Pembayaran',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IsEmpty extends StatelessWidget {
  const _IsEmpty();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SpaceHeight(40),
        Assets.icons.noProduct.svg(),
        const SizedBox(height: 40.0),
        const Text(
          'Belum Ada Produk',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
