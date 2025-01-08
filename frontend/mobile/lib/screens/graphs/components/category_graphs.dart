import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/model/transaction_model.dart';
import 'package:mobile/screens/graphs/components/month_amount_mondel.dart';
import 'package:mobile/screens/settings/category/category_settings_screen.dart';
import 'package:mobile/screens/settings/components/setting_widget.dart';
import 'package:mobile/screens/settings/general/general_settings_screen.dart';
import 'package:mobile/screens/settings/import_export/import_export_screen.dart';
import "package:mobile/common/utils/utils.dart";

class CategoryGraphs extends StatefulWidget {
  /// Pagina dei grafici
  const CategoryGraphs({super.key, required this.transactions});
  final List<TransactionModel> transactions;

  @override
  State<CategoryGraphs> createState() => _CategoryGraphsState();
}

class _CategoryGraphsState extends State<CategoryGraphs> {
  final CarouselSliderController carouselController =
      CarouselSliderController();
  int currentPage = 0;
  List<String> monthsName = [
    "Gen",
    "Feb",
    "Mar",
    "Apr",
    "Mag",
    "Giu",
    "Lug",
    "Ago",
    "Set",
    "Ott",
    "Nov",
    "Dic"
  ];
  List<MonthAmountMondel> monthsExpenses = [];
  List<MonthAmountMondel> monthsIncomes = [];

  LineChartData get expensesData => LineChartData(
      minX: 0,
      maxX: 5,
      minY: 0,
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
            isCurved: true,
            color: Colors.red,
            barWidth: 8,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            spots: [
              FlSpot(0, monthsExpenses[5].amount),
              FlSpot(1, monthsExpenses[4].amount),
              FlSpot(2, monthsExpenses[3].amount),
              FlSpot(3, monthsExpenses[2].amount),
              FlSpot(4, monthsExpenses[1].amount),
              FlSpot(5, monthsExpenses[0].amount),
            ]),
      ],
      borderData: FlBorderData(
        show: false,
      ),
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 32,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(color: Colors.white);
              Widget text;
              switch (value.toInt()) {
                case 0:
                  text = Text(
                    monthsExpenses[5].name,
                    style: style,
                  );

                  break;
                case 1:
                  text = Text(
                    monthsExpenses[4].name,
                    style: style,
                  );

                  break;
                case 2:
                  text = Text(
                    monthsExpenses[3].name,
                    style: style,
                  );

                  break;
                case 3:
                  text = Text(
                    monthsExpenses[2].name,
                    style: style,
                  );

                  break;
                case 4:
                  text = Text(
                    monthsExpenses[1].name,
                    style: style,
                  );

                  break;
                case 5:
                  text = Text(
                    monthsExpenses[0].name,
                    style: style,
                  );

                  break;
                default:
                  text = const Text(
                    "",
                    style: style,
                  );
              }

              return SideTitleWidget(
                space: 10,
                axisSide: AxisSide.bottom,
                child: text,
              );
            },
          )),
          leftTitles: const AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false))));

              LineChartData get incomesData => LineChartData(
      minX: 0,
      maxX: 5,
      minY: 0,
      lineBarsData: <LineChartBarData>[
        LineChartBarData(
            isCurved: true,
            color: Colors.green,
            barWidth: 8,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
            spots: [
              FlSpot(0, monthsIncomes[5].amount),
              FlSpot(1, monthsIncomes[4].amount),
              FlSpot(2, monthsIncomes[3].amount),
              FlSpot(3, monthsIncomes[2].amount),
              FlSpot(4, monthsIncomes[1].amount),
              FlSpot(5, monthsIncomes[0].amount),
            ]),
      ],
      borderData: FlBorderData(
        show: false,
      ),
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 32,
            getTitlesWidget: (value, meta) {
              const style = TextStyle(color: Colors.white);
              Widget text;
              switch (value.toInt()) {
                case 0:
                  text = Text(
                    monthsIncomes[5].name,
                    style: style,
                  );

                  break;
                case 1:
                  text = Text(
                    monthsIncomes[4].name,
                    style: style,
                  );

                  break;
                case 2:
                  text = Text(
                    monthsIncomes[3].name,
                    style: style,
                  );

                  break;
                case 3:
                  text = Text(
                    monthsIncomes[2].name,
                    style: style,
                  );

                  break;
                case 4:
                  text = Text(
                    monthsIncomes[1].name,
                    style: style,
                  );

                  break;
                case 5:
                  text = Text(
                    monthsIncomes[0].name,
                    style: style,
                  );

                  break;
                default:
                  text = const Text(
                    "",
                    style: style,
                  );
              }

              return SideTitleWidget(
                space: 10,
                axisSide: AxisSide.bottom,
                child: text,
              );
            },
          )),
          leftTitles: const AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false))));

  @override
  void initState() {
    super.initState();
    initData();
  
  }

  initData() {
    final now = DateTime.now();

    monthsExpenses = List.generate(
      6,
      (index) {
        double amount = 0;
        final date = DateTime(now.year, now.month - index);
        for (var element in widget.transactions) {
            if (DateUtils.isSameMonth(element.date, date) &&
                element.type == Type.uscita) {
              amount += element.amount;
            }
          }

        return MonthAmountMondel(
            date: date, amount: amount, name: monthsName[date.month - 1]);
      },
    );
    monthsIncomes = List.generate(
      6,
      (index) {
        double amount = 0;
        final date = DateTime(now.year, now.month - index);
        for (var element in widget.transactions) {
          if (DateUtils.isSameMonth(element.date, date) &&
              element.type == Type.entrata) {
            amount += element.amount;
          }
        }
        return MonthAmountMondel(
            date: date, amount: amount, name: monthsName[date.month - 1]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: 30,
                spreadRadius: -8),
          ],
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider(
                  carouselController: carouselController,
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                  ),
                  items: [
                    Column(
                      children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("USCITE")),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LineChart(
                              expensesData,
                              curve: Curves.ease,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("ENTRATE")),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LineChart(
                              incomesData,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
            const SizedBox(
              height: 17,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (index) {
                  bool isSelected = currentPage == index;
                  return AnimatedContainer(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8,
                      duration: const Duration(milliseconds: 300));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
