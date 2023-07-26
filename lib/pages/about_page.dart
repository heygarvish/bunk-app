import '../data/constant_variables.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';

class AboutPage extends StatefulWidget {
  static const String routeName = "/about-page";

  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String garvishProfileLink = "https://www.linkedin.com/in/heygarvish";
  String garvishProfileImage = "assets/images/imgarvish.jpg";

  final jjRecognizer = TapGestureRecognizer()
    ..onTap = () async {
      launchUrl(Uri.parse("https://www.linkedin.com/in/jaiminjariwala"),
          mode: LaunchMode.externalApplication);
      await FirebaseAnalytics.instance
          .logEvent(name: "click_event_jaimin_jariwala");
    };

  final ipRecognizer = TapGestureRecognizer()
    ..onTap = () async {
      launchUrl(Uri.parse("https://ishanpatel.me"),
          mode: LaunchMode.externalApplication);
      await FirebaseAnalytics.instance
          .logEvent(name: "click_event_ishan_patel");
    };

  @override
  void initState() {
    super.initState();
    () async {
      await FirebaseDatabase.instance
          .ref("links/profileInfo/profilePicLink")
          .get()
          .then((value) {
        garvishProfileImage = value.value.toString();
      });
      await FirebaseDatabase.instance
          .ref("links/profileInfo/profileLink")
          .get()
          .then((value) {
        garvishProfileLink = value.value.toString();
      });
      setState(() {});
    }();
  }

  double calcResponsivePadding(double padding, [double? webPadding]) {
    return (MediaQuery.of(context).size.width) < maxMobileViewWidth
        ? padding
        : (MediaQuery.of(context).size.width - webViewWidth) / 2 +
            (webPadding ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.white),
        titleSpacing: 0,
        iconTheme:
            const IconThemeData(color: Color.fromARGB(255, 235, 235, 235)),
        backgroundColor: themeColor,
        title: const Text(
          "Developer Info",
          style: TextStyle(
              color: Color.fromARGB(255, 235, 235, 235),
              fontFamily: 'Circular',
              fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 24,
                left: calcResponsivePadding(80, 96),
                right: calcResponsivePadding(80, 96)),
            child: Image.asset(
              "assets/images/home-hero.jpg",
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: calcResponsivePadding(20)),
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 28),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: themeColor.withAlpha(35)),
                  borderRadius: BorderRadius.circular(10),
                  color: themeColor.withAlpha(15)),
              child: _buildRichText(context, 20, 17),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: calcResponsivePadding(20)),
            child: InkWell(
              onTap: () async {
                launchUrl(Uri.parse(garvishProfileLink),
                    mode: LaunchMode.externalApplication);
                await FirebaseAnalytics.instance
                    .logEvent(name: "click_event_garvish_jain");
              },
              child: Container(
                child: _buildPerson(
                    context, "Garvish Jain", "Developer", garvishProfileImage),
              ),
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: calcResponsivePadding(20)),
            margin: const EdgeInsets.symmetric(vertical: 32),
            child: const Text(
              "Version 1.1.0",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45),
            ),
          )
        ],
      ),
    );
  }

  Container _buildPerson(
      BuildContext context, String name, String expertise, String imagePath) {
    return Container(
        height: 100,
        decoration: BoxDecoration(
          color: themeColor.withAlpha(235),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: imagePath.contains("assets/images/")
                        ? Image.asset("assets/images/imgarvish.jpg")
                        : FadeInImage.assetNetwork(
                            placeholder: "assets/images/imgarvish.jpg",
                            image: imagePath,
                            imageErrorBuilder: (context, error, stackTrace) {
                              debugPrint(
                                  "can't build network widget because of the error -> $error");
                              return Image.asset("assets/images/imgarvish.jpg");
                            },
                            fit: BoxFit.contain,
                          ),
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          name,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: fontFamily,
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          expertise,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 16,
                              color: Color.fromARGB(200, 245, 245, 245),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.link,
              size: 32,
              color: Color.fromARGB(245, 236, 235, 235),
            )
          ],
        ));
  }

  Column _buildRichText(
      BuildContext context, double titleFontSize, double bodyFontSize) {
    double mediaQueryTextScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Who am I?",
                  style: TextStyle(
                      fontSize: titleFontSize * mediaQueryTextScaleFactor,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                      fontFamily: fontFamily),
                )
              ]),
            )),
        RichText(
            text: TextSpan(
                style: TextStyle(
                    color: const Color.fromARGB(150, 0, 0, 0),
                    fontFamily: fontFamily,
                    fontSize: bodyFontSize * mediaQueryTextScaleFactor,
                    height: 1.45,
                    fontWeight: FontWeight.w400),
                children: [
              const TextSpan(text: "Hello there, I'm "),
              TextSpan(
                  text: "Garvish Jain",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      launchUrl(Uri.parse(garvishProfileLink),
                          mode: LaunchMode.externalApplication);
                      await FirebaseAnalytics.instance
                          .logEvent(name: "click_event_garvish_jain");
                    },
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeColor.withAlpha(225),
                      decoration: TextDecoration.underline)),
              const TextSpan(
                  text:
                      ", a first-year CSE student who has a deep interest in tech and computer programming.")
            ])),
        Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 10),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Why I developed this app?",
                  style: TextStyle(
                      fontSize: titleFontSize * mediaQueryTextScaleFactor,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                      fontFamily: fontFamily),
                )
              ]),
            )),
        RichText(
            text: TextSpan(
                style: TextStyle(
                    color: const Color.fromARGB(150, 0, 0, 0),
                    fontFamily: fontFamily,
                    fontSize: bodyFontSize * mediaQueryTextScaleFactor,
                    height: 1.45,
                    fontWeight: FontWeight.w400),
                children: [
              const TextSpan(
                  text:
                      "My motive is it to help students keep track of their attendance requirements by calculating the number of lectures they need to attend or can miss without getting into "),
              const TextSpan(
                  text: "detention list.\n\n",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              const TextSpan(text: "Thanks to "),
              TextSpan(
                  text: "Jaimin Jariwala",
                  recognizer: jjRecognizer,
                  style: TextStyle(
                      color: themeColor.withAlpha(225),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline)),
              const TextSpan(text: " and "),
              TextSpan(
                  text: "Ishan Patel",
                  recognizer: ipRecognizer,
                  style: TextStyle(
                      color: themeColor.withAlpha(225),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline)),
              const TextSpan(
                text: " for their valuable feedback and continous support.",
              )
            ])),
        Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 10),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "Send your suggestions ;)",
                  style: TextStyle(
                      fontSize: titleFontSize * mediaQueryTextScaleFactor,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                      fontFamily: fontFamily),
                )
              ]),
            )),
        RichText(
            text: TextSpan(
                style: TextStyle(
                    color: const Color.fromARGB(150, 0, 0, 0),
                    fontFamily: fontFamily,
                    fontSize: bodyFontSize * mediaQueryTextScaleFactor,
                    height: 1.45,
                    fontWeight: FontWeight.w400),
                children: [
              const TextSpan(
                  text:
                      "Any suggestions or feature requests are appreciated and can be mailed to "),
              TextSpan(
                  text: "bunkapp0001.vs93q@silomails.com",
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(
                          Uri.parse("mailto:bunkapp0001.vs93q@silomails.com"));
                    },
                  style: TextStyle(
                      color: themeColor.withAlpha(225),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline)),
              const TextSpan(
                  text:
                      ", you can also find my contacts by clicking on the card below."),
            ]))
      ],
    );
  }

  @override
  void dispose() {
    jjRecognizer.dispose();
    ipRecognizer.dispose();
    super.dispose();
  }
}
