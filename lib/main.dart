import 'dart:io';

import "package:flutter/foundation.dart";

import "./widgets/attendance_controllers.dart";
import "./widgets/criteria_slider.dart";
import "./widgets/joke_container.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_database/firebase_database.dart";
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';

import "/pages/about_page.dart";
import "package:flutter/services.dart";

import "/data/constant_variables.dart";
import "/data/theme_data.dart";

import "/firebase_options.dart";

import "/widgets/result_card.dart";

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BunkApp ",
      theme: themeData,
      home: const MyHomePage(),
      routes: {
        AboutPage.routeName: (context) => const AboutPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final presentLectures = TextEditingController();
  final totalLectures = TextEditingController();
  final listViewController = ScrollController();

  double currentAttendance = 0.0;
  double criteria = 75.0;

  bool isAttendanceAboveCriteria = true;
  double result = 0;

  // firebase stuff
  String updateDownloadLink = "";

  @override
  void initState() {
    super.initState();

    // code to run at initialization
    () async {
      FirebaseAnalytics.instance.logAppOpen();
      final snapshot = await FirebaseDatabase.instance.ref("links").get();
      if (snapshot.exists) {
        // cause web app is not opening this link.
        if (Platform.isAndroid || Platform.isIOS) {
          setState(() {
            updateDownloadLink =
                (snapshot.value as Map<dynamic, dynamic>)["updateDownloadLink"]
                    .toString();
          });
        }
      }
    }();
  }

  double jokeNumber = 0;
  void incrementJokeNumber() {
    jokeNumber += 1;
  }

  void updateResult() {
    double presentLecturesDouble = double.parse(presentLectures.text);
    double totalLecturesDouble = double.parse(totalLectures.text);

    isAttendanceAboveCriteria =
        (presentLecturesDouble / totalLecturesDouble) * 100 >= criteria;

    if (isAttendanceAboveCriteria) {
      setState(() {
        // calculating result
        result =
            (((presentLecturesDouble * 100) / criteria) - totalLecturesDouble);
        // updating currentAttendance
        currentAttendance = (presentLecturesDouble / totalLecturesDouble) * 100;
      });
    } else {
      setState(() {
        // calculating result
        result = (((criteria * totalLecturesDouble) -
                (presentLecturesDouble * 100)) /
            (100 - criteria));
        // updating currentAttendance
        currentAttendance = (presentLecturesDouble / totalLecturesDouble) * 100;
      });
    }
  }

  void updateCriteriaFromSlider(double value) {
    setState(() {
      criteria = value;
      updateResult();
    });
  }

  double calcResponsivePadding(double padding, [double? webAppPadding]) {
    return (MediaQuery.of(context).size.width) < maxMobileViewWidth
        ? padding
        : (MediaQuery.of(context).size.width - webViewWidth) / 2 +
            (webAppPadding ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
      appBar: _buildAppBar(),
      body: kIsWeb && defaultTargetPlatform == TargetPlatform.android
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Download the Android app!",
                    style: TextStyle(
                        fontFamily: "Circular",
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "BunkApp is much better as a standalone Android app. You can use it even when you're offline!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      launchUrl(
                          Uri.parse(
                              "https://www.dropbox.com/sh/d48thk1tc5flqtb/AAAlvTKMiMPS-qosqcddJBuSa?dl=0"),
                          mode: LaunchMode.externalApplication);
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: themeColor),
                    child: const Text("Download"),
                  )
                ],
              )),
            )
          : ListView(controller: listViewController, children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 24,
                    left: calcResponsivePadding(24),
                    right: calcResponsivePadding(24)),
                child: ResultCard(
                  currentAttendance: currentAttendance,
                  result: result,
                  isAttendanceAboveCriteria: isAttendanceAboveCriteria,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // CriteriaSlider's padding is within the widget.
              // Because of complex padding.
              CriteriaSlider(
                  criteria: criteria,
                  updateCriteriaFromSlider: updateCriteriaFromSlider),
              const SizedBox(
                height: 22,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: calcResponsivePadding(24)),
                child: AttendanceFields(
                    presentLectures: presentLectures,
                    totalLectures: totalLectures,
                    updateResult: updateResult,
                    incrementJokeNumber: incrementJokeNumber,
                    listViewController: listViewController),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: calcResponsivePadding(30, 30), vertical: 40),
                child: JokeContainer(jokeNumber),
              )
            ]),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors
              .transparent, // fixes the issue that doesn't dimes the color even when the modal sheet is opened.
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color.fromARGB(255, 251, 251, 251),
          systemNavigationBarIconBrightness: Brightness.dark),
      backgroundColor: themeColor,
      title: const Text(
        "BunkApp",
        style: TextStyle(
            // fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 235, 235, 235),
            fontFamily: "Circular",
            fontWeight: FontWeight.w500),
      ),
      actions: [
        if (updateDownloadLink.isNotEmpty)
          IconButton(
            onPressed: () {
              launchUrl(Uri.parse(updateDownloadLink),
                  mode: LaunchMode.externalApplication);
            },
            icon: const Icon(
              Icons.update_outlined,
              size: 30,
              color: Color.fromARGB(255, 245, 245, 245),
            ),
          ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AboutPage.routeName);
          },
          icon: const Icon(
            Icons.info,
            size: 30,
            color: Color.fromARGB(255, 245, 245, 245),
          ),
        ),
        const SizedBox(
          width: 8,
        )
      ],
    );
  }

  @override
  void dispose() {
    presentLectures.dispose();
    totalLectures.dispose();

    listViewController.dispose();

    super.dispose();
  }
}
