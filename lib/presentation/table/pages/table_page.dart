import 'package:flutter/material.dart';
import '../../../components/spaces.dart';
import '../../../components/buttons.dart';
import '../dialogs/form_table_dialog.dart';
import '../widgets/card_table_widget.dart';
import '../../../core/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/get_table/get_table_bloc.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  void initState() {
    context.read<GetTableBloc>().add(const GetTableEvent.getTables());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Table Management",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                ),
              ),
              Button.filled(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const FormTableDialog(),
                  );
                },
                label: 'Generate Table',
                height: 48.0,
                width: 200.0,
              ),
            ],
          ),
          const SpaceHeight(24.0),
          BlocBuilder<GetTableBloc, GetTableState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return const SizedBox.shrink();
                },
                loading: () {
                  return const CircularProgressIndicator();
                },
                success: (tables) {
                  if (tables.isEmpty) {
                    return const Center(
                      child: Text('No table available'),
                    );
                  }
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.0,
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: tables.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return CardTableWidget(
                        table: tables[index],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
