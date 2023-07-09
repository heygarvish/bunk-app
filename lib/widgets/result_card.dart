import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final double currentAttendance;
  final double result;
  final bool isAttendanceAboveCriteria;

  const ResultCard(
      {super.key,
      required this.currentAttendance,
      required this.result,
      required this.isAttendanceAboveCriteria});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isAttendanceAboveCriteria
              ? Colors.green.shade200
              : Colors.red.shade200,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: isAttendanceAboveCriteria
                    ? Colors.green.shade200.withAlpha(165)
                    : Colors.red.shade200.withAlpha(165),
                offset: const Offset(0, 4),
                blurRadius: 35,
                blurStyle: BlurStyle.normal),
          ]),
      height: ((MediaQuery.of(context).size.width) < 450
              ? MediaQuery.of(context).size.width
              : 450 - 50) *
          0.72,
      child: Center(
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Text(
                result.truncate().toString(),
                style: TextStyle(
                    fontSize: 75,
                    height: 1.02,
                    fontFamily: 'Circular',
                    color: isAttendanceAboveCriteria
                        ? Colors.green.shade900
                        : Colors.red.shade900),
              )),
              Text(
                (isAttendanceAboveCriteria)
                    ? "Lectures you can bunk.\nYour current attendance \nis ${currentAttendance.toStringAsFixed(2)}%."
                    : "Lectures needed.\nYour current attendance \nis ${currentAttendance.toStringAsFixed(2)}%.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.25,
                    fontSize: 16.5,
                    letterSpacing: -0.05,
                    fontFamily: "Circular",
                    fontWeight: FontWeight.w500,
                    color: isAttendanceAboveCriteria
                        ? Colors.green.shade900.withOpacity(0.95)
                        : Colors.red.shade900.withOpacity(0.95)),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
