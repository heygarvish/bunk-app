import '../data/constant_variables.dart';
import 'package:flutter/material.dart';

class CriteriaSlider extends StatelessWidget {
  final double criteria;
  final Function updateCriteriaFromSlider;

  const CriteriaSlider(
      {super.key,
      required this.criteria,
      required this.updateCriteriaFromSlider});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  (MediaQuery.of(context).size.width) < maxMobileViewWidth
                      ? 30
                      : (MediaQuery.of(context).size.width - webViewWidth) / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Attendance Criteria",
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "${criteria.truncate()}%",
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 18.5,
                    color: themeColor.withAlpha(180)),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  (MediaQuery.of(context).size.width) < maxMobileViewWidth
                      ? 6
                      : (MediaQuery.of(context).size.width - webViewWidth) / 2 -
                          24),
          child: SizedBox(
            height: 36,
            child: Slider(
              min: 50,
              max: 95,
              divisions: 9,
              value: criteria,
              onChanged: (value) {
                updateCriteriaFromSlider(value);
              },
              thumbColor: themeColor,
              activeColor: themeColor,
              inactiveColor: themeColor.withAlpha(62),
            ),
          ),
        )
      ],
    );
  }
}
