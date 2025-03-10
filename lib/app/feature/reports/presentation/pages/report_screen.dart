import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_management/app/core/app_core.dart';
import 'package:salon_management/app/core/extensions/extensions.dart';
import 'package:salon_management/app/core/utils/responsive.dart';

@RoutePage()
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _chartAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _chartAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<FlSpot> getDailyIncomeData() {
    return [
      FlSpot(1, 100),
      FlSpot(2, 200),
      FlSpot(3, 150),
      FlSpot(4, 180),
      FlSpot(5, 220),
      FlSpot(6, 160),
      FlSpot(7, 210),
      FlSpot(8, 250),
      FlSpot(9, 190),
      FlSpot(10, 230),
      FlSpot(11, 300),
      FlSpot(12, 270),
      FlSpot(13, 320),
      FlSpot(14, 290),
      FlSpot(15, 330),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isMobile()
          ? AppBar(
              title: Text(AppStrings.reports),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Monthly Income Overview",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),

            // Animated Fade-in Effect
            FadeTransition(
              opacity: _opacityAnimation,
              child: AnimatedBuilder(
                animation: _chartAnimation,
                builder: (context, child) {
                  return SizedBox(
                    height: .5.sw,
                    width: 1.sw,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) {
                                return Text("${value.toInt()}");
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: getDailyIncomeData().sublist(
                              0,
                              (_chartAnimation.value *
                                      getDailyIncomeData().length)
                                  .toInt(),
                            ), // Dynamically draw spots
                            isCurved: true,
                            barWidth: 4,
                            color: context.colorScheme.primary,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color:
                                  context.colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
