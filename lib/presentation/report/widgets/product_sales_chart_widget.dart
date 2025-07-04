import 'package:flutter/material.dart';
import '../../../components/spaces.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../data/model/response/product_sales_response_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first



class ProductSalesChartWidgets extends StatefulWidget {
  final String title;
  final String searchDateFormatted;
  final List<ProductSales> productSales;
  const ProductSalesChartWidgets({
    super.key,
    required this.title,
    required this.searchDateFormatted,
    required this.productSales,
  });

  @override
  State<ProductSalesChartWidgets> createState() =>
      _ProductSalesChartWidgetsState();
}

class _ProductSalesChartWidgetsState extends State<ProductSalesChartWidgets> {
  Map<String, double> dataMap2 = {};

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() {
    for (var data in widget.productSales) {
      dataMap2[data.productName ?? 'Unknown'] =
          double.parse(data.totalQuantity!);
    }
  }

  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
    const Color(0xfff0932b),
    const Color(0xff6ab04c),
    const Color(0xfff8a5c2),
    const Color(0xffe84393),
    const Color(0xfffd79a8),
    const Color(0xffa29bfe),
    const Color(0xff00b894),
    const Color(0xffe17055),
    const Color(0xffd63031),
    const Color(0xffa29bfe),
    const Color(0xff6c5ce7),
    const Color(0xff00cec9),
    const Color(0xfffad390),
    const Color(0xff686de0),
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            const SpaceHeight(24.0),
            Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 16.0),
              ),
            ),
            Center(
              child: Text(
                widget.searchDateFormatted,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SpaceHeight(16.0),
            PieChart(
              dataMap: dataMap2,
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.disc,
              ringStrokeWidth: 32,
              // centerText: "HYBRID",
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: false,
                showChartValuesOutside: false,
                decimalPlaces: 0,
              ),
              // gradientList: ---To add gradient colors---
              // emptyColorGradient: ---Empty Color gradient---
            )
          ],
        ),
      ),
    );
  }
}
