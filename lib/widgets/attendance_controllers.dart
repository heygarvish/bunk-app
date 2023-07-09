import 'package:flutter/material.dart';

import '../data/constant_variables.dart';

class AttendanceFields extends StatefulWidget {
  final TextEditingController presentLectures;
  final TextEditingController totalLectures;

  final ScrollController listViewController;

  final Function updateResult;
  final Function incrementJokeNumber;

  const AttendanceFields(
      {super.key,
      required this.presentLectures,
      required this.totalLectures,
      required this.updateResult,
      required this.incrementJokeNumber,
      required this.listViewController});

  @override
  State<AttendanceFields> createState() => _AttendanceControllersState();
}

class _AttendanceControllersState extends State<AttendanceFields> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.updateResult();

      // fetch new joke
      widget.incrementJokeNumber();

      // closing on-screen keyboard
      FocusManager.instance.primaryFocus?.unfocus();

      // scrolling to top
      widget.listViewController.jumpTo(0);
    }
  }

  TextFormField _buildTextFormField(
      {required String fieldName,
      required TextEditingController controller,
      required String? Function(String?)? validatorFunction}) {
    return TextFormField(
        controller: controller,
        // autofocus: true,
        keyboardType: TextInputType.number,
        validator: validatorFunction,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          onSubmit();
        },
        style: const TextStyle(
            fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          errorMaxLines: 2,
          errorStyle: const TextStyle(
              fontFamily: fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w500),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                width: 3.5, color: Theme.of(context).colorScheme.error),
          ),
          contentPadding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 1.5, style: BorderStyle.solid, color: themeColor)),
          filled: true,
          border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          labelText: fieldName,
          labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFamily: fontFamily,
              color: const Color.fromARGB(175, 0, 0, 0),
              fontWeight: FontWeight.w500,
              fontSize: 16.5),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextFormField(
              fieldName: "Present Lectures",
              controller: widget.presentLectures,
              validatorFunction: (value) {
                if (!value!.isNotEmpty) {
                  return "This is a required field.";
                } else if (double.parse(value) >
                    double.parse(widget.totalLectures.text)) {
                  return "How can you attend more lectures than total?";
                }
                return null;
              }),
          const SizedBox(
            height: 16,
          ),
          _buildTextFormField(
              fieldName: "Total Lectures",
              controller: widget.totalLectures,
              validatorFunction: (value) {
                if (!value!.isNotEmpty) {
                  return "This is a required field.";
                } else if (double.parse(value) > 10000) {
                  return "Are you kidding me!?";
                }
                return null;
              }),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.done),
            label: const Text("Save Attendance",
                style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w500)),
            style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(16)),
          )
        ],
      ),
    );
  }
}
