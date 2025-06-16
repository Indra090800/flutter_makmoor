import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sync_order/sync_order_bloc.dart';
import '../bloc/sync_product/sync_product_bloc.dart';
import '../bloc/sync_category/sync_category_bloc.dart';
import '../../../data/datasource/product_local_datasource.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSyncSection(
              context,
              title: 'Sync Product',
              description: 'Sinkronkan data produk dari server.',
              icon: Icons.shopping_cart,
              builder: (context) {
                return BlocConsumer<SyncProductBloc, SyncProductState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      error: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      loaded: (productResponseModel) {
                        ProductLocalDatasource.instance.deleteAllProducts();
                        ProductLocalDatasource.instance.insertProducts(
                          productResponseModel.data!,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sync Product Success'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      orElse: () {},
                    );
                  },
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      orElse: () => ElevatedButton.icon(
                        icon: const Icon(Icons.sync),
                        label: const Text('Sync Product'),
                        onPressed: () {
                          context
                              .read<SyncProductBloc>()
                              .add(const SyncProductEvent.syncProduct());
                        },
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            _buildSyncSection(
              context,
              title: 'Sync Order',
              description: 'Sinkronkan data pesanan dari server.',
              icon: Icons.receipt_long,
              builder: (context) {
                return BlocConsumer<SyncOrderBloc, SyncOrderState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      error: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      loaded: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sync Order Success'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      orElse: () {},
                    );
                  },
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      orElse: () => ElevatedButton.icon(
                        icon: const Icon(Icons.sync_alt),
                        label: const Text('Sync Order'),
                        onPressed: () {
                          context
                              .read<SyncOrderBloc>()
                              .add(const SyncOrderEvent.syncOrder());
                        },
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            _buildSyncSection(
              context,
              title: 'Sync Category',
              description: 'Sinkronkan data category dari server.',
              icon: Icons.receipt_long,
              builder: (context) {
                return BlocConsumer<SyncCategoryBloc, SyncCategoryState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      error: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      loaded: (categoryResponseModel) {
                        ProductLocalDatasource.instance.deleteAllCategories();
                        ProductLocalDatasource.instance.insertCategories(
                          categoryResponseModel.data!,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sync Category Success'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      orElse: () {},
                    );
                  },
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      orElse: () => ElevatedButton.icon(
                        icon: const Icon(Icons.sync_alt),
                        label: const Text('Sync Category'),
                        onPressed: () {
                          context
                              .read<SyncCategoryBloc>()
                              .add(const SyncCategoryEvent.syncCategory());
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncSection(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Widget Function(BuildContext context) builder,
  }) {
    return Card(
      elevation: 4,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: AppColors.green,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            builder(context),
          ],
        ),
      ),
    );
  }
}
