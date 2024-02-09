
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class _BarChart extends StatelessWidget {
  static var datasSem = [0.0,0.0,0.0,0.0,0.0,0.0,0.0];
  static var labelsSem = ["Mn","Te","Wd","Tu","Fr","St","Sn"];
  const _BarChart();
  void setDatasSem(var tab){
    _BarChart.datasSem=tab;
  }
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 4,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Colors.blue,//AppColors.contentColorCyan
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );
//AppColors.contentColorBlue.darken(20),
  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = _BarChart.labelsSem[0];
        break;
      case 1:
        text = _BarChart.labelsSem[1];
        break;
      case 2:
        text = _BarChart.labelsSem[2];
        break;
      case 3:
        text = _BarChart.labelsSem[3];
        break;
      case 4:
        text = _BarChart.labelsSem[4];
        break;
      case 5:
        text = _BarChart.labelsSem[5];
        break;
      case 6:
        text = _BarChart.labelsSem[6];
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      Colors.blue,
      Colors.blue
      //AppColors.contentColorBlue.darken(20),
      //AppColors.contentColorCyan,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups => [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: _BarChart.datasSem[0],
          gradient: _barsGradient,
          width: 16,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: _BarChart.datasSem[1],
          gradient: _barsGradient,
          width: 16,
        )
      ],
      showingTooltipIndicators: [0],

    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
          toY: _BarChart.datasSem[2],
          gradient: _barsGradient,
          width: 16,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: _BarChart.datasSem[3],
          gradient: _barsGradient,
          width: 16,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 4,
      barRods: [
        BarChartRodData(
          toY: _BarChart.datasSem[4],
          gradient: _barsGradient,
          width: 16,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 5,
      barRods: [
        BarChartRodData(
          toY: _BarChart.datasSem[5],
          gradient: _barsGradient,
          width: 16,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 6,
      barRods: [
        BarChartRodData(
          toY: _BarChart.datasSem[6],
          gradient: _barsGradient,
          width: 16,
        )
      ],
      showingTooltipIndicators: [0],
    ),
  ];
}

class BarChartSample3 extends StatefulWidget {
  const BarChartSample3({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample3State();

  static void setDatasSem(var tab){
    _BarChart.datasSem=tab;
  }
  static void setLbl(var tab){
    _BarChart.labelsSem=tab;
  }
}

class BarChartSample3State extends State<BarChartSample3> {


  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 250,
      height: 130,
      child: _BarChart(),
      );
  }
}