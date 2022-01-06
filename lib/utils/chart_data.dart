import 'package:flutter/material.dart';
import 'package:anthem/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
 
List<Color> gradientColors = [
  Constants.kPrimaryColor,
  Constants.kQuartaryColor,
];

LineChartData getChartData() {
  return LineChartData(
    gridData: FlGridData(
      show: false,
      drawVerticalLine: false,
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      bottomTitles: SideTitles(
        showTitles: true,
        reservedSize: 0,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
            fontSize: 13),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return 'T';
            case 2:
              return 'W';
            case 3:
              return 'T';
            case 4:
              return 'F';
            case 5:
              return 'S';
            case 6:
              return 'S';
            default:
              return 'M';
          }
        },
        margin: 0,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        interval: 2,
        getTextStyles: (context, value) => const TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        getTitles: (value) {
          return value.toInt().toString();
        },
        reservedSize: 0,
        margin: 25,
      ),
    ),
    borderData: FlBorderData(
        show: false),
    minX: 0,
    maxX: 6,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: const [
          FlSpot(0, 2),
          FlSpot(1, 5),
          FlSpot(2, 3),
          FlSpot(3, 4),
          FlSpot(4, 4),
          FlSpot(5, 4),
          FlSpot(6, 4),
        ],
        isCurved: true,
        colors: gradientColors,
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false
        ),
      ),
    ],
  );
}