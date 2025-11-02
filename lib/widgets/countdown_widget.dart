import 'package:flutter/material.dart';
import '../services/retirement_service.dart';

class CountdownWidget extends StatelessWidget {
  final RetirementCalculation calculation;
  final CountdownType countdownType;

  const CountdownWidget({
    super.key,
    required this.calculation,
    required this.countdownType,
  });

  String _getCountdownValue() {
    switch (countdownType) {
      case CountdownType.days:
        return calculation.totalDays.toString();
      case CountdownType.months:
        return calculation.totalMonths.toString();
      case CountdownType.years:
        return calculation.totalYears.toString();
    }
  }

  String _getCountdownLabel() {
    switch (countdownType) {
      case CountdownType.days:
        return 'zile';
      case CountdownType.months:
        return 'luni';
      case CountdownType.years:
        return 'ani';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getCountdownValue(),
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getCountdownLabel(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
